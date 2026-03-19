<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Services;

use JTL\DB\DbInterface;
use JTL\Plugin\PluginInterface;
use Plugin\bbfdesign_filialfinder\src\Models\Setting;

class ConsentService
{
    public function __construct(
        private readonly PluginInterface $plugin,
        private readonly DbInterface $db,
        private readonly Setting $settings
    ) {}

    /**
     * Register consent vendor based on map provider setting.
     * Called during bootstrap to integrate with JTL Consent Manager.
     */
    public function registerConsentVendor(): void
    {
        $allSettings = $this->settings->getAll();
        if (($allSettings['consent_enabled'] ?? '1') !== '1') {
            return;
        }

        $provider = $allSettings['map_provider'] ?? 'osm';

        $vendorName = match ($provider) {
            'google' => 'Google Maps',
            default  => 'OpenStreetMap',
        };

        $vendorDescription = match ($provider) {
            'google' => 'Google Maps wird verwendet, um interaktive Karten mit Filialstandorten anzuzeigen. Dabei werden Daten an Google übermittelt.',
            default  => 'OpenStreetMap wird verwendet, um interaktive Karten mit Filialstandorten anzuzeigen. Dabei werden Kartendaten von externen Tile-Servern geladen.',
        };

        $vendorPrivacyUrl = match ($provider) {
            'google' => 'https://policies.google.com/privacy',
            default  => 'https://wiki.osmfoundation.org/wiki/Privacy_Policy',
        };

        // The JTL Consent Manager integration is done via the consent_manager
        // table entries. We check if our vendor exists and create it if not.
        try {
            // First check if the consent vendor table exists in this JTL version
            $tableCheck = $this->db->queryPrepared(
                "SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tconsent_vendor' LIMIT 1",
                [],
                1
            );
            if (!$tableCheck) {
                // Table doesn't exist in this JTL version — skip consent registration
                return;
            }

            $pluginId = $this->plugin->getID();
            $existing = $this->db->queryPrepared(
                "SELECT * FROM `tconsent_vendor` WHERE `plugin_id` = :pluginId AND `name` = :name LIMIT 1",
                ['pluginId' => $pluginId, 'name' => 'bbf_filialfinder_maps'],
                1
            );

            if (!$existing) {
                // Register new vendor entry
                $this->db->queryPrepared(
                    "INSERT INTO `tconsent_vendor` (`plugin_id`, `name`, `purpose`, `description`, `privacy_policy`, `company`, `localization`)
                     VALUES (:pluginId, :name, :purpose, :description, :privacy, :company, :localization)",
                    [
                        'pluginId'     => $pluginId,
                        'name'         => 'bbf_filialfinder_maps',
                        'purpose'      => 'functional',
                        'description'  => $vendorDescription,
                        'privacy'      => $vendorPrivacyUrl,
                        'company'      => $vendorName,
                        'localization' => json_encode([
                            'de-DE' => [
                                'name'        => $vendorName,
                                'description' => $vendorDescription,
                                'purpose'     => 'Funktional',
                            ],
                            'en-US' => [
                                'name'        => $vendorName,
                                'description' => str_replace(
                                    ['wird verwendet', 'anzuzeigen', 'Dabei werden', 'übermittelt', 'geladen'],
                                    ['is used', 'to display', 'Data is', 'transmitted', 'loaded'],
                                    $vendorDescription
                                ),
                                'purpose'     => 'Functional',
                            ],
                        ]),
                    ]
                );
            }
        } catch (\Throwable $e) {
            // Consent manager table may not exist in all versions
            // or our vendor column structure may differ — fail silently
        }
    }

    /**
     * Remove consent vendor on uninstall.
     */
    public function removeConsentVendor(): void
    {
        try {
            $tableCheck = $this->db->queryPrepared(
                "SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tconsent_vendor' LIMIT 1",
                [],
                1
            );
            if (!$tableCheck) {
                return;
            }
            $pluginId = $this->plugin->getID();
            $this->db->queryPrepared(
                "DELETE FROM `tconsent_vendor` WHERE `plugin_id` = :pluginId AND `name` = :name",
                ['pluginId' => $pluginId, 'name' => 'bbf_filialfinder_maps']
            );
        } catch (\Throwable $e) {
            // Silent fail
        }
    }

    /**
     * Get the consent vendor ID for JS integration.
     */
    public function getConsentVendorId(): ?string
    {
        return 'bbf_filialfinder_maps';
    }

    /**
     * Check if consent is required.
     */
    public function isConsentRequired(): bool
    {
        return ($this->settings->get('consent_enabled', '1')) === '1';
    }
}
