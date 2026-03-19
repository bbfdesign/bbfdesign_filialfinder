<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Services;

use JTL\DB\DbInterface;
use Plugin\bbfdesign_filialfinder\src\Models\Holiday;
use Plugin\bbfdesign_filialfinder\src\Models\HolidayCalendar;

/**
 * Service for holiday management including iCal calendar synchronization.
 *
 * Handles syncing holidays from iCal calendar subscriptions, checking
 * whether a given date is a holiday, and computing effective opening
 * hours considering holiday overrides.
 */
class HolidayService
{
    private Holiday $holidayModel;
    private HolidayCalendar $calendarModel;

    /**
     * @param DbInterface $db Database interface
     */
    public function __construct(
        private readonly DbInterface $db
    ) {
        $this->holidayModel = new Holiday($db);
        $this->calendarModel = new HolidayCalendar($db);
    }

    /**
     * Sync holidays from an iCal calendar subscription.
     *
     * Fetches the iCal file via cURL, parses VEVENT entries, and saves
     * them as holidays in the database. Existing holidays for this
     * calendar are removed before importing.
     *
     * @param int $calendarId Calendar ID to sync
     * @return array{success: bool, imported: int, errors: string[]}
     */
    public function syncCalendar(int $calendarId): array
    {
        $result = ['success' => false, 'imported' => 0, 'errors' => []];

        $calendar = $this->calendarModel->getById($calendarId);
        if ($calendar === null) {
            $result['errors'][] = 'Kalender nicht gefunden.';
            return $result;
        }

        if (empty($calendar->ical_url)) {
            $result['errors'][] = 'Keine iCal-URL konfiguriert.';
            return $result;
        }

        // Fetch iCal content via cURL
        $icalContent = $this->fetchIcalContent((string)$calendar->ical_url);
        if ($icalContent === null) {
            $result['errors'][] = 'iCal-Datei konnte nicht abgerufen werden.';
            return $result;
        }

        // Parse VEVENT entries
        $holidays = $this->parseIcal($icalContent);
        if (empty($holidays)) {
            $result['errors'][] = 'Keine Feiertage in der iCal-Datei gefunden.';
            return $result;
        }

        // Remove existing holidays for this calendar and import new ones
        $this->holidayModel->deleteByCalendarId($calendarId);

        foreach ($holidays as $holidayData) {
            try {
                $holidayData['calendar_id'] = $calendarId;
                $holidayData['applies_to_all'] = 1;
                $holidayData['default_closed'] = 1;
                $this->holidayModel->save($holidayData);
                $result['imported']++;
            } catch (\Exception $e) {
                $result['errors'][] = 'Fehler beim Import: ' . $holidayData['name'] . ' - ' . $e->getMessage();
            }
        }

        // Update last sync timestamp
        $this->calendarModel->updateLastSync($calendarId);

        $result['success'] = $result['imported'] > 0;

        return $result;
    }

    /**
     * Parse iCal content and extract VEVENT entries.
     *
     * Handles DTSTART in both date (20261225) and datetime (20261225T100000Z) format.
     * Detects RRULE:FREQ=YEARLY for recurring holidays.
     *
     * @param string $icalContent Raw iCal file content
     * @return array<int, array{name: string, date: string, is_recurring: int, type: string}>
     */
    public function parseIcal(string $icalContent): array
    {
        $holidays = [];

        // Unfold long lines per RFC 5545 (lines starting with space/tab are continuations)
        $icalContent = preg_replace('/\r\n[\s\t]/', '', $icalContent) ?? $icalContent;
        $icalContent = str_replace("\r\n", "\n", $icalContent);
        $icalContent = str_replace("\r", "\n", $icalContent);

        // Extract VEVENT blocks
        if (!preg_match_all('/BEGIN:VEVENT(.+?)END:VEVENT/s', $icalContent, $eventMatches)) {
            return [];
        }

        foreach ($eventMatches[1] as $eventBlock) {
            $name = null;
            $date = null;
            $isRecurring = 0;

            // Extract SUMMARY
            if (preg_match('/^SUMMARY[;:](.*)$/m', $eventBlock, $summaryMatch)) {
                $name = trim($summaryMatch[1]);
                // Handle encoded characters
                $name = str_replace(['\\,', '\\;', '\\n', '\\N'], [',', ';', "\n", "\n"], $name);
                $name = trim($name);
            }

            // Extract DTSTART (date or datetime format)
            if (preg_match('/^DTSTART[^:]*:(\d{4})(\d{2})(\d{2})/m', $eventBlock, $dateMatch)) {
                $date = $dateMatch[1] . '-' . $dateMatch[2] . '-' . $dateMatch[3];
            }

            // Check for RRULE with YEARLY frequency
            if (preg_match('/^RRULE:.*FREQ=YEARLY/m', $eventBlock)) {
                $isRecurring = 1;
            }

            if ($name !== null && $date !== null) {
                $holidays[] = [
                    'name'         => $name,
                    'date'         => $date,
                    'is_recurring' => $isRecurring,
                    'type'         => 'holiday',
                ];
            }
        }

        return $holidays;
    }

