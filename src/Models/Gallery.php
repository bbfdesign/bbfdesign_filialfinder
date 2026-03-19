<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Models;

use JTL\DB\DbInterface;

/**
 * Model for managing branch gallery images.
 *
 * Provides CRUD operations for gallery images associated with branches,
 * including sort order management.
 */
class Gallery
{
    private const TABLE = 'bbf_filialfinder_gallery';

    /**
     * @param DbInterface $db Database interface
     */
    public function __construct(
        private readonly DbInterface $db
    ) {
    }

    /**
     * Get all gallery images for a branch, ordered by sort order.
     *
     * @param int $branchId Branch ID
     * @return object[]
     */
    public function getByBranchId(int $branchId): array
    {
        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE `branch_id` = :branchId ORDER BY `sort_order` ASC, `id` ASC',
            ['branchId' => $branchId],
            2
        );

        return is_array($rows) ? $rows : [];
    }

    /**
     * Save a gallery image (insert or update).
     *
     * @param array<string, mixed> $data Gallery image data
     * @return int The gallery image ID
     */
    public function save(array $data): int
    {
        $id = (int)($data['id'] ?? 0);
        unset($data['id']);

        $fields = ['branch_id', 'image_path', 'title', 'alt_text', 'sort_order'];

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
     * Delete a gallery image by ID.
     *
     * @param int $id Gallery image ID
     */
    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `id` = :id',
            ['id' => $id]
        );
    }

    /**
     * Delete all gallery images for a branch.
     *
     * @param int $branchId Branch ID
     */
    public function deleteByBranchId(int $branchId): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `branch_id` = :branchId',
            ['branchId' => $branchId]
        );
    }

    /**
     * Update the sort order for a gallery image.
     *
     * @param int $id        Gallery image ID
     * @param int $sortOrder New sort order value
     */
    public function updateSortOrder(int $id, int $sortOrder): void
    {
        $this->db->queryPrepared(
            'UPDATE `' . self::TABLE . '` SET `sort_order` = :sortOrder WHERE `id` = :id',
            ['id' => $id, 'sortOrder' => $sortOrder]
        );
    }
}
