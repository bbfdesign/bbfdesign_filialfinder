<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Services;

use Plugin\bbfdesign_filialfinder\src\Models\Setting;

class OpeningStatusService
{
    /** @var array<string, string> */
    private static array $dayNames = [
        0 => 'Montag',
        1 => 'Dienstag',
        2 => 'Mittwoch',
        3 => 'Donnerstag',
        4 => 'Freitag',
        5 => 'Samstag',
        6 => 'Sonntag',
    ];

    public function __construct(
        private readonly Setting $settings
    ) {}

    /**
     * Get the current opening status for a branch.
     *
     * @param array<string, mixed> $branch
     * @param object[] $hours
     * @param object[] $specialDays
     * @return array{status: string, text: string, cssClass: string, nextOpening: string|null}
     */
    public function getStatus(array $branch, array $hours, array $specialDays): array
    {
        $allSettings = $this->settings->getAll();
        $timezone = new \DateTimeZone($allSettings['status_timezone'] ?? 'Europe/Berlin');
        $now = new \DateTime('now', $timezone);
        $currentDate = $now->format('Y-m-d');
        $currentTime = $now->format('H:i:s');
        $dayOfWeek = ((int)$now->format('N')) - 1; // 0=Mo, 6=So

        $openText = $allSettings['status_open_text'] ?? 'Jetzt geöffnet';
        $closedText = $allSettings['status_closed_text'] ?? 'Jetzt geschlossen';
        $openingSoonText = $allSettings['status_opening_soon_text'] ?? 'Öffnet bald';
        $closingSoonText = $allSettings['status_closing_soon_text'] ?? 'Schließt bald';
        $openingSoonMinutes = (int)($allSettings['status_opening_soon_minutes'] ?? 30);
        $closingSoonMinutes = (int)($allSettings['status_closing_soon_minutes'] ?? 30);

        // 1. Check special days
        foreach ($specialDays as $sd) {
            if ($sd->date === $currentDate) {
                if ((int)$sd->is_closed) {
                    $note = !empty($sd->note) ? ' · ' . $sd->note : '';
                    return [
                        'status'      => 'closed',
                        'text'        => $closedText . $note,
                        'cssClass'    => 'bbf-filialfinder-status--closed',
                        'nextOpening' => $this->findNextOpening($hours, $specialDays, $now, $timezone),
                    ];
                }
                // Special day with custom hours
                if (!empty($sd->open_time) && !empty($sd->close_time)) {
                    return $this->evaluateTimeRange(
                        $currentTime,
                        $sd->open_time,
                        $sd->close_time,
                        $openText,
                        $closedText,
                        $openingSoonText,
                        $closingSoonText,
                        $openingSoonMinutes,
                        $closingSoonMinutes,
                        $hours,
                        $specialDays,
                        $now,
                        $timezone
                    );
                }
            }
        }

        // 2. Get regular hours for today
        $todayHours = null;
        foreach ($hours as $h) {
            if ((int)$h->day_of_week === $dayOfWeek) {
                $todayHours = $h;
                break;
            }
        }

        if (!$todayHours || !(int)$todayHours->is_open) {
            // No hours configured at all → don't show a misleading "closed" status
            if (empty($hours)) {
                return [
                    'status'      => 'unknown',
                    'text'        => '',
                    'cssClass'    => '',
                    'nextOpening' => null,
                ];
            }
            return [
                'status'      => 'closed',
                'text'        => $closedText,
                'cssClass'    => 'bbf-filialfinder-status--closed',
                'nextOpening' => $this->findNextOpening($hours, $specialDays, $now, $timezone),
            ];
        }

        // 3. Check time ranges (up to 2 per day)
        $ranges = [];
        if (!empty($todayHours->open_time_1) && !empty($todayHours->close_time_1)) {
            $ranges[] = [$todayHours->open_time_1, $todayHours->close_time_1];
        }
        if (!empty($todayHours->open_time_2) && !empty($todayHours->close_time_2)) {
            $ranges[] = [$todayHours->open_time_2, $todayHours->close_time_2];
        }

        foreach ($ranges as $range) {
            $result = $this->evaluateTimeRange(
                $currentTime,
                $range[0],
                $range[1],
                $openText,
                $closedText,
                $openingSoonText,
                $closingSoonText,
                $openingSoonMinutes,
                $closingSoonMinutes,
                $hours,
                $specialDays,
                $now,
                $timezone
            );
            if ($result['status'] !== 'closed') {
                return $result;
            }
        }

        // Check if opening soon (next range today)
        foreach ($ranges as $range) {
            $openTime = new \DateTime($currentDate . ' ' . $range[0], $timezone);
            $diff = $openTime->getTimestamp() - $now->getTimestamp();
            if ($diff > 0 && $diff <= $openingSoonMinutes * 60) {
                return [
                    'status'      => 'opening_soon',
                    'text'        => $openingSoonText . ' (um ' . substr($range[0], 0, 5) . ')',
                    'cssClass'    => 'bbf-filialfinder-status--opening',
                    'nextOpening' => null,
                ];
            }
        }

        return [
            'status'      => 'closed',
            'text'        => $closedText,
            'cssClass'    => 'bbf-filialfinder-status--closed',
            'nextOpening' => $this->findNextOpening($hours, $specialDays, $now, $timezone),
        ];
    }

