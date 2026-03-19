<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Models;

use JTL\DB\DbInterface;

class Setting
{
    private const TABLE = 'bbf_filialfinder_settings';

    /** @var array<string, mixed> */
    private static array $defaults = [
        // Map Provider
        'map_provider'           => 'osm',
        'google_api_key'         => '',
        'google_map_type'        => 'roadmap',
        'google_styled_map'      => '0',
        'google_map_style_json'  => '',
        'google_custom_marker'   => '',
        'osm_tile_server'        => 'osm_standard',
        'osm_custom_tile_url'    => '',
        'osm_marker_color'       => '#C8B831',
        'map_default_zoom'       => '14',
        'map_max_zoom'           => '18',
        'map_min_zoom'           => '5',
        'map_scroll_zoom'        => '1',
        'map_height'             => '450',
        'map_auto_zoom'          => '1',
        'map_cluster_markers'    => '1',
        'map_fullscreen_btn'     => '1',
        'map_street_view'        => '0',
        'map_route_link'         => '1',

        // Layout
        'layout_template'        => 'default',

        // Styling
        'styling_primary_color'  => '#C8B831',
        'styling_secondary_color' => '#1f2937',
        'styling_bg_color'       => '#ffffff',
        'styling_text_color'     => '#1f2937',
        'styling_open_color'     => '#28a745',
        'styling_closed_color'   => '#dc3545',
        'styling_marker_color'   => '#C8B831',
        'styling_border_radius'  => '8',
        'styling_shadow_intensity' => '2',
        'styling_font'           => 'inherit',
        'styling_title'          => '',
        'styling_title_tag'      => 'h2',
        'styling_title_align'    => 'center',
        'styling_subtitle'       => '',
        'styling_divider'        => '0',
        'styling_divider_color'  => '#C8B831',
        'styling_divider_width'  => '2',
        'styling_divider_percent' => '50',
        'styling_no_results_text' => 'Keine Filialen gefunden.',

        // CSS Editor
        'custom_css'             => '',

        // Opening Status
        'status_show'            => '1',
        'status_open_text'       => 'Jetzt geöffnet',
        'status_closed_text'     => 'Jetzt geschlossen',
        'status_opening_soon_text' => 'Öffnet bald',
        'status_closing_soon_text' => 'Schließt bald',
        'status_opening_soon_minutes' => '30',
        'status_closing_soon_minutes' => '30',
        'status_show_next_opening' => '1',
        'status_timezone'        => 'Europe/Berlin',
        'status_animated_dot'    => '1',

        // Card Display (what to show in branch cards)
        'card_show_address'      => '1',
        'card_show_phone'        => '1',
        'card_show_email'        => '0',
        'card_show_website'      => '0',
        'card_show_status'       => '1',
        'card_show_hours'        => '1',
        'card_show_distance'     => '1',
        'card_show_route_btn'    => '1',
        'card_show_detail_btn'   => '1',
        'card_show_image'        => '1',
        'card_show_country'      => '0',
        'card_show_description'  => '0',
        'card_detail_btn_text'   => 'Details anzeigen',
        'card_route_btn_text'    => 'Route berechnen',

        // Map Popup (what to show in map marker popup)
        'popup_show_address'     => '1',
        'popup_show_phone'       => '1',
        'popup_show_email'       => '0',
        'popup_show_status'      => '1',
        'popup_show_hours'       => '1',
        'popup_show_route_btn'   => '1',

        // Consent
        'consent_enabled'        => '1',
        'consent_placeholder_text' => '',
        'consent_static_image'   => '',

        // Geolocation
        'geo_user_location'      => '0',
        'geo_radius_search'      => '1',
        'geo_search_field'       => '1',
        'geo_show_distance'      => '1',
        'geo_unit'               => 'km',
        'geo_default_radius'     => '50',
        'geo_highlight_nearest'  => '1',

        // Performance
        'performance_lazy_load'  => '1',
        'performance_selective_loading' => '0',
        'performance_footer_scripts' => '1',
        'performance_image_optimization' => '0',

        // Holidays
        'holidays_enabled'              => '1',
        'holidays_show_in_hours'        => '1',
        'holidays_highlight_open_sundays' => '1',
        'holidays_highlight_color'      => '#e8420a',
        'holidays_auto_sync'            => '0',
        'holidays_sync_interval'        => 'weekly',

        // Modal
        'modal_enabled'                 => '1',
        'modal_trigger'                 => 'button',
        'modal_button_text'             => 'Details anzeigen',
        'modal_show_gallery'            => '1',
        'modal_show_videos'             => '1',
        'modal_show_description'        => '1',
        'modal_show_hours'              => '1',
        'modal_show_map'                => '1',
        'modal_show_directions'         => '1',
        'modal_width'                   => 'medium',
        'modal_animation'               => 'fade',
        'modal_overlay_color'           => '#000000',
        'modal_overlay_opacity'         => '50',
        'modal_max_images'              => '10',
        'modal_image_quality'           => 'high',
        'modal_lightbox'                => '1',
        'modal_youtube_privacy'         => '1',

        // Frontend Search/Filter
        'frontend_search_enabled'       => '0',
        'frontend_search_by_zip'        => '1',
        'frontend_search_by_city'       => '1',
        'frontend_search_by_country'    => '1',
        'frontend_search_by_tags'       => '1',
        'frontend_filter_style'         => 'bar',
        'frontend_tag_filter_style'     => 'chips',
    ];

