<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder;

use JTL\Events\Dispatcher;
use JTL\Plugin\Bootstrapper;
use JTL\Shop;
use JTL\Smarty\JTLSmarty;
use Plugin\bbfdesign_filialfinder\src\Controllers\Admin\AdminController;
use Plugin\bbfdesign_filialfinder\src\Models\Branch;
use Plugin\bbfdesign_filialfinder\src\Models\Setting;
use Plugin\bbfdesign_filialfinder\src\Services\OpeningStatusService;
use Plugin\bbfdesign_filialfinder\Smarty\FilialfinderSmartyPlugin;

class Bootstrap extends Bootstrapper
{
    /**
     * @inheritdoc
     */
    public function boot(Dispatcher $dispatcher): void
    {
        parent::boot($dispatcher);

        try {
            $plugin = $this->getPlugin();
            $db = Shop::Container()->getDB();

            // Check if our tables exist — use information_schema to avoid JTL error logging
            $tableCheck = $db->queryPrepared(
                "SELECT COUNT(*) AS cnt FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bbf_filialfinder_settings'",
                [],
                1
            );
            if (!$tableCheck || (int)$tableCheck->cnt === 0) {
                // Tables don't exist yet — skip all boot logic
                return;
            }

            $settings = new Setting($db);

            if (Shop::isFrontend()) {
                // Register Smarty plugin function {bbf_filialfinder ...} immediately
                try {
                    $smarty = Shop::Smarty();
                    if ($smarty instanceof JTLSmarty) {
                        FilialfinderSmartyPlugin::register($smarty, $plugin, $db, $settings);
                    }
                } catch (\Throwable $e) {
                    // Smarty not available yet — try again via hook
                    $dispatcher->listen('shop.hook.' . \HOOK_SMARTY_OUTPUTFILTER, static function (array $args) use ($plugin, $db, $settings) {
                        try {
                            $smarty = $args['smarty'] ?? null;
                            if ($smarty instanceof JTLSmarty) {
                                FilialfinderSmartyPlugin::register($smarty, $plugin, $db, $settings);
                            }
                        } catch (\Throwable $e) {
                            // Silent fail
                        }
                    });
                }

                // Include frontend CSS/JS assets
                $dispatcher->listen('shop.hook.' . \HOOK_LETZTERINCLUDE_CSS_JS, static function (array $args) use ($plugin, $db, $settings) {
                    try {
                        $allSettings = $settings->getAll();
                        $loadOnlyOnPluginPages = ($allSettings['performance_selective_loading'] ?? '0') === '1';

                        // Always load base CSS
                        $pluginFrontendUrl = $plugin->getPaths()->getFrontendURL();
                        $head = $args['cCSS_arr'] ?? [];

                        // Dynamic CSS from styling settings
                        $customCss = $allSettings['custom_css'] ?? '';
                        $primaryColor = $allSettings['styling_primary_color'] ?? '#C8B831';

                        // Add CSS
                        if (!$loadOnlyOnPluginPages || self::isFilialfinderPage()) {
                            $pq = \JTL\pq('head');
                            if ($pq->length > 0) {
                                $cssUrl = $pluginFrontendUrl . 'css/filialfinder.css';
                                $pq->append('<link rel="stylesheet" href="' . $cssUrl . '">');

                                // Dynamic CSS variables
                                $dynamicCss = ':root{';
                                $dynamicCss .= '--bbf-ff-primary:' . self::sanitizeColor($primaryColor) . ';';
                                $dynamicCss .= '--bbf-ff-secondary:' . self::sanitizeColor($allSettings['styling_secondary_color'] ?? '#1f2937') . ';';
                                $dynamicCss .= '--bbf-ff-bg:' . self::sanitizeColor($allSettings['styling_bg_color'] ?? '#ffffff') . ';';
                                $dynamicCss .= '--bbf-ff-text:' . self::sanitizeColor($allSettings['styling_text_color'] ?? '#1f2937') . ';';
                                $dynamicCss .= '--bbf-ff-open:' . self::sanitizeColor($allSettings['styling_open_color'] ?? '#28a745') . ';';
                                $dynamicCss .= '--bbf-ff-closed:' . self::sanitizeColor($allSettings['styling_closed_color'] ?? '#dc3545') . ';';
                                $dynamicCss .= '--bbf-ff-marker:' . self::sanitizeColor($allSettings['styling_marker_color'] ?? '#C8B831') . ';';
                                $dynamicCss .= '--bbf-ff-radius:' . (int)($allSettings['styling_border_radius'] ?? 8) . 'px;';
                                $dynamicCss .= '}';
                                if (!empty($customCss)) {
                                    $dynamicCss .= $customCss;
                                }
                                $pq->append('<style id="bbf-filialfinder-dynamic">' . $dynamicCss . '</style>');

                                // Leaflet CSS if OSM
                                $mapProvider = $allSettings['map_provider'] ?? 'osm';
                                if ($mapProvider === 'osm') {
                                    $leafletUrl = $pluginFrontendUrl . '../vendor/leaflet/leaflet.css';
                                    $pq->append('<link rel="stylesheet" href="' . $leafletUrl . '">');
                                    $clusterUrl = $pluginFrontendUrl . '../vendor/leaflet-markercluster/MarkerCluster.css';
                                    $pq->append('<link rel="stylesheet" href="' . $clusterUrl . '">');
                                    $clusterDefaultUrl = $pluginFrontendUrl . '../vendor/leaflet-markercluster/MarkerCluster.Default.css';
                                    $pq->append('<link rel="stylesheet" href="' . $clusterDefaultUrl . '">');
                                }
                            }
                        }
                    } catch (\Throwable $e) {
                        \error_log('BBF Filialfinder: CSS injection via pq() failed - ' . $e->getMessage());
                    }
                });

            }
        } catch (\Throwable $e) {
            \error_log('BBF Filialfinder: Bootstrap error - ' . $e->getMessage());
        }
    }