    /**
     * Evaluate if current time falls within a time range.
     */
    private function evaluateTimeRange(
        string $currentTime,
        string $openTime,
        string $closeTime,
        string $openText,
        string $closedText,
        string $openingSoonText,
        string $closingSoonText,
        int $openingSoonMinutes,
        int $closingSoonMinutes,
        array $hours,
        array $specialDays,
        \DateTime $now,
        \DateTimeZone $timezone
    ): array {
        // Normalize times to H:i:s format (DB may return H:i or H:i:s)
        $currentTime = strlen($currentTime) === 5 ? $currentTime . ':00' : $currentTime;
        $openTime = strlen($openTime) === 5 ? $openTime . ':00' : $openTime;
        $closeTime = strlen($closeTime) === 5 ? $closeTime . ':00' : $closeTime;

        $current = strtotime($currentTime);
        $open = strtotime($openTime);
        $close = strtotime($closeTime);

        // Guard against strtotime failures
        if ($current === false || $open === false || $close === false) {
            return [
                'status'      => 'unknown',
                'text'        => '',
                'cssClass'    => '',
                'nextOpening' => null,
            ];
        }

        if ($current >= $open && $current < $close) {
            $minutesUntilClose = ($close - $current) / 60;
            if ($minutesUntilClose <= $closingSoonMinutes) {
                return [
                    'status'      => 'closing_soon',
                    'text'        => $closingSoonText . ' (um ' . substr($closeTime, 0, 5) . ')',
                    'cssClass'    => 'bbf-filialfinder-status--closing',
                    'nextOpening' => null,
                ];
            }
            return [
                'status'      => 'open',
                'text'        => $openText . ' (bis ' . substr($closeTime, 0, 5) . ')',
                'cssClass'    => 'bbf-filialfinder-status--open',
                'nextOpening' => null,
            ];
        }

        return [
            'status'      => 'closed',
            'text'        => $closedText,
            'cssClass'    => 'bbf-filialfinder-status--closed',
            'nextOpening' => $this->findNextOpening($hours, $specialDays, $now, $timezone),
        ];
    }

    /**
     * Find the next opening time for a branch.
     */
    private function findNextOpening(array $hours, array $specialDays, \DateTime $now, \DateTimeZone $timezone): ?string
    {
        $checkDate = clone $now;

        for ($i = 0; $i < 8; $i++) {
            if ($i > 0) {
                $checkDate->modify('+1 day');
            }
            $dateStr = $checkDate->format('Y-m-d');
            $dayOfWeek = ((int)$checkDate->format('N')) - 1;

            // Check special days
            $isSpecialClosed = false;
            foreach ($specialDays as $sd) {
                if ($sd->date === $dateStr) {
                    if ((int)$sd->is_closed) {
                        $isSpecialClosed = true;
                        break;
                    }
                    if (!empty($sd->open_time)) {
                        $openDt = new \DateTime($dateStr . ' ' . $sd->open_time, $timezone);
                        if ($openDt > $now) {
                            $dayName = self::$dayNames[$dayOfWeek] ?? '';
                            return $dayName . ' um ' . substr($sd->open_time, 0, 5);
                        }
                    }
                }
            }
            if ($isSpecialClosed) {
                continue;
            }

            foreach ($hours as $h) {
                if ((int)$h->day_of_week === $dayOfWeek && (int)$h->is_open) {
                    $times = [
                        $h->open_time_1 ?? null,
                        $h->open_time_2 ?? null,
                    ];
                    foreach ($times as $openTime) {
                        if (empty($openTime)) {
                            continue;
                        }
                        $openDt = new \DateTime($dateStr . ' ' . $openTime, $timezone);
                        if ($openDt > $now) {
                            $dayName = self::$dayNames[$dayOfWeek] ?? '';
                            return $dayName . ' um ' . substr($openTime, 0, 5);
                        }
                    }
                }
            }
        }

        return null;
    }

