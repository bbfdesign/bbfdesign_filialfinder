<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Models;

use JTL\DB\DbInterface;

class Branch
{
    private const TABLE = 'bbf_filialfinder_branch';

    public function __construct(
        private readonly DbInterface $db
    ) {}

    /**
     * Get all branches, optionally filtered.
     *
     * @return array<int, object>
     */
    public function getAll(bool $activeOnly = false, string $orderBy = 'sort_order ASC, name ASC'): array
    {
        $where = $activeOnly ? 'WHERE `is_active` = 1' : '';
        $allowedOrders = [
            'sort_order ASC, name ASC',
            'name ASC',
            'name DESC',
            'city ASC',
            'created_at DESC',
        ];
        if (!in_array($orderBy, $allowedOrders, true)) {
            $orderBy = 'sort_order ASC, name ASC';
        }

        $rows = $this->db->queryPrepared(
            "SELECT * FROM `" . self::TABLE . "` {$where} ORDER BY {$orderBy}",
            [],
            2
        );

        return is_array($rows) ? $rows : [];
    }

    /**
     * Get a branch by ID.
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
     * Get multiple branches by IDs.
     *
     * @param int[] $ids
     * @return object[]
     */
    public function getByIds(array $ids): array
    {
        if (empty($ids)) {
            return [];
        }
        $ids = array_map('intval', $ids);
        $placeholders = implode(',', $ids);
        $rows = $this->db->queryPrepared(
            "SELECT * FROM `" . self::TABLE . "` WHERE `id` IN ({$placeholders}) ORDER BY `sort_order` ASC, `name` ASC",
            [],
            2
        );
        return is_array($rows) ? $rows : [];
    }

    /**
     * Save a branch (insert or update).
     *
     * @param array<string, mixed> $data
     */
    public function save(array $data): int
    {
        $id = (int)($data['id'] ?? 0);
        unset($data['id']);

        $fields = [
            'name', 'description', 'description_html', 'image_path', 'street', 'zip', 'city', 'country',
            'phone', 'email', 'website', 'latitude', 'longitude', 'google_place_id',
            'marker_color', 'css_class', 'tags', 'sort_order', 'is_active',
        ];

        $filtered = [];
        foreach ($fields as $field) {
            if (array_key_exists($field, $data)) {
                $filtered[$field] = $data[$field];
            }
        }

        if ($id > 0) {
            // Update
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

        // Insert
        $columns = array_keys($filtered);
        $placeholders = array_map(fn(string $col) => ':' . $col, $columns);
        $this->db->queryPrepared(
            'INSERT INTO `' . self::TABLE . '` (`' . implode('`, `', $columns) . '`) VALUES (' . implode(', ', $placeholders) . ')',
            $filtered
        );

        return (int)$this->db->queryPrepared('SELECT LAST_INSERT_ID() as id', [], 1)->id;
    }

    /**
     * Delete a branch.
     */
    public function delete(int $id): bool
    {
        $this->db->queryPrepared(
            'DELETE FROM `' . self::TABLE . '` WHERE `id` = :id',
            ['id' => $id]
        );
        return true;
    }

    /**
     * Delete multiple branches.
     *
     * @param int[] $ids
     */
    public function deleteMultiple(array $ids): bool
    {
        if (empty($ids)) {
            return false;
        }
        $ids = array_map('intval', $ids);
        $placeholders = implode(',', $ids);
        $this->db->queryPrepared(
            "DELETE FROM `" . self::TABLE . "` WHERE `id` IN ({$placeholders})",
            []
        );
        return true;
    }

    /**
     * Toggle active status for multiple branches.
     *
     * @param int[] $ids
     */
    public function setActiveStatus(array $ids, bool $active): bool
    {
        if (empty($ids)) {
            return false;
        }
        $ids = array_map('intval', $ids);
        $placeholders = implode(',', $ids);
        $this->db->queryPrepared(
            "UPDATE `" . self::TABLE . "` SET `is_active` = :active WHERE `id` IN ({$placeholders})",
            ['active' => $active ? 1 : 0]
        );
        return true;
    }

    /**
     * Duplicate a branch (including hours and special days).
     */
    public function duplicate(int $id): ?int
    {
        $branch = $this->getById($id);
        if (!$branch) {
            return null;
        }

        $data = (array)$branch;
        unset($data['id'], $data['created_at'], $data['updated_at']);
        $data['name'] = $data['name'] . ' (Kopie)';

        $newId = $this->save($data);

        // Copy opening hours
        $hours = new OpeningHours($this->db);
        $existingHours = $hours->getByBranchId($id);
        foreach ($existingHours as $hour) {
            $hourData = (array)$hour;
            unset($hourData['id']);
            $hourData['branch_id'] = $newId;
            $hours->save($hourData);
        }

        // Copy special days
        $specialDays = new SpecialDay($this->db);
        $existingDays = $specialDays->getByBranchId($id);
        foreach ($existingDays as $day) {
            $dayData = (array)$day;
            unset($dayData['id']);
            $dayData['branch_id'] = $newId;
            $specialDays->save($dayData);
        }

        return $newId;
    }

    /**
     * Get all unique tags across all branches.
     * @return string[]
     */
    public function getAllTags(): array
    {
        $rows = $this->db->queryPrepared(
            'SELECT `tags` FROM `' . self::TABLE . '` WHERE `tags` IS NOT NULL AND `tags` != \'\'',
            [],
            2
        );
        $allTags = [];
        foreach ($rows as $row) {
            $tags = json_decode($row->tags, true);
            if (is_array($tags)) {
                $allTags = array_merge($allTags, $tags);
            }
        }
        return array_values(array_unique($allTags));
    }

    /**
     * Get branches by tag.
     * @return object[]
     */
    public function getByTag(string $tag): array
    {
        // JSON search - finds branches where tags JSON array contains the tag
        $rows = $this->db->queryPrepared(
            'SELECT * FROM `' . self::TABLE . '` WHERE `is_active` = 1 AND JSON_CONTAINS(`tags`, :tag) ORDER BY `sort_order` ASC',
            ['tag' => json_encode($tag)],
            2
        );
        return is_array($rows) ? $rows : [];
    }

    /**
     * Get total number of branches.
     */
    public function count(bool $activeOnly = false): int
    {
        $where = $activeOnly ? 'WHERE `is_active` = 1' : '';
        $row = $this->db->queryPrepared(
            "SELECT COUNT(*) as cnt FROM `" . self::TABLE . "` {$where}",
            [],
            1
        );
        return (int)($row->cnt ?? 0);
    }
}
