<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\Portlets\BbfFilialfinder;

use JTL\OPC\InputType;
use JTL\OPC\Portlet;
use JTL\OPC\PortletInstance;
use JTL\Shop;
use Plugin\bbfdesign_filialfinder\src\Models\Branch;
use Plugin\bbfdesign_filialfinder\src\Models\Setting;
use Plugin\bbfdesign_filialfinder\src\Services\BranchService;
use Plugin\bbfdesign_filialfinder\src\Services\OpeningStatusService;

/**
 * OPC Portlet for the BBF Filialfinder.
 */
class BbfFilialfinder extends Portlet
{
    /**
     * @return array<string, array<string, mixed>>
     */
    public function getPropertyDesc(): array
    {
        return [
            'layout' => [
                'type'    => InputType::SELECT,
                'label'   => 'Layout-Vorlage',
                'default' => 'default',
                'options' => [
                    'default'   => 'Karte & Liste',
                    'map_only'  => 'Nur Karte',
                    'grid'      => 'Grid / Kachel-Ansicht',
                    'accordion' => 'Akkordeon / Kompakt',
                    'table'     => 'Tabellarisch',
                ],
                'width' => 50,
            ],
            'show_title' => [
                'type'    => InputType::CHECKBOX,
                'label'   => 'Überschrift anzeigen',
                'default' => true,
                'width'   => 50,
            ],
            'title' => [
                'type'    => InputType::TEXT,
                'label'   => 'Überschrift',
                'default' => '',
                'width'   => 50,
            ],
            'show_map' => [
                'type'    => InputType::CHECKBOX,
                'label'   => 'Karte anzeigen',
                'default' => true,
                'width'   => 50,
            ],
            'map_height' => [
                'type'    => InputType::NUMBER,
                'label'   => 'Kartenhöhe (px)',
                'default' => 450,
                'width'   => 50,
            ],
            'limit' => [
                'type'    => InputType::NUMBER,
                'label'   => 'Max. Filialen (0 = alle)',
                'default' => 0,
                'width'   => 50,
            ],
        ];
    }

    /**
     * Get branch data for rendering.
     *
     * @return array<string, mixed>
     */
    public function getFilialfinderData(PortletInstance $instance): array
    {
        try {
            $db = Shop::Container()->getDB();
            $settings = new Setting($db);
            $branchService = new BranchService($db);
            $statusService = new OpeningStatusService($settings);
            $allSettings = $settings->getAll();

            $branches = $branchService->getAllWithHours(true);
            $limit = (int)$instance->getProperty('limit');
            if ($limit > 0) {
                $branches = array_slice($branches, 0, $limit);
            }

            foreach ($branches as &$branch) {
                $branch['status'] = $statusService->getStatus(
                    $branch,
                    $branch['hours'] ?? [],
                    $branch['special_days'] ?? []
                );
            }
            unset($branch);

            // Resolve plugin paths — multiple fallback strategies
            $pluginFrontendUrl = '';
            $pluginBaseUrl = '';

            // Strategy 1: $this->plugin (inherited from Portlet base class)
            try {
                if (isset($this->plugin) && $this->plugin !== null) {
                    $pluginFrontendUrl = $this->plugin->getPaths()->getFrontendURL();
                    $pluginBaseUrl = $this->plugin->getPaths()->getBaseURL();
                }
            } catch (\Throwable $e) {}

            // Strategy 2: Helper::getPluginById
            if (empty($pluginFrontendUrl)) {
                try {
                    $p = \JTL\Plugin\Helper::getPluginById('bbfdesign_filialfinder');
                    if ($p) {
                        $pluginFrontendUrl = $p->getPaths()->getFrontendURL();
                        $pluginBaseUrl = $p->getPaths()->getBaseURL();
                    }
                } catch (\Throwable $e) {}
            }

            // Strategy 3: Build URL from Shop::getURL() (always works)
            if (empty($pluginFrontendUrl)) {
                $shopUrl = rtrim(Shop::getURL(), '/');
                $pluginBaseUrl = $shopUrl . '/plugins/bbfdesign_filialfinder/';
                $pluginFrontendUrl = $pluginBaseUrl . 'frontend/';
            }

            // Resolve tile server URL
            $tileServers = [
                'osm_standard'      => 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                'osm_de'            => 'https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png',
                'opentopomap'       => 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                'stamen_toner'      => 'https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}.png',
                'stamen_watercolor' => 'https://tiles.stadiamaps.com/tiles/stamen_watercolor/{z}/{x}/{y}.jpg',
                'cartodb_positron'  => 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                'cartodb_dark'      => 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                'openfreemap'       => 'https://tiles.openfreemap.org/tile/{z}/{x}/{y}.png',
                'custom'            => $allSettings['osm_custom_tile_url'] ?? '',
            ];
            $tileKey = $allSettings['osm_tile_server'] ?? 'osm_standard';
            $allSettings['_resolved_tile_url'] = $tileServers[$tileKey] ?? $tileServers['osm_standard'];

            return [
                'branches'         => $branches,
                'settings'         => $allSettings,
                'layout'           => $instance->getProperty('layout') ?: 'default',
                'pluginFrontendUrl' => $pluginFrontendUrl,
                'pluginBaseUrl'     => $pluginBaseUrl,
            ];
        } catch (\Throwable $e) {
            return [
                'branches'          => [],
                'settings'          => [],
                'layout'            => 'default',
                'pluginFrontendUrl' => '',
                'pluginBaseUrl'     => '',
            ];
        }
    }
}
