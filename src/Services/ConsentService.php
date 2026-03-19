<?php
declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Services;

use Plugin\bbfdesign_filialfinder\src\Models\Setting;

class ConsentService
{
    public function __construct(
        private readonly Setting $settings
    ) {}

    public function isConsentRequired(): bool
    {
        return ($this->settings->get('consent_enabled', '1')) === '1';
    }

    public function getMapProviderName(): string
    {
        $provider = $this->settings->get('map_provider', 'osm');
        return match ($provider) {
            'google' => 'Google Maps',
            default  => 'OpenStreetMap',
        };
    }

    public function getConsentVendorId(): string
    {
        return 'bbf_filialfinder_maps';
    }

    public function getConsentConfig(): array
    {
        return [
            'enabled' => $this->isConsentRequired(),
            'provider' => $this->getMapProviderName(),
            'vendorId' => $this->getConsentVendorId(),
        ];
    }
}
