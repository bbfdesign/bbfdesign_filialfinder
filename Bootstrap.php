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
use Plugin\bbfdesign_filialfinder\src\Services\ConsentService;
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

            // Check if our settings table exists (migration may not have run yet)
            try {
                $db->queryPrepared('SELECT 1 FROM `bbf_filialfinder_settings` LIMIT 1', [], 1);
            } catch (\Throwable $e) {
                // Tables don't exist yet — skip all boot logic
                return;
            }

            $settings = new Setting($db);

            if (Shop::isFrontend()) {
                // Register Smarty plugin function {bbf_filialfinder ...}
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
                        // Silent fail
                    }
                });

                // Register consent vendor
                $dispatcher->listen('shop.hook.' . \HOOK_SMARTY_OUTPUTFILTER, static function (array $args) use ($plugin, $db, $settings) {
                    try {
                        $consentService = new ConsentService($plugin, $db, $settings);
                        $consentService->registerConsentVendor();
                    } catch (\Throwable $e) {
                        // Silent fail
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
                $db->query('DROP TABLE IF EXISTS `bbf_filialfinder_special_days`');
                $db->query('DROP TABLE IF EXISTS `bbf_filialfinder_hours`');
                $db->query('DROP TABLE IF EXISTS `bbf_filialfinder_branch`');
                $db->query('DROP TABLE IF EXISTS `bbf_filialfinder_settings`');
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
}
