<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Controllers\Admin;

use JTL\DB\DbInterface;
use JTL\Plugin\PluginInterface;
use JTL\Smarty\JTLSmarty;
use Plugin\bbfdesign_filialfinder\src\Models\Branch;
use Plugin\bbfdesign_filialfinder\src\Models\OpeningHours;
use Plugin\bbfdesign_filialfinder\src\Models\Setting;
use Plugin\bbfdesign_filialfinder\src\Models\SpecialDay;
use Plugin\bbfdesign_filialfinder\src\Services\BranchService;
use Plugin\bbfdesign_filialfinder\src\Services\GeocodingService;

class AdminController
{
    private Setting $settings;
    private Branch $branchModel;
    private OpeningHours $hoursModel;
    private SpecialDay $specialDayModel;
    private BranchService $branchService;

    public function __construct(
        private readonly PluginInterface $plugin,
        private readonly JTLSmarty $smarty,
        private readonly DbInterface $db
    ) {
        $this->settings = new Setting($db);
        $this->branchModel = new Branch($db);
        $this->hoursModel = new OpeningHours($db);
        $this->specialDayModel = new SpecialDay($db);
        $this->branchService = new BranchService($db);
    }

    /**
     * Handle AJAX requests from the admin panel.
     *
     * @return array<string, mixed>
     */
    public function handleAjax(): array
    {
        $action = $_REQUEST['action'] ?? 'getPage';

        return match ($action) {
            'getPage'         => $this->getPage(),
            'saveBranch'      => $this->saveBranch(),
            'deleteBranch'    => $this->deleteBranch(),
            'duplicateBranch' => $this->duplicateBranch(),
            'bulkAction'      => $this->bulkAction(),
            'toggleActive'    => $this->toggleActive(),
            'geocode'         => $this->geocode(),
            'testApiKey'      => $this->testApiKey(),
            'saveSettings'    => $this->saveSettings(),
            'uploadImage'     => $this->uploadImage(),
            'deleteImage'     => $this->deleteImage(),
            'getBranch'       => $this->getBranch(),
            default           => $this->getPage(),
        };
    }

    /**
     * Load a page template via AJAX.
     */
    private function getPage(): array
    {
        $page = preg_replace('/[^a-z_]/', '', $_REQUEST['page'] ?? 'branches');
        $templateFile = $this->plugin->getPaths()->getAdminPath() . 'templates/' . $page . '.tpl';

        if (!file_exists($templateFile)) {
            return [
                'success' => true,
                'content' => '<div class="bbf-card"><p>Seite nicht gefunden: ' . htmlspecialchars($page) . '</p></div>',
            ];
        }

        $this->assignPageData($page);

        $this->smarty->assign([
            'adminUrl'    => $this->plugin->getPaths()->getAdminURL(),
            'pluginUrl'   => $this->plugin->getPaths()->getAdminURL(),
            'allSettings' => $this->settings->getAll(),
        ]);

        $content = $this->smarty->fetch($templateFile);

        return [
            'success' => true,
            'content' => $content,
        ];
    }

    /**
     * Assign page-specific template data.
     */
    private function assignPageData(string $page): void
    {
        match ($page) {
            'branches' => $this->assignBranchData(),
            'layouts' => $this->assignLayoutData(),
            'styling' => $this->assignStylingData(),
            'css_editor' => $this->assignCssEditorData(),
            'map_provider' => $this->assignMapProviderData(),
            'opening_status' => $this->assignOpeningStatusData(),
            'consent' => $this->assignConsentData(),
            'geolocation' => $this->assignGeolocationData(),
            'performance' => $this->assignPerformanceData(),
            'documentation' => null,
            'changelog' => null,
            default => null,
        };
    }

    private function assignBranchData(): void
    {
        $branches = $this->branchModel->getAll();
        $this->smarty->assign('branches', $branches);

        // If editing a specific branch
        $editId = (int)($_REQUEST['edit_id'] ?? 0);
        if ($editId > 0) {
            $branch = $this->branchService->getFullBranch($editId);
            $this->smarty->assign('editBranch', $branch);
        }

        $this->smarty->assign('countries', $this->getCountryList());
    }

    private function assignLayoutData(): void
    {
        $this->smarty->assign('currentLayout', $this->settings->get('layout_template', 'default'));
        $this->smarty->assign('layouts', [
            'default'   => ['name' => 'Karte & Liste', 'description' => 'Filial-Liste links, interaktive Karte rechts. Klick auf Filiale zoomt auf Marker.'],
            'map_only'  => ['name' => 'Nur Karte', 'description' => 'Vollbreite Karte mit allen Filialen. Klick öffnet Info-Window.'],
            'grid'      => ['name' => 'Grid / Kachel-Ansicht', 'description' => 'Filialen als Cards in responsivem Grid (2-4 Spalten).'],
            'accordion' => ['name' => 'Akkordeon / Kompakt', 'description' => 'Einklappbare Listenansicht. Platzsparend für viele Standorte.'],
            'table'     => ['name' => 'Tabellarisch', 'description' => 'Responsive Tabelle mit allen Filialen, sortierbar nach Spalten.'],
        ]);

        // Dummy data for preview
        $this->smarty->assign('previewBranches', $this->getPreviewBranches());
    }

