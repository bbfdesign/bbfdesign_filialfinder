<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Services;

use Plugin\bbfdesign_filialfinder\src\Models\Setting;

class GeocodingService
{
    public function __construct(
        private readonly Setting $settings
    ) {}

    /**
     * Geocode an address to coordinates.
     *
     * @return array{lat: float, lng: float}|null
     */
    public function geocode(string $street, string $zip, string $city, string $country = 'DE'): ?array
    {
        $provider = $this->settings->get('map_provider', 'osm');

        return match ($provider) {
            'google' => $this->geocodeGoogle($street, $zip, $city, $country),
            default  => $this->geocodeNominatim($street, $zip, $city, $country),
        };
    }

    /**
     * Test if a Google Maps API key is valid.
     */
    public function testGoogleApiKey(string $apiKey): array
    {
        $url = 'https://maps.googleapis.com/maps/api/geocode/json?address=Berlin&key=' . urlencode($apiKey);
        $response = $this->curlGet($url);

        if ($response === null) {
            return ['success' => false, 'message' => 'Verbindung fehlgeschlagen'];
        }

        $data = json_decode($response, true);
        if (!is_array($data)) {
            return ['success' => false, 'message' => 'Ungültige Antwort'];
        }

        $status = $data['status'] ?? 'UNKNOWN';
        return match ($status) {
            'OK'               => ['success' => true, 'message' => 'API-Key ist gültig'],
            'REQUEST_DENIED'   => ['success' => false, 'message' => 'API-Key ungültig oder Geocoding API nicht aktiviert'],
            'OVER_QUERY_LIMIT' => ['success' => false, 'message' => 'Kontingent überschritten'],
            default            => ['success' => false, 'message' => 'Status: ' . $status],
        };
    }

    /**
     * Geocode via Google Geocoding API.
     */
    private function geocodeGoogle(string $street, string $zip, string $city, string $country): ?array
    {
        $apiKey = $this->settings->get('google_api_key', '');
        if (empty($apiKey)) {
            return null;
        }

        $address = implode(', ', array_filter([$street, $zip . ' ' . $city, $country]));
        $url = 'https://maps.googleapis.com/maps/api/geocode/json?address='
            . urlencode($address) . '&key=' . urlencode($apiKey);

        $response = $this->curlGet($url);
        if ($response === null) {
            return null;
        }

        $data = json_decode($response, true);
        if (!is_array($data) || ($data['status'] ?? '') !== 'OK' || empty($data['results'])) {
            return null;
        }

        $location = $data['results'][0]['geometry']['location'] ?? null;
        if (!$location || !isset($location['lat'], $location['lng'])) {
            return null;
        }

        return [
            'lat' => (float)$location['lat'],
            'lng' => (float)$location['lng'],
        ];
    }

    /**
     * Geocode via OpenStreetMap Nominatim.
     */
    private function geocodeNominatim(string $street, string $zip, string $city, string $country): ?array
    {
        $params = [
            'street'      => $street,
            'postalcode'  => $zip,
            'city'        => $city,
            'countrycodes' => strtolower($country),
            'format'      => 'json',
            'limit'       => 1,
        ];

        $url = 'https://nominatim.openstreetmap.org/search?' . http_build_query($params);
        $response = $this->curlGet($url, [
            'User-Agent: BBF-Filialfinder/1.0',
        ]);

        if ($response === null) {
            return null;
        }

        $data = json_decode($response, true);
        if (!is_array($data) || empty($data)) {
            return null;
        }

        return [
            'lat' => (float)$data[0]['lat'],
            'lng' => (float)$data[0]['lon'],
        ];
    }

    /**
     * Execute a cURL GET request.
     *
     * @param string[] $headers
     */
    private function curlGet(string $url, array $headers = []): ?string
    {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 10,
            CURLOPT_CONNECTTIMEOUT => 5,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);

        if (!empty($headers)) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        }

        $response = curl_exec($ch);
        $httpCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($response === false || $httpCode !== 200) {
            return null;
        }

        return $response;
    }
}
