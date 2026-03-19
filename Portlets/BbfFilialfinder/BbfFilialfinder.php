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

            // Resolve plugin paths — use $this->plugin (inherited from Portlet)
            $pluginFrontendUrl = '';
            $pluginBaseUrl = '';
            try {
                if (isset($this->plugin) && $this->plugin !== null) {
                    $pluginFrontendUrl = $this->plugin->getPaths()->getFrontendURL();
                    $pluginBaseUrl = $this->plugin->getPaths()->getBaseURL();
                }
            } catch (\Throwable $e) {
                // Fallback: try Helper
                try {
                    $p = \JTL\Plugin\Helper::getPluginById('bbfdesign_filialfinder');
                    if ($p) {
                        $pluginFrontendUrl = $p->getPaths()->getFrontendURL();
                        $pluginBaseUrl = $p->getPaths()->getBaseURL();
                    }
                } catch (\Throwable $e2) {}
            }

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
