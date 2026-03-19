<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\Migrations;

use JTL\Plugin\Migration;
use JTL\Update\IMigration;

class Migration20260319 extends Migration implements IMigration
{
    /**
     * @inheritdoc
     */
    public function up(): void
    {
        // Branch table
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_branch` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `name` VARCHAR(255) NOT NULL,
                `description` TEXT,
                `image_path` VARCHAR(500) DEFAULT NULL,
                `street` VARCHAR(255) DEFAULT NULL,
                `zip` VARCHAR(20) DEFAULT NULL,
                `city` VARCHAR(100) DEFAULT NULL,
                `country` VARCHAR(5) DEFAULT 'DE',
                `phone` VARCHAR(50) DEFAULT NULL,
                `email` VARCHAR(150) DEFAULT NULL,
                `website` VARCHAR(500) DEFAULT NULL,
                `latitude` DECIMAL(10,8) DEFAULT NULL,
                `longitude` DECIMAL(11,8) DEFAULT NULL,
                `google_place_id` VARCHAR(255) DEFAULT NULL,
                `marker_color` VARCHAR(7) DEFAULT NULL,
                `css_class` VARCHAR(100) DEFAULT NULL,
                `sort_order` INT DEFAULT 0,
                `is_active` TINYINT(1) DEFAULT 1,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // Opening hours table
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_hours` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `branch_id` INT NOT NULL,
                `day_of_week` TINYINT NOT NULL COMMENT '0=Mo, 1=Di, 2=Mi, 3=Do, 4=Fr, 5=Sa, 6=So',
                `is_open` TINYINT(1) DEFAULT 1,
                `open_time_1` TIME DEFAULT NULL,
                `close_time_1` TIME DEFAULT NULL,
                `open_time_2` TIME DEFAULT NULL,
                `close_time_2` TIME DEFAULT NULL,
                FOREIGN KEY (`branch_id`) REFERENCES `bbf_filialfinder_branch`(`id`) ON DELETE CASCADE,
                INDEX `idx_branch_day` (`branch_id`, `day_of_week`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // Special days / holidays table
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_special_days` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `branch_id` INT NOT NULL,
                `date` DATE NOT NULL,
                `is_closed` TINYINT(1) DEFAULT 0,
                `open_time` TIME DEFAULT NULL,
                `close_time` TIME DEFAULT NULL,
                `note` VARCHAR(255) DEFAULT NULL,
                FOREIGN KEY (`branch_id`) REFERENCES `bbf_filialfinder_branch`(`id`) ON DELETE CASCADE,
                INDEX `idx_branch_date` (`branch_id`, `date`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        // Settings table
        $this->execute(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_settings` (
                `key_name` VARCHAR(100) PRIMARY KEY,
                `value` TEXT DEFAULT NULL,
                `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
    }

    /**
     * @inheritdoc
     */
    public function down(): void
    {
        $this->execute('DROP TABLE IF EXISTS `bbf_filialfinder_special_days`');
        $this->execute('DROP TABLE IF EXISTS `bbf_filialfinder_hours`');
        $this->execute('DROP TABLE IF EXISTS `bbf_filialfinder_branch`');
        $this->execute('DROP TABLE IF EXISTS `bbf_filialfinder_settings`');
    }
}
