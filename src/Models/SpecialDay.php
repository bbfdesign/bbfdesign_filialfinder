<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Models;

use JTL\DB\DbInterface;

class SpecialDay
{
    private const TABLE = 'bbf_filialfinder_special_days';

    public function __construct(
        private readonly DbInterface $db
    ) {}

    /**
     * Get all special days for a branch.
     *
     * @return object[]
     */
    public function getByBranchId(int $branchId): array
    {
        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE `branch_id` = :branchId ORDER BY `date` ASC',
            ['branchId' => $branchId],
            2
        );
        return is_array($rows) ? $rows : [];
    }

    /**
     * Get special day for a branch on a specific date.
     */
    public function getByBranchAndDate(int $branchId, string $date): ?object
    {
        $row = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE `branch_id` = :branchId AND `date` = :date',
            ['branchId' => $branchId, 'date' => $date],
            1
        );
        return $row ?: null;
    }

    /**
     * Save a special day entry.
     *
     * @param array<string, mixed> $data
     */
    public function save(array $data): int
    {
        $id = (int)($data['id'] ?? 0);
        unset($data['id']);

        if ($id > 0) {
            $sets = [];
            $params = ['id' => $id];
            foreach ($data as $key => $value) {
                $sets[] = "`{$key}` = :{$key}";
                $params[$key] = $value;
            }
            $this->db->queryPrepared(
                'UPDATE `' . self::TABLE . '` SET ' . implode(', ', $sets) . ' WHERE `id` = :id',
                $params
            );
            return $id;
        }

        $columns = array_keys($data);
        $placeholders = array_map(fn(string $col) => ':' . $col, $columns);
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE . '` (`' . implode('`, `', $columns) . '`) VALUES (' . implode(', ', $placeholders) . ')',
            $data
        );
        return (int)$this->db->queryPrepared('SELECT LAST_INSERT_ID() as id', [], 1)->id;
    }

    /**
     * Delete a special day.
     */
    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `id` = :id',
            ['id' => $id]
        );
    }

    /**
     * Delete all special days for a branch.
     */
    public function deleteByBranchId(int $branchId): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `branch_id` = :branchId',
            ['branchId' => $branchId]
        );
    }

    /**
     * Save multiple special days for a branch (replaces existing).
     *
     * @param array<int, array<string, mixed>> $specialDays
     */
    public function saveBranchSpecialDays(int $branchId, array $specialDays): void
    {
        $this->deleteByBranchId($branchId);
        foreach ($specialDays as $dayData) {
            if (empty($dayData['date'])) {
                continue;
            }
            $this->save([
                'branch_id' => $branchId,
                'date'      => $dayData['date'],
                'is_closed' => (int)($dayData['is_closed'] ?? 0),
                'open_time' => $dayData['open_time'] ?? null,
                'close_time' => $dayData['close_time'] ?? null,
                'note'      => $dayData['note'] ?? null,
            ]);
        }
    }
}