    /**
     * Format opening hours as a human-readable summary.
     * Groups consecutive days with the same hours (e.g. "Mo - Fr: 10:00 - 19:00 Uhr").
     *
     * @param object[] $hours
     */
    public function formatHoursSummary(array $hours): string
    {
        if (empty($hours)) {
            return '';
        }

        $dayNames = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
        // Index hours by day
        $byDay = [];
        foreach ($hours as $h) {
            $byDay[(int)$h->day_of_week] = $h;
        }

        $groups = [];
        $currentGroup = null;

        for ($day = 0; $day < 7; $day++) {
            $h = $byDay[$day] ?? null;
            if (!$h || !(int)$h->is_open || empty($h->open_time_1)) {
                if ($currentGroup !== null) {
                    $groups[] = $currentGroup;
                    $currentGroup = null;
                }
                continue;
            }
            $timeStr = substr($h->open_time_1, 0, 5) . ' - ' . substr($h->close_time_1, 0, 5) . ' Uhr';
            if (!empty($h->open_time_2) && !empty($h->close_time_2)) {
                $timeStr .= ', ' . substr($h->open_time_2, 0, 5) . ' - ' . substr($h->close_time_2, 0, 5) . ' Uhr';
            }
            if ($currentGroup && $currentGroup['time'] === $timeStr) {
                $currentGroup['endDay'] = $day;
            } else {
                if ($currentGroup) {
                    $groups[] = $currentGroup;
                }
                $currentGroup = ['startDay' => $day, 'endDay' => $day, 'time' => $timeStr];
            }
        }
        if ($currentGroup) {
            $groups[] = $currentGroup;
        }

        $lines = [];
        foreach ($groups as $g) {
            if ($g['startDay'] === $g['endDay']) {
                $lines[] = $dayNames[$g['startDay']] . ': ' . $g['time'];
            } else {
                $lines[] = $dayNames[$g['startDay']] . ' - ' . $dayNames[$g['endDay']] . ': ' . $g['time'];
            }
        }
        return implode("\n", $lines);
    }

    /**
     * Export opening status data as JSON for frontend JS.
     *
     * @param array<int, array<string, mixed>> $branches
     * @return string JSON
     */
    public function exportForFrontend(array $branches): string
    {
        $allSettings = $this->settings->getAll();
        $data = [
            'config' => [
                'timezone'            => $allSettings['status_timezone'] ?? 'Europe/Berlin',
                'openText'            => $allSettings['status_open_text'] ?? 'Jetzt geöffnet',
                'closedText'          => $allSettings['status_closed_text'] ?? 'Jetzt geschlossen',
                'openingSoonText'     => $allSettings['status_opening_soon_text'] ?? 'Öffnet bald',
                'closingSoonText'     => $allSettings['status_closing_soon_text'] ?? 'Schließt bald',
                'openingSoonMinutes'  => (int)($allSettings['status_opening_soon_minutes'] ?? 30),
                'closingSoonMinutes'  => (int)($allSettings['status_closing_soon_minutes'] ?? 30),
                'showNextOpening'     => ($allSettings['status_show_next_opening'] ?? '1') === '1',
                'animatedDot'         => ($allSettings['status_animated_dot'] ?? '1') === '1',
            ],
            'branches' => [],
        ];

        foreach ($branches as $branch) {
            $branchHours = [];
            foreach (($branch['hours'] ?? []) as $h) {
                $branchHours[] = [
                    'day'         => (int)$h->day_of_week,
                    'isOpen'      => (bool)(int)$h->is_open,
                    'openTime1'   => $h->open_time_1,
                    'closeTime1'  => $h->close_time_1,
                    'openTime2'   => $h->open_time_2,
                    'closeTime2'  => $h->close_time_2,
                ];
            }

            $branchSpecialDays = [];
            foreach (($branch['special_days'] ?? []) as $sd) {
                $branchSpecialDays[] = [
                    'date'      => $sd->date,
                    'isClosed'  => (bool)(int)$sd->is_closed,
                    'openTime'  => $sd->open_time,
                    'closeTime' => $sd->close_time,
                    'note'      => $sd->note,
                ];
            }

            $data['branches'][(int)$branch['id']] = [
                'hours'       => $branchHours,
                'specialDays' => $branchSpecialDays,
            ];
        }

        return json_encode($data, JSON_UNESCAPED_UNICODE);
    }
}