    private function assignStylingData(): void
    {
        // Settings already assigned globally
    }

    private function assignCssEditorData(): void
    {
        $this->smarty->assign('customCss', $this->settings->get('custom_css', ''));
    }

    private function assignMapProviderData(): void
    {
        $this->smarty->assign('tileServers', [
            'osm_standard' => ['name' => 'OpenStreetMap Standard', 'url' => 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'],
            'osm_de'       => ['name' => 'OpenStreetMap DE', 'url' => 'https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png'],
            'opentopomap'  => ['name' => 'OpenTopoMap', 'url' => 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png'],
            'stamen_toner' => ['name' => 'Stamen Toner', 'url' => 'https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}.png'],
            'stamen_watercolor' => ['name' => 'Stamen Watercolor', 'url' => 'https://tiles.stadiamaps.com/tiles/stamen_watercolor/{z}/{x}/{y}.jpg'],
            'cartodb_positron' => ['name' => 'CartoDB Positron', 'url' => 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png'],
            'cartodb_dark' => ['name' => 'CartoDB Dark Matter', 'url' => 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'],
            'custom'       => ['name' => 'Benutzerdefiniert', 'url' => ''],
        ]);
    }

    private function assignOpeningStatusData(): void
    {
        // Settings already assigned globally
    }

    private function assignConsentData(): void
    {
        // Settings already assigned globally
    }

    private function assignGeolocationData(): void
    {
        // Settings already assigned globally
    }

    private function assignPerformanceData(): void
    {
        // Settings already assigned globally
    }

    /**
     * Save a branch (create or update).
     */
    private function saveBranch(): array
    {
        $data = [
            'id'              => (int)($_POST['branch_id'] ?? 0),
            'name'            => trim($_POST['name'] ?? ''),
            'description'     => $_POST['description'] ?? '',
            'street'          => trim($_POST['street'] ?? ''),
            'zip'             => trim($_POST['zip'] ?? ''),
            'city'            => trim($_POST['city'] ?? ''),
            'country'         => trim($_POST['country'] ?? 'DE'),
            'phone'           => trim($_POST['phone'] ?? ''),
            'email'           => trim($_POST['email'] ?? ''),
            'website'         => trim($_POST['website'] ?? ''),
            'latitude'        => !empty($_POST['latitude']) ? (float)$_POST['latitude'] : null,
            'longitude'       => !empty($_POST['longitude']) ? (float)$_POST['longitude'] : null,
            'google_place_id' => trim($_POST['google_place_id'] ?? ''),
            'marker_color'    => trim($_POST['marker_color'] ?? ''),
            'css_class'       => trim($_POST['css_class'] ?? ''),
            'sort_order'      => (int)($_POST['sort_order'] ?? 0),
            'is_active'       => (int)($_POST['is_active'] ?? 1),
        ];

        if (empty($data['name'])) {
            return ['success' => false, 'errors' => ['Name ist ein Pflichtfeld.']];
        }

        // Handle image upload
        if (!empty($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
            $uploadDir = $this->plugin->getPaths()->getFrontendPath() . 'img';
            $filename = $this->branchService->handleImageUpload($_FILES['image'], $uploadDir);
            if ($filename) {
                $data['image_path'] = $filename;
            }
        }

        // Parse opening hours
        $hours = [];
        for ($day = 0; $day < 7; $day++) {
            $hours[$day] = [
                'is_open'      => (int)($_POST['hours_is_open'][$day] ?? 0),
                'open_time_1'  => $_POST['hours_open_1'][$day] ?? null,
                'close_time_1' => $_POST['hours_close_1'][$day] ?? null,
                'open_time_2'  => $_POST['hours_open_2'][$day] ?? null,
                'close_time_2' => $_POST['hours_close_2'][$day] ?? null,
            ];
        }

        // Parse special days
        $specialDays = [];
        $sdDates = $_POST['special_day_date'] ?? [];
        $sdClosed = $_POST['special_day_closed'] ?? [];
        $sdOpen = $_POST['special_day_open_time'] ?? [];
        $sdClose = $_POST['special_day_close_time'] ?? [];
        $sdNote = $_POST['special_day_note'] ?? [];
        foreach ($sdDates as $i => $date) {
            if (!empty($date)) {
                $specialDays[] = [
                    'date'       => $date,
                    'is_closed'  => (int)($sdClosed[$i] ?? 0),
                    'open_time'  => $sdOpen[$i] ?? null,
                    'close_time' => $sdClose[$i] ?? null,
                    'note'       => $sdNote[$i] ?? '',
                ];
            }
        }

        try {
            $branchId = $this->branchService->saveFull($data, $hours, $specialDays);
            return [
                'success'  => true,
                'flag'     => true,
                'message'  => 'Filiale erfolgreich gespeichert.',
                'branchId' => $branchId,
            ];
        } catch (\Throwable $e) {
            return ['success' => false, 'errors' => ['Fehler beim Speichern: ' . $e->getMessage()]];
        }
    }

    /**
     * Get a single branch for editing.
     */
    private function getBranch(): array
    {
        $id = (int)($_REQUEST['branch_id'] ?? 0);
        $branch = $this->branchService->getFullBranch($id);

        if (!$branch) {
            return ['success' => false, 'errors' => ['Filiale nicht gefunden.']];
        }

        return ['success' => true, 'branch' => $branch];
    }

    /**
     * Delete a branch.
     */
    private function deleteBranch(): array
    {
        $id = (int)($_POST['branch_id'] ?? 0);
        if ($id <= 0) {
            return ['success' => false, 'errors' => ['Ungültige ID.']];
        }

        // Delete image if exists
        $branch = $this->branchModel->getById($id);
        if ($branch && !empty($branch->image_path)) {
            $uploadDir = $this->plugin->getPaths()->getFrontendPath() . 'img';
            $this->branchService->deleteImage($branch->image_path, $uploadDir);
        }

        $this->branchModel->delete($id);
        return ['success' => true, 'flag' => true, 'message' => 'Filiale erfolgreich gelöscht.'];
    }

    /**
     * Duplicate a branch.
     */
    private function duplicateBranch(): array
    {
        $id = (int)($_POST['branch_id'] ?? 0);
        $newId = $this->branchModel->duplicate($id);

        if ($newId === null) {
            return ['success' => false, 'errors' => ['Filiale nicht gefunden.']];
        }

        return ['success' => true, 'flag' => true, 'message' => 'Filiale erfolgreich dupliziert.', 'newId' => $newId];
    }

    /**
     * Handle bulk actions (activate, deactivate, delete).
     */
    private function bulkAction(): array
    {
        $action = $_POST['bulk_action'] ?? '';
        $ids = array_map('intval', $_POST['branch_ids'] ?? []);

        if (empty($ids)) {
            return ['success' => false, 'errors' => ['Keine Filialen ausgewählt.']];
        }

        return match ($action) {
            'activate' => (function () use ($ids) {
                $this->branchModel->setActiveStatus($ids, true);
                return ['success' => true, 'flag' => true, 'message' => count($ids) . ' Filialen aktiviert.'];
            })(),
            'deactivate' => (function () use ($ids) {
                $this->branchModel->setActiveStatus($ids, false);
                return ['success' => true, 'flag' => true, 'message' => count($ids) . ' Filialen deaktiviert.'];
            })(),
            'delete' => (function () use ($ids) {
                $this->branchModel->deleteMultiple($ids);
                return ['success' => true, 'flag' => true, 'message' => count($ids) . ' Filialen gelöscht.'];
            })(),
            default => ['success' => false, 'errors' => ['Unbekannte Aktion.']],
        };
    }

    /**
     * Toggle active status for a single branch.
     */
    private function toggleActive(): array
    {
        $id = (int)($_POST['branch_id'] ?? 0);
        $active = (int)($_POST['is_active'] ?? 0);

        $this->branchModel->setActiveStatus([$id], (bool)$active);

        return ['success' => true, 'flag' => true, 'message' => 'Status aktualisiert.'];
    }

    /**
     * Geocode an address.
     */
    private function geocode(): array
    {
        $street = trim($_POST['street'] ?? '');
        $zip = trim($_POST['zip'] ?? '');
        $city = trim($_POST['city'] ?? '');
        $country = trim($_POST['country'] ?? 'DE');

        if (empty($city)) {
            return ['success' => false, 'errors' => ['Bitte mindestens die Stadt angeben.']];
        }

        $geocoder = new GeocodingService($this->settings);
        $result = $geocoder->geocode($street, $zip, $city, $country);

        if ($result === null) {
            return ['success' => false, 'errors' => ['Adresse konnte nicht gefunden werden.']];
        }

        return ['success' => true, 'lat' => $result['lat'], 'lng' => $result['lng']];
    }

    /**
     * Test Google Maps API key.
     */
    private function testApiKey(): array
    {
        $apiKey = trim($_POST['api_key'] ?? '');
        if (empty($apiKey)) {
            return ['success' => false, 'errors' => ['Bitte einen API-Key eingeben.']];
        }

        $geocoder = new GeocodingService($this->settings);
        return $geocoder->testGoogleApiKey($apiKey);
    }

    /**
     * Save settings for a specific page.
     */
    private function saveSettings(): array
    {
        $settingsToSave = [];
        $page = $_POST['settings_page'] ?? '';

        foreach ($_POST as $key => $value) {
            if (str_starts_with($key, 'setting_')) {
                $settingKey = substr($key, 8); // Remove 'setting_' prefix
                $settingsToSave[$settingKey] = is_string($value) ? trim($value) : $value;
            }
        }

        if (empty($settingsToSave)) {
            return ['success' => false, 'errors' => ['Keine Einstellungen zum Speichern.']];
        }

        $this->settings->saveMultiple($settingsToSave);

        return ['success' => true, 'flag' => true, 'message' => 'Einstellungen gespeichert.'];
    }

    /**
     * Handle image upload via AJAX.
     */
    private function uploadImage(): array
    {
        if (empty($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
            return ['success' => false, 'errors' => ['Kein Bild hochgeladen.']];
        }

        $uploadDir = $this->plugin->getPaths()->getFrontendPath() . 'img';
        $filename = $this->branchService->handleImageUpload($_FILES['image'], $uploadDir);

        if (!$filename) {
            return ['success' => false, 'errors' => ['Upload fehlgeschlagen. Erlaubte Formate: JPG, PNG, GIF, WebP, SVG (max. 5MB).']];
        }

        $frontendUrl = $this->plugin->getPaths()->getFrontendURL() . 'img/' . $filename;
        return ['success' => true, 'filename' => $filename, 'url' => $frontendUrl];
    }

    /**
     * Delete an image file.
     */
    private function deleteImage(): array
    {
        $filename = basename(trim($_POST['filename'] ?? ''));
        if (empty($filename)) {
            return ['success' => false, 'errors' => ['Kein Dateiname angegeben.']];
        }

        $uploadDir = $this->plugin->getPaths()->getFrontendPath() . 'img';
        $this->branchService->deleteImage($filename, $uploadDir);

        return ['success' => true, 'flag' => true, 'message' => 'Bild gelöscht.'];
    }

    /**
     * Get preview branches for layout preview.
     *
     * @return array<int, array<string, mixed>>
     */
    private function getPreviewBranches(): array
    {
        return [
            [
                'id' => 1,
                'name' => 'God of Games Hof',
                'street' => 'Lorenzstraße 14',
                'zip' => '95028',
                'city' => 'Hof',
                'country' => 'DE',
                'phone' => '09281 1446128',
                'email' => 'hof@godofgames.de',
                'latitude' => 50.3135,
                'longitude' => 11.9128,
                'is_active' => 1,
                'status' => ['status' => 'open', 'text' => 'Jetzt geöffnet (bis 19:00)', 'cssClass' => 'bbf-filialfinder-status--open'],
            ],
            [
                'id' => 2,
                'name' => 'God of Games Plauen',
                'street' => 'Postplatz 5',
                'zip' => '08523',
                'city' => 'Plauen',
                'country' => 'DE',
                'phone' => '03741 5987412',
                'email' => 'plauen@godofgames.de',
                'latitude' => 50.4942,
                'longitude' => 12.1374,
                'is_active' => 1,
                'status' => ['status' => 'closed', 'text' => 'Jetzt geschlossen · Öffnet Montag um 10:00', 'cssClass' => 'bbf-filialfinder-status--closed'],
            ],
        ];
    }

    /**
     * Get ISO country list for dropdowns.
     *
     * @return array<string, string>
     */
    private function getCountryList(): array
    {
        return [
            'DE' => 'Deutschland',
            'AT' => 'Österreich',
            'CH' => 'Schweiz',
            'LI' => 'Liechtenstein',
            'LU' => 'Luxemburg',
            'BE' => 'Belgien',
            'NL' => 'Niederlande',
            'FR' => 'Frankreich',
            'IT' => 'Italien',
            'ES' => 'Spanien',
            'PT' => 'Portugal',
            'GB' => 'Großbritannien',
            'IE' => 'Irland',
            'DK' => 'Dänemark',
            'SE' => 'Schweden',
            'NO' => 'Norwegen',
            'FI' => 'Finnland',
            'PL' => 'Polen',
            'CZ' => 'Tschechien',
            'SK' => 'Slowakei',
            'HU' => 'Ungarn',
            'HR' => 'Kroatien',
            'SI' => 'Slowenien',
            'RO' => 'Rumänien',
            'BG' => 'Bulgarien',
            'GR' => 'Griechenland',
        ];
    }
}