    /**
     * @inheritdoc
     */
    public function installed(): void
    {
        parent::installed();
        try {
            $db = Shop::Container()->getDB();
            $this->ensureTables($db);
            $settings = new Setting($db);
            $settings->installDefaults();
        } catch (\Throwable $e) {
            \error_log('BBF Filialfinder: Install error - ' . $e->getMessage());
        }
    }

    /**
     * @inheritdoc
     */
    public function updated($oldVersion, $newVersion): void
    {
        parent::updated($oldVersion, $newVersion);
        try {
            $db = Shop::Container()->getDB();
            $this->ensureTables($db);
            $settings = new Setting($db);
            $settings->addMissingSettings();
        } catch (\Throwable $e) {
            \error_log('BBF Filialfinder: Update error - ' . $e->getMessage());
        }
    }

    /**
     * @inheritdoc
     */
    public function uninstalled(bool $deleteData = true): void
    {
        parent::uninstalled($deleteData);
        if ($deleteData) {
            try {
                $db = Shop::Container()->getDB();
                $db->executeQuery('DROP TABLE IF EXISTS `bbf_filialfinder_videos`');
                $db->executeQuery('DROP TABLE IF EXISTS `bbf_filialfinder_gallery`');
                $db->executeQuery('DROP TABLE IF EXISTS `bbf_filialfinder_holidays`');
                $db->executeQuery('DROP TABLE IF EXISTS `bbf_filialfinder_holiday_calendars`');
                $db->executeQuery('DROP TABLE IF EXISTS `bbf_filialfinder_special_days`');
                $db->executeQuery('DROP TABLE IF EXISTS `bbf_filialfinder_hours`');
                $db->executeQuery('DROP TABLE IF EXISTS `bbf_filialfinder_branch`');
                $db->executeQuery('DROP TABLE IF EXISTS `bbf_filialfinder_settings`');
            } catch (\Throwable $e) {
                \error_log('BBF Filialfinder: Uninstall error - ' . $e->getMessage());
            }
        }
    }

    /**
     * @inheritdoc
     */
    public function renderAdminMenuTab(string $tabName, int $menuID, JTLSmarty $smarty): string
    {
        $plugin = $this->getPlugin();
        $db = Shop::Container()->getDB();

        // === AJAX HANDLER — must come FIRST, before any Smarty/HTML ===
        if (isset($_REQUEST['is_ajax']) && (int)$_REQUEST['is_ajax'] === 1) {
            // Suppress ALL PHP output
            @ini_set('display_errors', '0');
            @error_reporting(E_ERROR | E_PARSE);
            @set_time_limit(120); // Prevent default 30s timeout from killing AJAX

            // Release PHP session lock immediately — JTL's /admin/io holds
            // the session for seconds, blocking concurrent AJAX requests.
            if (session_status() === PHP_SESSION_ACTIVE) {
                session_write_close();
            }

            // Safety net: ensure tables exist before any DB access
            $this->ensureTables($db);

            register_shutdown_function(static function () {
                $error = error_get_last();
                if ($error && in_array($error['type'], [E_ERROR, E_CORE_ERROR, E_COMPILE_ERROR])) {
                    while (ob_get_level()) {
                        ob_end_clean();
                    }
                    header('Content-Type: application/json; charset=utf-8');
                    echo json_encode([
                        'success' => false,
                        'errors' => ['PHP Fatal: ' . $error['message'] . ' in ' . basename($error['file']) . ':' . $error['line']]
                    ]);
                }
            });

            try {
                $controller = new AdminController($plugin, $smarty, $db);
                $result = $controller->handleAjax();
                $json = json_encode($result, JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE);
            } catch (\Throwable $ex) {
                $json = json_encode([
                    'success' => false,
                    'errors' => [$ex->getMessage()]
                ]);
            }

            while (ob_get_level()) {
                ob_end_clean();
            }

            header('Content-Type: application/json; charset=utf-8');
            echo $json;
            exit;
        }

        // === NORMAL PAGE RENDER ===
        $this->ensureTables($db);
        $settings = new Setting($db);
        $smarty->assign([
            'plugin'        => $plugin,
            'postURL'       => $plugin->getPaths()->getBackendURL(),
            'adminUrl'      => $plugin->getPaths()->getAdminURL(),
            'pluginUrl'     => $plugin->getPaths()->getAdminURL(),
            'pluginVersion' => $plugin->getCurrentVersion(),
            'langVars'      => $plugin->getLocalization(),
            'allSettings'   => $settings->getAll(),
        ]);

        return $smarty->fetch($plugin->getPaths()->getAdminPath() . 'templates/index.tpl');
    }

