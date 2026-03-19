<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Models;

use JTL\DB\DbInterface;

/**
 * Model for managing branch videos.
 *
 * Provides CRUD operations for video entries associated with branches.
 * Supports YouTube, Vimeo, MP4, and generic embed video types.
 */
class Video
{
    private const TABLE = 'bbf_filialfinder_videos';

    /**
     * @param DbInterface $db Database interface
     */
    public function __construct(
        private readonly DbInterface $db
    ) {
    }

    /**
     * Get all videos for a branch, ordered by sort order.
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
     * Save a video (insert or update).
     *
     * @param array<string, mixed> $data Video data
     * @return int The video ID
     */
    public function save(array $data): int
    {
        $id = (int)($data['id'] ?? 0);
        unset($data['id']);

        $fields = ['branch_id', 'video_url', 'video_type', 'title', 'thumbnail_path', 'sort_order'];

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
     * Delete a video by ID.
     *
     * @param int $id Video ID
     */
    public function delete(int $id): void
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `id` = :id',
            ['id' => $id]
        );
    }

    /**
     * Delete all videos for a branch.
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
}
