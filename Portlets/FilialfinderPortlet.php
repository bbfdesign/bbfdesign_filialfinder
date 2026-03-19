<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\Portlets;

use JTL\OPC\InputType;
use JTL\OPC\Portlet;
use JTL\OPC\PortletInstance;
use JTL\Shop;
use Plugin\bbfdesign_filialfinder\src\Models\Branch;
use Plugin\bbfdesign_filialfinder\src\Models\Setting;
use Plugin\bbfdesign_filialfinder\src\Services\BranchService;
use Plugin\bbfdesign_filialfinder\src\Services\ConsentService;
use Plugin\bbfdesign_filialfinder\src\Services\OpeningStatusService;
use Plugin\bbfdesign_filialfinder\Smarty\FilialfinderSmartyPlugin;

/**
 * OPC Portlet for the BBF Filialfinder.
 * Allows drag-and-drop placement of the store locator in the JTL OPC editor.
 */
class FilialfinderPortlet extends Portlet
{
    /**
     * @return string
     */
    public function getButtonHtml(): string
    {
        return $this->getFontAwesomeButtonHtml('fa-map-marker-alt');
    }

    /**
     * @return array<string, array<string, mixed>>
     */
    public function getPropertyDesc(): array
    {
        $db = Shop::Container()->getDB();
        $branchModel = new Branch($db);
        $branches = $branchModel->getAll();

        $branchOptions = ['all' => 'Alle Filialen'];
        foreach ($branches as $branch) {
            $branchOptions[(string)$branch->id] = $branch->name . ' (' . $branch->city . ')';
        }

        return [
            'layout' => [
                'label'   => 'Layout-Vorlage',
                'type'    => InputType::SELECT,
                'default' => 'default',
                'options' => [
                    'default'   => 'Karte & Liste',
                    'map_only'  => 'Nur Karte',
                    'grid'      => 'Grid / Kachel-Ansicht',
                    'accordion' => 'Akkordeon / Kompakt',
                    'table'     => 'Tabellarisch',
                ],
            ],
            'branches' => [
                'label'   => 'Filialen',
                'type'    => InputType::SELECT,
                'default' => 'all',
                'options' => $branchOptions,
            ],
            'show_title' => [
                'label'   => 'Überschrift anzeigen',
                'type'    => InputType::CHECKBOX,
                'default' => true,
            ],
            'title' => [
                'label'   => 'Überschrift',
                'type'    => InputType::TEXT,
                'default' => '',
            ],
            'show_map' => [
                'label'   => 'Karte anzeigen',
                'type'    => InputType::CHECKBOX,
                'default' => true,
            ],
            'map_height' => [
                'label'   => 'Kartenhöhe (px)',
                'type'    => InputType::NUMBER,
                'default' => 450,
            ],
            'limit' => [
                'label'   => 'Max. Filialen',
                'type'    => InputType::NUMBER,
                'default' => 0,
            ],
            'css_class' => [
                'label'   => 'CSS-Klasse',
                'type'    => InputType::TEXT,
                'default' => '',
            ],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function getPropertyTabs(): array
    {
        return [
            'Einstellungen' => 'layout,branches,show_title,title,show_map,map_height,limit,css_class',
        ];
    }

    /**
     * Render the portlet in the frontend.
     */
    public function getPreviewHtml(PortletInstance $instance): string
    {
        $props = $instance->getProperties();

        return '<div class="opc-filialfinder-preview" style="padding:20px;background:#f8f9fa;border:2px dashed #C8B831;border-radius:8px;text-align:center;">'
            . '<div style="font-size:24px;margin-bottom:8px;">📍</div>'
            . '<strong>BBF Filialfinder</strong><br>'
            . '<small style="color:#6b7280;">Vorlage: ' . htmlspecialchars($props['layout'] ?? 'default') . '</small>'
            . '</div>';
    }

    /**
     * Render the portlet output.
     */
    public function getFinalHtml(PortletInstance $instance): string
    {
        $props = $instance->getProperties();

        $params = [
            'layout'    => $props['layout'] ?? 'default',
            'branches'  => $props['branches'] ?? 'all',
            'show_title' => ($props['show_title'] ?? true) ? 'true' : 'false',
            'title'     => $props['title'] ?? '',
            'show_map'  => ($props['show_map'] ?? true) ? 'true' : 'false',
            'map_height' => (string)($props['map_height'] ?? 450),
            'limit'     => (string)($props['limit'] ?? 0),
            'class'     => $props['css_class'] ?? '',
        ];

        try {
            $plugin = \JTL\Plugin\Helper::getPluginById('bbfdesign_filialfinder');
            if (!$plugin) {
                return '<!-- BBF Filialfinder: Plugin not found -->';
            }

            $db = Shop::Container()->getDB();
            $settings = new Setting($db);
            $smarty = Shop::Smarty();

            return FilialfinderSmartyPlugin::render($params, $smarty, $plugin, $db, $settings);
        } catch (\Throwable $e) {
            return '<!-- BBF Filialfinder Error: ' . htmlspecialchars($e->getMessage()) . ' -->';
        }
    }
}