    /**
     * Check if a given date is a holiday for a specific branch.
     *
     * Returns the first matching holiday, or null if the date is not a holiday.
     * When branchId is 0, only global holidays (applies_to_all) are checked.
     *
     * @param string $date     Date in Y-m-d format
     * @param int    $branchId Branch ID (0 for global check)
     * @return object|null The matching holiday or null
     */
    public function isHoliday(string $date, int $branchId = 0): ?object
    {
        if ($branchId > 0) {
            $holidays = $this->holidayModel->getForBranch($branchId, $date);
        } else {
            $holidays = $this->holidayModel->getByDate($date);
        }

        return !empty($holidays) ? $holidays[0] : null;
    }

    /**
     * Get effective opening hours for a branch on a given date.
     *
     * Priority: holidays > special days > regular hours.
     * If a holiday exists with an open override, those times are used.
     * If a holiday exists and is marked as closed, the branch is closed.
     * Otherwise, special day overrides or regular hours apply.
     *
     * @param int                          $branchId     Branch ID
     * @param string                       $date         Date in Y-m-d format
     * @param array<int, object|array>     $regularHours Regular opening hours (indexed by day_of_week 0-6)
     * @param array<int, object|array>     $specialDays  Special day entries for the branch
     * @return array{is_open: bool, open_time: string|null, close_time: string|null, reason: string, holiday: object|null}
     */
    public function getEffectiveHoursForDate(
        int $branchId,
        string $date,
        array $regularHours,
        array $specialDays
    ): array {
        $result = [
            'is_open'    => false,
            'open_time'  => null,
            'close_time' => null,
            'reason'     => 'closed',
            'holiday'    => null,
        ];

        // 1. Check holidays first (highest priority)
        $holiday = $this->isHoliday($date, $branchId);
        if ($holiday !== null) {
            $result['holiday'] = $holiday;

            if ((int)$holiday->open_override === 1) {
                // Holiday with open override — branch is open with special hours
                $result['is_open'] = true;
                $result['open_time'] = $holiday->open_time;
                $result['close_time'] = $holiday->close_time;
                $result['reason'] = 'holiday_open';
                return $result;
            }

            if ((int)$holiday->default_closed === 1) {
                // Holiday — branch is closed
                $result['is_open'] = false;
                $result['reason'] = 'holiday_closed';
                return $result;
            }
        }

        // 2. Check special days (second priority)
        $dateString = $date;
        foreach ($specialDays as $specialDay) {
            $specialDay = (object)$specialDay;
            $sdDate = $specialDay->date ?? '';

            if ($sdDate === $dateString) {
                if ((int)($specialDay->is_closed ?? 0) === 1) {
                    $result['is_open'] = false;
                    $result['reason'] = 'special_day_closed';
                    return $result;
                }

                $result['is_open'] = true;
                $result['open_time'] = $specialDay->open_time ?? null;
                $result['close_time'] = $specialDay->close_time ?? null;
                $result['reason'] = 'special_day';
                return $result;
            }
        }

        // 3. Fall back to regular hours
        $dayOfWeek = (int)date('N', strtotime($date)) - 1; // 0=Mo, 6=So

        if (isset($regularHours[$dayOfWeek])) {
            $hours = (object)$regularHours[$dayOfWeek];
            $isOpen = (int)($hours->is_open ?? 0) === 1;

            $result['is_open'] = $isOpen;
            $result['open_time'] = $isOpen ? ($hours->open_time_1 ?? null) : null;
            $result['close_time'] = $isOpen ? ($hours->close_time_1 ?? null) : null;
            $result['reason'] = $isOpen ? 'regular' : 'regular_closed';
        }

        return $result;
    }

    /**
     * Get upcoming open Sundays formatted for frontend display.
     *
     * Returns open Sundays with highlight information for use
     * in templates and frontend widgets.
     *
     * @return array<int, array{id: int, name: string, date: string, date_formatted: string, open_time: string|null, close_time: string|null, highlight: bool, highlight_text: string|null, note: string|null}>
     */
    public function getOpenSundaysForFrontend(): array
    {
        $openSundays = $this->holidayModel->getOpenSundays();
        $result = [];

        foreach ($openSundays as $sunday) {
            $timestamp = strtotime((string)$sunday->date);

            $result[] = [
                'id'             => (int)$sunday->id,
                'name'           => (string)$sunday->name,
                'date'           => (string)$sunday->date,
                'date_formatted' => date('d.m.Y', $timestamp),
                'open_time'      => $sunday->open_time ?? null,
                'close_time'     => $sunday->close_time ?? null,
                'highlight'      => (int)$sunday->highlight === 1,
                'highlight_text' => $sunday->highlight_text ?? null,
                'note'           => $sunday->note ?? null,
            ];
        }

        return $result;
    }

    /**
     * Fetch iCal content from a remote URL via cURL.
     *
     * Uses a 10-second timeout and sends a User-Agent header.
     *
     * @param string $url The iCal URL to fetch
     * @return string|null The iCal content or null on failure
     */
    private function fetchIcalContent(string $url): ?string
    {
        $ch = curl_init();

        curl_setopt_array($ch, [
            CURLOPT_URL            => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_MAXREDIRS      => 3,
            CURLOPT_TIMEOUT        => 10,
            CURLOPT_CONNECTTIMEOUT => 5,
            CURLOPT_USERAGENT      => 'BBF-Filialfinder/1.0 (JTL-Shop Plugin)',
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_HTTPHEADER     => [
                'Accept: text/calendar, application/ics',
            ],
        ]);

        $response = curl_exec($ch);
        $httpCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($response === false || $httpCode !== 200) {
            return null;
        }

        return (string)$response;
    }
}