    /**
     * Check if current page contains the filialfinder.
     */
    private static function isFilialfinderPage(): bool
    {
        return true; // For now, always load — can be refined later
    }

    /**
     * Sanitize a CSS color value.
     */
    private static function sanitizeColor(string $color): string
    {
        if (preg_match('/^#[0-9a-fA-F]{3,8}$/', $color)) {
            return $color;
        }
        if (preg_match('/^rgba?\([\d\s,.\/%]+\)$/i', $color)) {
            return $color;
        }
        return '#000000';
    }

    /**
     * Ensure all plugin tables exist (IF NOT EXISTS).
     * Called from installed() and updated() — more reliable than JTL migrations.
     */
    private function ensureTables(\JTL\DB\DbInterface $db): void
    {
        $db->executeQuery(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_branch` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `name` VARCHAR(255) NOT NULL,
                `description` TEXT,
                `description_html` TEXT DEFAULT NULL,
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
                `tags` TEXT DEFAULT NULL,
                `sort_order` INT DEFAULT 0,
                `is_active` TINYINT(1) DEFAULT 1,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        $db->executeQuery(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_hours` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `branch_id` INT NOT NULL,
                `day_of_week` TINYINT NOT NULL,
                `is_open` TINYINT(1) DEFAULT 1,
                `open_time_1` TIME DEFAULT NULL,
                `close_time_1` TIME DEFAULT NULL,
                `open_time_2` TIME DEFAULT NULL,
                `close_time_2` TIME DEFAULT NULL,
                INDEX `idx_branch_day` (`branch_id`, `day_of_week`),
                FOREIGN KEY (`branch_id`) REFERENCES `bbf_filialfinder_branch`(`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        $db->executeQuery(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_special_days` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `branch_id` INT NOT NULL,
                `date` DATE NOT NULL,
                `is_closed` TINYINT(1) DEFAULT 0,
                `open_time` TIME DEFAULT NULL,
                `close_time` TIME DEFAULT NULL,
                `note` VARCHAR(255) DEFAULT NULL,
                INDEX `idx_branch_date` (`branch_id`, `date`),
                FOREIGN KEY (`branch_id`) REFERENCES `bbf_filialfinder_branch`(`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        $db->executeQuery(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_settings` (
                `key_name` VARCHAR(100) PRIMARY KEY,
                `value` TEXT DEFAULT NULL,
                `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        $db->executeQuery(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_holiday_calendars` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `name` VARCHAR(255) NOT NULL,
                `ical_url` VARCHAR(1000) DEFAULT NULL,
                `is_active` TINYINT(1) DEFAULT 1,
                `last_sync` DATETIME DEFAULT NULL,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        $db->executeQuery(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_holidays` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `calendar_id` INT DEFAULT NULL,
                `name` VARCHAR(255) NOT NULL,
                `date` DATE NOT NULL,
                `is_recurring` TINYINT(1) DEFAULT 0,
                `type` VARCHAR(20) DEFAULT 'holiday',
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
                INDEX `idx_type` (`type`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        $db->executeQuery(
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

        $db->executeQuery(
            "CREATE TABLE IF NOT EXISTS `bbf_filialfinder_videos` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `branch_id` INT NOT NULL,
                `video_url` VARCHAR(1000) NOT NULL,
                `video_type` VARCHAR(20) DEFAULT 'youtube',
                `title` VARCHAR(255) DEFAULT NULL,
                `thumbnail_path` VARCHAR(500) DEFAULT NULL,
                `sort_order` INT DEFAULT 0,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (`branch_id`) REFERENCES `bbf_filialfinder_branch`(`id`) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
    }
}
