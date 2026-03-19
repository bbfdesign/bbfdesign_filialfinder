<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Models;

use JTL\DB\DbInterface;

/**
 * Model for managing individual holidays.
 *
 * Handles CRUD operations for holidays that can be globally applied
 * or restricted to specific branches. Supports recurring holidays,
 * open Sundays, and custom holiday types.
 */
class Holiday
{
    private const TABLE = 'bbf_filialfinder_holidays';

    /**
     * @param DbInterface $db Database interface
     */
    public function __construct(
        private readonly DbInterface $db
    ) {
    }

    /**
     * Get all holidays ordered by date.
     *
     * @return object[]
     */
    public function getAll(): array
    {
        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` ORDER BY `date` ASC',
            [],
            2
        );

        return is_array($rows) ? $rows : [];
    }

    /**
     * Get a single holiday by ID.
     *
     * @param int $id Holiday ID
     * @return object|null Holiday record or null if not found
     */
    public function getById(int $id): ?object
    {
        $row = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE `id` = :id',
            ['id' => $id],
            1
        );

        return $row ?: null;
    }

    /**
     * Get all holidays for a specific date.
     *
     * Also includes recurring holidays whose month and day match the given date.
     *
     * @param string $date Date in Y-m-d format
     * @return object[]
     */
    public function getByDate(string $date): array
    {
        $monthDay = date('m-d', strtotime($date));

        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '`
             WHERE `date` = :date
                OR (`is_recurring` = 1 AND DATE_FORMAT(`date`, \'%m-%d\') = :monthDay)
             ORDER BY `date` ASC',
            ['date' => $date, 'monthDay' => $monthDay],
            2
        );

        return is_array($rows) ? $rows : [];
    }

    /**
     * Get all holidays within a date range.
     *
     * Includes recurring holidays that fall within the range.
     *
     * @param string $from Start date in Y-m-d format
     * @param string $to   End date in Y-m-d format
     * @return object[]
     */
    public function getByDateRange(string $from, string $to): array
    {
        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '`
             WHERE (`date` BETWEEN :fromDate AND :toDate)
                OR (`is_recurring` = 1 AND DATE_FORMAT(`date`, \'%m-%d\') BETWEEN DATE_FORMAT(:fromRecur, \'%m-%d\') AND DATE_FORMAT(:toRecur, \'%m-%d\'))
             ORDER BY `date` ASC',
            [
                'fromDate'  => $from,
                'toDate'    => $to,
                'fromRecur' => $from,
                'toRecur'   => $to,
            ],
            2
        );

        return is_array($rows) ? $rows : [];
    }

    /**
     * Get holidays applicable to a specific branch on a given date.
     *
     * Returns holidays that either apply to all branches or explicitly
     * include the given branch ID in their branch_ids list.
     *
     * @param int    $branchId Branch ID
     * @param string $date     Date in Y-m-d format
     * @return object[]
     */
    public function getForBranch(int $branchId, string $date): array
    {
        $allHolidays = $this->getByDate($date);

        return array_values(array_filter($allHolidays, static function (object $holiday) use ($branchId): bool {
            if ((int)$holiday->applies_to_all === 1) {
                return true;
            }

            if (!empty($holiday->branch_ids)) {
                $ids = array_map('intval', explode(',', (string)$holiday->branch_ids));
                return in_array($branchId, $ids, true);
            }

            return false;
        }));
    }

    /**
     * Get upcoming holidays from today.
     *
     * @param int $limit Maximum number of holidays to return
     * @return object[]
     */
    public function getUpcoming(int $limit = 10): array
    {
        $today = date('Y-m-d');

        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '`
             WHERE `date` >= :today
             ORDER BY `date` ASC
             LIMIT :lim',
            ['today' => $today, 'lim' => $limit],
            2
        );

        return is_array($rows) ? $rows : [];
    }

    /**
     * Get upcoming open Sundays.
     *
     * @param int $limit Maximum number of open Sundays to return
     * @return object[]
     */
    public function getOpenSundays(int $limit = 5): array
    {
        $today = date('Y-m-d');

        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '`
             WHERE `type` = \'open_sunday\' AND `date` >= :today
             ORDER BY `date` ASC
             LIMIT :lim',
            ['today' => $today, 'lim' => $limit],
            2
        );

        return is_array($rows) ? $rows : [];
    }

    /**
     * Save a holiday (insert or update).
     *
     * @param array<string, mixed> $data Holiday data
     * @return int The holiday ID
     */
    public function save(array $data): int
    {
        $id = (int)($data['id'] ?? 0);
        unset($data['id']);

        $fields = [
            'calendar_id', 'name', 'date', 'is_recurring', 'type',
            'applies_to_all', 'branch_ids', 'default_closed', 'open_override',
            'open_time', 'close_time', 'note', 'highlight', 'highlight_text',
        ];

        $filtered = [];
        foreach ($fields as $field) {
            if (array_key_exists($field, $data)) {
                $filtered[$field] = $data[$field];
            }
        }

        if ($id > 0) {
            $sets = [];
            $params = ['id' => $id];
            foreach ($filtered as $key => $value) {
                $sets[] = "`{$key}` = :{$key}";
                $params[$key] = $value;
            }
            if (!empty($sets)) {
                $this->db->queryPrepared(
                    'UPDATE `' . self::TABLE . '` SET ' . implode(', ', $sets) . ' WHERE `id` = :id',
                    $params
                );
            }

            return $id;
        }

        $columns = array_keys($filtered);
        $placeholders = array_map(static fn(string $col): string => ':' . $col, $columns);
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE . '` (`' . implode('`, `', $columns) . '`) VALUES (' . implode(', ', $placeholders) . ')',
            $filtered
        );

        return (int)$this->db->queryPrepared('SELECT LAST_INSERT_ID() as id', [], 1)->id;
    }

    /**
     * Delete a holiday by ID.
     *
     * @param int $id Holiday ID
     */
    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `id` = :id',
            ['id' => $id]
        );
    }

    /**
     * Delete all holidays belonging to a specific calendar.
     *
     * @param int $calendarId Calendar ID
     */
    public function deleteByCalendarId(int $calendarId): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `calendar_id` = :calendarId',
            ['calendarId' => $calendarId]
        );
    }
}
