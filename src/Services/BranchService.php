<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Services;

use JTL\DB\DbInterface;
use Plugin\bbfdesign_filialfinder\src\Models\Branch;
use Plugin\bbfdesign_filialfinder\src\Models\OpeningHours;
use Plugin\bbfdesign_filialfinder\src\Models\SpecialDay;

class BranchService
{
    private Branch $branchModel;
    private OpeningHours $hoursModel;
    private SpecialDay $specialDayModel;

    public function __construct(
        private readonly DbInterface $db
    ) {
        $this->branchModel = new Branch($db);
        $this->hoursModel = new OpeningHours($db);
        $this->specialDayModel = new SpecialDay($db);
    }

    /**
     * Get all branches with their hours.
     *
     * @return array<int, array<string, mixed>>
     */
    public function getAllWithHours(bool $activeOnly = false): array
    {
        $branches = $this->branchModel->getAll($activeOnly);
        $result = [];

        foreach ($branches as $branch) {
            $branchData = (array)$branch;
            $branchData['hours'] = $this->hoursModel->getByBranchId((int)$branch->id);
            $branchData['special_days'] = $this->specialDayModel->getByBranchId((int)$branch->id);
            $result[] = $branchData;
        }

        return $result;
    }

    /**
     * Get a single branch with all related data.
     *
     * @return array<string, mixed>|null
     */
    public function getFullBranch(int $id): ?array
    {
        $branch = $this->branchModel->getById($id);
        if (!$branch) {
            return null;
        }

        $data = (array)$branch;
        $data['hours'] = $this->hoursModel->getByBranchId($id);
        $data['special_days'] = $this->specialDayModel->getByBranchId($id);

        return $data;
    }

    /**
     * Save a branch with all related data (hours, special days).
     *
     * @param array<string, mixed> $data
     * @param array<int, array<string, mixed>> $hours
     * @param array<int, array<string, mixed>> $specialDays
     */
    public function saveFull(array $data, array $hours = [], array $specialDays = []): int
    {
        $branchId = $this->branchModel->save($data);

        if (!empty($hours)) {
            $this->hoursModel->saveBranchHours($branchId, $hours);
        }

        if (!empty($specialDays)) {
            $this->specialDayModel->saveBranchSpecialDays($branchId, $specialDays);
        }

        return $branchId;
    }

    /**
     * Handle image upload for a branch.
     */
    public function handleImageUpload(array $file, string $uploadDir): ?string
    {
        if (empty($file['tmp_name']) || $file['error'] !== UPLOAD_ERR_OK) {
            return null;
        }

        $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'];
        $finfo = new \finfo(FILEINFO_MIME_TYPE);
        $mimeType = $finfo->file($file['tmp_name']);

        if (!in_array($mimeType, $allowedTypes, true)) {
            return null;
        }

        $maxSize = 5 * 1024 * 1024; // 5MB
        if ($file['size'] > $maxSize) {
            return null;
        }

        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
        $ext = strtolower(preg_replace('/[^a-zA-Z0-9]/', '', $ext));
        $allowedExt = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];
        if (!in_array($ext, $allowedExt, true)) {
            $ext = 'jpg';
        }

        $filename = 'branch_' . uniqid() . '.' . $ext;
        $targetPath = $uploadDir . '/' . $filename;

        if (move_uploaded_file($file['tmp_name'], $targetPath)) {
            return $filename;
        }

        return null;
    }

    /**
     * Delete a branch image file.
     */
    public function deleteImage(string $imagePath, string $uploadDir): void
    {
        $fullPath = $uploadDir . '/' . basename($imagePath);
        if (file_exists($fullPath)) {
            @unlink($fullPath);
        }
    }
}
