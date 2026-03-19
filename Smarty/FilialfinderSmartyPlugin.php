<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\Smarty;

use JTL\DB\DbInterface;
use JTL\Plugin\PluginInterface;
use JTL\Smarty\JTLSmarty;
use Plugin\bbfdesign_filialfinder\src\Models\Branch;
use Plugin\bbfdesign_filialfinder\src\Models\Setting;
use Plugin\bbfdesign_filialfinder\src\Services\BranchService;
use Plugin\bbfdesign_filialfinder\src\Services\ConsentService;
use Plugin\bbfdesign_filialfinder\src\Services\OpeningStatusService;

/**
 * Registers the {bbf_filialfinder} Smarty function.
 *
 * Usage:
 *   {bbf_filialfinder layout="default" branches="all"}
 *   {bbf_filialfinder layout="map_only" branches="1,3,5"}
 *   {bbf_filialfinder layout="grid" limit="4"}
 */
class FilialfinderSmartyPlugin
{
    private static bool $registered = false;
    private static int $instanceCounter = 0;

    /**
     * Register the Smarty plugin function.
     */
    public static function register(
        JTLSmarty $smarty,
        PluginInterface $plugin,
        DbInterface $db,
        Setting $settings
    ): void {
        if (self::$registered) {
            return;
        }

        try {
            $smarty->registerPlugin(
                'function',
                'bbf_filialfinder',
                static function (array $params, $smartyInstance) use ($plugin, $db, $settings) {
                    return self::render($params, $smartyInstance, $plugin, $db, $settings);
                }
            );
            self::$registered = true;
        } catch (\Throwable $e) {
            // Plugin may already be registered
        }
    }

    /**
     * Render the filialfinder output.
     *
     * @param array<string, string> $params
     */
    public static function render(
        array $params,
        $smarty,
        PluginInterface $plugin,
        DbInterface $db,
        Setting $settings
    ): string {
        self::$instanceCounter++;

        $allSettings = $settings->getAll();
        $branchModel = new Branch($db);
        $branchService = new BranchService($db);
        $statusService = new OpeningStatusService($settings);
        $consentService = new ConsentService($plugin, $db, $settings);

        // Parse parameters
        $layout = $params['layout'] ?? $allSettings['layout_template'] ?? 'default';
        $branchParam = $params['branches'] ?? 'all';
        $limit = (int)($params['limit'] ?? 0);
        $showTitle = ($params['show_title'] ?? 'true') === 'true';
        $title = $params['title'] ?? $allSettings['styling_title'] ?? '';
        $showMap = ($params['show_map'] ?? 'true') === 'true';
        $mapHeight = (int)($params['map_height'] ?? $allSettings['map_height'] ?? 450);
        $cssClass = $params['class'] ?? '';
        $sort = $params['sort'] ?? 'order';

        // Validate layout
        $validLayouts = ['default', 'map_only', 'grid', 'accordion', 'table'];
        if (!in_array($layout, $validLayouts, true)) {
            $layout = 'default';
        }

        // Get branches
        if ($branchParam === 'all') {
            $branches = $branchService->getAllWithHours(true);
        } else {
            $ids = array_map('intval', explode(',', $branchParam));
            $rawBranches = $branchModel->getByIds($ids);
            $branches = [];
            foreach ($rawBranches as $branch) {
                if ((int)$branch->is_active) {
                    $data = (array)$branch;
                    $data['hours'] = (new \Plugin\bbfdesign_filialfinder\src\Models\OpeningHours($db))->getByBranchId((int)$branch->id);
                    $data['special_days'] = (new \Plugin\bbfdesign_filialfinder\src\Models\SpecialDay($db))->getByBranchId((int)$branch->id);
                    $branches[] = $data;
                }
            }
        }

        // Apply limit
        if ($limit > 0) {
            $branches = array_slice($branches, 0, $limit);
        }

        // Sort
        if ($sort === 'name') {
            usort($branches, fn($a, $b) => strcasecmp($a['name'], $b['name']));
        }

        // Calculate opening status for each branch
        foreach ($branches as &$branch) {
            $branch['status'] = $statusService->getStatus(
                $branch,
                $branch['hours'] ?? [],
                $branch['special_days'] ?? []
            );
        }
        unset($branch);

        // Generate status data for JS
        $statusData = $statusService->exportForFrontend($branches);

        // Determine layout template path
        $templateDir = $plugin->getPaths()->getFrontendPath() . 'template/';
        $layoutFile = $templateDir . 'layouts/' . $layout . '.tpl';
        if (!file_exists($layoutFile)) {
            $layoutFile = $templateDir . 'layouts/default.tpl';
        }

        // Assign template variables
        $smarty->assign([
            'bbfBranches'        => $branches,
            'bbfSettings'        => $allSettings,
            'bbfStatusData'      => $statusData,
            'bbfMapProvider'     => $allSettings['map_provider'] ?? 'osm',
            'bbfConsentRequired' => $consentService->isConsentRequired(),
            'bbfConsentVendorId' => $consentService->getConsentVendorId(),
            'bbfInstanceId'      => self::$instanceCounter,
            'bbfParams'          => $params,
            'bbfPluginUrl'       => $plugin->getPaths()->getFrontendURL(),
            'ffLayoutPath'       => $layoutFile,
        ]);

        // Render wrapper template
        $wrapperFile = $templateDir . 'filialfinder-wrapper.tpl';
        if (!file_exists($wrapperFile)) {
            return '<!-- BBF Filialfinder: Template not found -->';
        }

        try {
            return $smarty->fetch($wrapperFile);
        } catch (\Throwable $e) {
            return '<!-- BBF Filialfinder Error: ' . htmlspecialchars($e->getMessage()) . ' -->';
        }
    }
}