    public function __construct(
        private readonly DbInterface $db
    ) {}

    /**
     * Get a single setting value.
     */
    public function get(string $key, mixed $default = null): mixed
    {
        try {
            $row = $this->db->queryPrepared(
                'SELECT `value` FROM `' . self::TABLE . '` WHERE `key_name` = :key',
                ['key' => $key],
                1
            );
            if ($row && isset($row->value)) {
                return $row->value;
            }
        } catch (\Throwable $e) {
            // Table may not exist yet
        }
        return $default ?? (self::$defaults[$key] ?? null);
    }

    /**
     * Get all settings as key-value array.
     *
     * @return array<string, string>
     */
    public function getAll(): array
    {
        $result = self::$defaults;
        try {
            $rows = $this->db->queryPrepared(
                'SELECT `key_name`, `value` FROM `' . self::TABLE . '`',
                [],
                2
            );
            if (is_array($rows)) {
                foreach ($rows as $row) {
                    $result[$row->key_name] = $row->value;
                }
            }
        } catch (\Throwable $e) {
            // Table may not exist yet
        }
        return $result;
    }

    /**
     * Save a setting.
     */
    public function save(string $key, ?string $value): bool
    {
        try {
            $this->db->queryPrepared(
                'INSERT INTO `' . self::TABLE . '` (`key_name`, `value`) VALUES (:key, :value)
                 ON DUPLICATE KEY UPDATE `value` = :value2',
                ['key' => $key, 'value' => $value, 'value2' => $value]
            );
            return true;
        } catch (\Throwable $e) {
            return false;
        }
    }

    /**
     * Save multiple settings at once.
     *
     * @param array<string, string> $settings
     */
    public function saveMultiple(array $settings): bool
    {
        $success = true;
        foreach ($settings as $key => $value) {
            if (!$this->save($key, $value)) {
                $success = false;
            }
        }
        return $success;
    }

    /**
     * Install default settings.
     */
    public function installDefaults(): void
    {
        foreach (self::$defaults as $key => $value) {
            $this->db->queryPrepared(
                'INSERT IGNORE INTO `' . self::TABLE . '` (`key_name`, `value`) VALUES (:key, :value)',
                ['key' => $key, 'value' => $value]
            );
        }
    }

    /**
     * Add missing settings (for updates).
     */
    public function addMissingSettings(): void
    {
        $this->installDefaults();
    }

    /**
     * Get default values.
     *
     * @return array<string, string>
     */
    public static function getDefaults(): array
    {
        return self::$defaults;
    }
}
