<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

/**
 * Migration for holidays, gallery, and video tables.
 *
 * Adds global holiday calendar support (iCal subscriptions),
 * individual holidays, branch gallery images, and branch videos.
 * Also extends the branch table with an HTML description column.
 */
class Migration20260319_2 extends Migration implements IMigration
{
    /**
     * @inheritdoc
     */
    public function up(): void
    {
        // Global holiday calendars (iCal subscriptions)
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_holiday_calendars` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `name` VARCHAR(255) NOT NULL,
                `ical_url` VARCHAR(1000) DEFAULT NULL,
                `is_active` TINYINT(1) DEFAULT 1,
                `last_sync` DATETIME DEFAULT NULL,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // Individual holidays (from calendar sync or manually added)
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_holidays` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `calendar_id` INT DEFAULT NULL,
                `name` VARCHAR(255) NOT NULL,
                `date` DATE NOT NULL,
                `is_recurring` TINYINT(1) DEFAULT 0,
                `type` ENUM('holiday','open_sunday','custom') DEFAULT 'holiday',
                `applies_to_all` TINYINT(1) DEFAULT 1,
                `branch_ids` TEXT DEFAULT NULL,
                `default_closed` TINYINT(1) DEFAULT 1,
                `open_override` TINYINT(1) DEFAULT 0,
                `open_time` TIME DEFAULT NULL,
                `close_time` TIME DEFAULT NULL,
                `note` VARCHAR(500) DEFAULT NULL,
                `highlight` TINYINT(1) DEFAULT 0,
                `highlight_text` VARCHAR(255) DEFAULT NULL,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                INDEX `idx_date` (`date`),
                INDEX `idx_type` (`type`),
                FOREIGN KEY (`calendar_id`) REFERENCES `bbf_filialfinder_holiday_calendars`(`id`) ON DELETE SET NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // Branch gallery images
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_gallery` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `branch_id` INT NOT NULL,
                `image_path` VARCHAR(500) NOT NULL,
                `title` VARCHAR(255) DEFAULT NULL,
                `alt_text` VARCHAR(255) DEFAULT NULL,
                `sort_order` INT DEFAULT 0,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (`branch_id`) REFERENCES `bbf_filialfinder_branch`(`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // Branch videos
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_videos` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `branch_id` INT NOT NULL,
                `video_url` VARCHAR(1000) NOT NULL,
                `video_type` ENUM('youtube','vimeo','mp4','embed') DEFAULT 'youtube',
                `title` VARCHAR(255) DEFAULT NULL,
                `thumbnail_path` VARCHAR(500) DEFAULT NULL,
                `sort_order` INT DEFAULT 0,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (`branch_id`) REFERENCES `bbf_filialfinder_branch`(`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // Add HTML description column to branch table
        $this->execute(
            "ALTER TABLE `bbf_filialfinder_branch` ADD COLUMN `description_html` TEXT DEFAULT NULL AFTER `description`"
        );

        // Add tags column to branch table
        $this->execute(
            "ALTER TABLE `bbf_filialfinder_branch` ADD COLUMN `tags` TEXT DEFAULT NULL AFTER `css_class`"
        );
    }

    /**
     * @inheritdoc
     */
    public function down(): void
    {
        $this->execute('DROP TABLE IF EXISTS `bbf_filialfinder_videos`');
        $this->execute('DROP TABLE IF EXISTS `bbf_filialfinder_gallery`');
        $this->execute('DROP TABLE IF EXISTS `bbf_filialfinder_holidays`');
        $this->execute('DROP TABLE IF EXISTS `bbf_filialfinder_holiday_calendars`');
        $this->execute('ALTER TABLE `bbf_filialfinder_branch` DROP COLUMN IF EXISTS `description_html`');
        $this->execute("ALTER TABLE `bbf_filialfinder_branch` DROP COLUMN IF EXISTS `tags`");
    }
}
