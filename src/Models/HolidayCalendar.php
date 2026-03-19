<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Models;

use JTL\DB\DbInterface;

/**
 * Model for managing holiday calendar subscriptions (iCal).
 *
 * Provides CRUD operations for iCal calendar sources that can be
 * synced to automatically import holidays into the system.
 */
class HolidayCalendar
{
    private const TABLE = 'bbf_filialfinder_holiday_calendars';

    /**
     * @param DbInterface $db Database interface
     */
    public function __construct(
        private readonly DbInterface $db
    ) {
    }

    /**
     * Get all holiday calendars.
     *
     * @return object[]
     */
    public function getAll(): array
    {
        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` ORDER BY `name` ASC',
            [],
            2
        );

        return is_array($rows) ? $rows : [];
    }

    /**
     * Get a single calendar by ID.
     *
     * @param int $id Calendar ID
     * @return object|null Calendar record or null if not found
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
     * Save a calendar (insert or update).
     *
     * @param array<string, mixed> $data Calendar data
     * @return int The calendar ID
     */
    public function save(array $data): int
    {
        $id = (int)($data['id'] ?? 0);
        unset($data['id']);

        $fields = ['name', 'ical_url', 'is_active'];

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
     * Delete a calendar by ID.
     *
     * @param int $id Calendar ID
     */
    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `id` = :id',
            ['id' => $id]
        );
    }

    /**
     * Update the last sync timestamp for a calendar.
     *
     * @param int $id Calendar ID
     */
    public function updateLastSync(int $id): void
    {
        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET `last_sync` = NOW() WHERE `id` = :id',
            ['id' => $id]
        );
    }
}
