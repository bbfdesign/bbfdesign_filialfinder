<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Models;

use JTL\DB\DbInterface;

class OpeningHours
{
    private const TABLE = 'bbf_filialfinder_hours';

    public function __construct(
        private readonly DbInterface $db
    ) {}

    /**
     * Get all opening hours for a branch.
     *
     * @return object[]
     */
    public function getByBranchId(int $branchId): array
    {
        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE `branch_id` = :branchId ORDER BY `day_of_week` ASC',
            ['branchId' => $branchId],
            2
        );
        return is_array($rows) ? $rows : [];
    }

    /**
     * Get opening hours for a specific day.
     */
    public function getByBranchAndDay(int $branchId, int $dayOfWeek): ?object
    {
        $row = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE `branch_id` = :branchId AND `day_of_week` = :day',
            ['branchId' => $branchId, 'day' => $dayOfWeek],
            1
        );
        return $row ?: null;
    }

    /**
     * Save an opening hours entry.
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
     * Delete all hours for a branch.
     */
    public function deleteByBranchId(int $branchId): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `branch_id` = :branchId',
            ['branchId' => $branchId]
        );
    }

    /**
     * Save all 7 days for a branch (replaces existing).
     *
     * @param array<int, array<string, mixed>> $days Indexed 0-6 (Mo-So)
     */
    public function saveBranchHours(int $branchId, array $days): void
    {
        $this->deleteByBranchId($branchId);
        foreach ($days as $dayOfWeek => $dayData) {
            $this->save([
                'branch_id'    => $branchId,
                'day_of_week'  => (int)$dayOfWeek,
                'is_open'      => (int)($dayData['is_open'] ?? 1),
                'open_time_1'  => $dayData['open_time_1'] ?? null,
                'close_time_1' => $dayData['close_time_1'] ?? null,
                'open_time_2'  => $dayData['open_time_2'] ?? null,
                'close_time_2' => $dayData['close_time_2'] ?? null,
            ]);
        }
    }
}
