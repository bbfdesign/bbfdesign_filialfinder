<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Controllers\Admin;

use JTL\DB\DbInterface;
use JTL\Plugin\PluginInterface;
use JTL\Smarty\JTLSmarty;
use Plugin\bbfdesign_filialfinder\src\Models\Branch;
use Plugin\bbfdesign_filialfinder\src\Models\Gallery;
use Plugin\bbfdesign_filialfinder\src\Models\Holiday;
use Plugin\bbfdesign_filialfinder\src\Models\HolidayCalendar;
use Plugin\bbfdesign_filialfinder\src\Models\OpeningHours;
use Plugin\bbfdesign_filialfinder\src\Models\Setting;
use Plugin\bbfdesign_filialfinder\src\Models\SpecialDay;
use Plugin\bbfdesign_filialfinder\src\Models\Video;
use Plugin\bbfdesign_filialfinder\src\Services\BranchService;
use Plugin\bbfdesign_filialfinder\src\Services\GeocodingService;
use Plugin\bbfdesign_filialfinder\src\Services\HolidayService;

class AdminController
{
    private Setting $settings;
    private Branch $branchModel;
    private OpeningHours $hoursModel;
    private SpecialDay $specialDayModel;
    private BranchService $branchService;
    private Holiday $holidayModel;
    private HolidayCalendar $calendarModel;
    private HolidayService $holidayService;
    private Gallery $galleryModel;
    private Video $videoModel;

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
        $this->holidayModel = new Holiday($db);
        $this->calendarModel = new HolidayCalendar($db);
        $this->holidayService = new HolidayService($db);
        $this->galleryModel = new Gallery($db);
        $this->videoModel = new Video($db);
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
            // Page loading
            'getPage'         => $this->getPage(),

            // Branch actions
            'saveBranch'      => $this->saveBranch(),
            'deleteBranch'    => $this->deleteBranch(),
            'duplicateBranch' => $this->duplicateBranch(),
            'bulkAction'      => $this->bulkAction(),
            'toggleActive'    => $this->toggleActive(),
            'getBranch'       => $this->getBranch(),

            // Geocoding actions
            'geocode'         => $this->geocode(),
            'testApiKey'      => $this->testApiKey(),

            // Settings actions
            'saveSettings'    => $this->saveSettings(),

            // Image actions (branch main image)
            'uploadImage'     => $this->uploadImage(),
            'deleteImage'     => $this->deleteImage(),

            // Holiday actions
            'saveCalendar'    => $this->saveCalendar(),
            'deleteCalendar'  => $this->deleteCalendar(),
            'syncCalendar'    => $this->syncCalendar(),
            'saveHoliday'     => $this->saveHoliday(),
            'deleteHoliday'   => $this->deleteHoliday(),

            // Gallery actions
            'uploadGalleryImage' => $this->uploadGalleryImage(),
            'deleteGalleryImage' => $this->deleteGalleryImage(),
            'sortGallery'        => $this->sortGallery(),

            // Video actions
            'saveVideo'    => $this->saveVideo(),
            'deleteVideo'  => $this->deleteVideo(),

            // Import/Export actions
            'exportBranches' => $this->exportBranches(),
            'importBranches' => $this->importBranches(),

            // Tag actions
            'saveTags'   => $this->saveTags(),
            'deleteTag'  => $this->deleteTag(),
            'getTags'    => $this->getTags(),

            default => $this->getPage(),
        };
    }

    // =========================================================================
    // Page Loading
    // =========================================================================

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
            'branches'       => $this->assignBranchData(),
            'layouts'        => $this->assignLayoutData(),
            'styling'        => $this->assignStylingData(),
            'css_editor'     => $this->assignCssEditorData(),
            'map_provider'   => $this->assignMapProviderData(),
            'opening_status' => $this->assignOpeningStatusData(),
            'consent'        => $this->assignConsentData(),
            'geolocation'    => $this->assignGeolocationData(),
            'performance'    => $this->assignPerformanceData(),
            'holidays'       => $this->assignHolidayData(),
            'modal_settings' => null, // settings already assigned globally
            'import_export'  => $this->assignImportExportData(),
            'documentation'  => null,
            'changelog'      => null,
            default          => null,
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
     * Assign holiday page data: calendars, holidays, upcoming, open sundays, branches.
     */
    private function assignHolidayData(): void
    {
        $calendars = $this->calendarModel->getAll();
        $holidays = $this->holidayModel->getAll();
        $upcoming = $this->holidayModel->getUpcoming(15);
        $openSundays = $this->holidayModel->getOpenSundays(10);
        $branches = $this->branchModel->getAll();

        $this->smarty->assign([
            'calendars'        => $calendars,
            'holidays'         => $holidays,
            'upcomingHolidays' => $upcoming,
            'openSundays'      => $openSundays,
            'branches'         => $branches,
        ]);
    }

    /**
     * Assign import/export page data.
     */
    private function assignImportExportData(): void
    {
        $branchCount = $this->branchModel->count();
        $this->smarty->assign('branchCount', $branchCount);
    }

    // =========================================================================
    // Branch Actions
    // =========================================================================

    /**
     * Save a branch (create or update).
     */
    private function saveBranch(): array
    {
        $data = [
            'id'               => (int)($_POST['branch_id'] ?? 0),
            'name'             => trim($_POST['name'] ?? ''),
            'description'      => $_POST['description'] ?? '',
            'description_html' => $_POST['description_html'] ?? '',
            'street'           => trim($_POST['street'] ?? ''),
            'zip'              => trim($_POST['zip'] ?? ''),
            'city'             => trim($_POST['city'] ?? ''),
            'country'          => trim($_POST['country'] ?? 'DE'),
            'phone'            => trim($_POST['phone'] ?? ''),
            'email'            => trim($_POST['email'] ?? ''),
            'website'          => trim($_POST['website'] ?? ''),
            'latitude'         => !empty($_POST['latitude']) ? (float)$_POST['latitude'] : null,
            'longitude'        => !empty($_POST['longitude']) ? (float)$_POST['longitude'] : null,
            'google_place_id'  => trim($_POST['google_place_id'] ?? ''),
            'marker_color'     => trim($_POST['marker_color'] ?? ''),
            'css_class'        => trim($_POST['css_class'] ?? ''),
            'sort_order'       => (int)($_POST['sort_order'] ?? 0),
            'is_active'        => (int)($_POST['is_active'] ?? 1),
        ];

        // Handle tags — input can be JSON array OR comma-separated string
        if (isset($_POST['tags'])) {
            $tagsRaw = trim($_POST['tags']);
            // Try JSON decode first (frontend sends JSON array)
            $decoded = json_decode($tagsRaw, true);
            if (is_array($decoded)) {
                // Already JSON — filter empty values
                $tags = array_values(array_filter(
                    array_map('trim', $decoded),
                    static fn(string $t): bool => $t !== ''
                ));
            } elseif ($tagsRaw !== '' && $tagsRaw !== '[]') {
                // Comma-separated string (e.g. from import)
                $tags = array_map('trim', explode(',', $tagsRaw));
                $tags = array_values(array_filter($tags, static fn(string $t): bool => $t !== ''));
            } else {
                $tags = [];
            }
            $data['tags'] = !empty($tags) ? json_encode($tags, JSON_UNESCAPED_UNICODE) : null;
        }

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

    // =========================================================================
    // Geocoding Actions
    // =========================================================================

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

    // =========================================================================
    // Settings Actions
    // =========================================================================

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

    // =========================================================================
    // Branch Image Actions
    // =========================================================================

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

    // =========================================================================
    // Holiday / Calendar Actions
    // =========================================================================

    /**
     * Save an iCal calendar subscription.
     */
    private function saveCalendar(): array
    {
        $data = [
            'id'        => (int)($_POST['calendar_id'] ?? 0),
            'name'      => trim($_POST['calendar_name'] ?? $_POST['name'] ?? ''),
            'ical_url'  => trim($_POST['calendar_url'] ?? $_POST['ical_url'] ?? ''),
            'is_active' => (int)($_POST['is_active'] ?? 1),
        ];

        if (empty($data['name'])) {
            return ['success' => false, 'errors' => ['Name ist ein Pflichtfeld.']];
        }

        if (empty($data['ical_url'])) {
            return ['success' => false, 'errors' => ['iCal-URL ist ein Pflichtfeld.']];
        }

        try {
            $calendarId = $this->calendarModel->save($data);
            return [
                'success'    => true,
                'flag'       => true,
                'message'    => 'Kalender erfolgreich gespeichert.',
                'calendarId' => $calendarId,
            ];
        } catch (\Throwable $e) {
            return ['success' => false, 'errors' => ['Fehler beim Speichern: ' . $e->getMessage()]];
        }
    }

    /**
     * Delete a calendar and all its associated holidays.
     */
    private function deleteCalendar(): array
    {
        $id = (int)($_POST['calendar_id'] ?? 0);
        if ($id <= 0) {
            return ['success' => false, 'errors' => ['Ungültige ID.']];
        }

        // Delete associated holidays first
        $this->holidayModel->deleteByCalendarId($id);
        $this->calendarModel->delete($id);

        return ['success' => true, 'flag' => true, 'message' => 'Kalender und zugehörige Feiertage gelöscht.'];
    }

    /**
     * Sync holidays from an iCal calendar subscription.
     */
    private function syncCalendar(): array
    {
        $calendarId = (int)($_POST['calendar_id'] ?? 0);
        if ($calendarId <= 0) {
            return ['success' => false, 'errors' => ['Ungültige Kalender-ID.']];
        }

        $result = $this->holidayService->syncCalendar($calendarId);

        if ($result['success']) {
            return [
                'success'  => true,
                'flag'     => true,
                'message'  => $result['imported'] . ' Feiertage importiert.',
                'imported' => $result['imported'],
                'errors'   => $result['errors'],
            ];
        }

        return ['success' => false, 'errors' => $result['errors']];
    }

    /**
     * Save an individual holiday.
     */
    private function saveHoliday(): array
    {
        $data = [
            'id'             => (int)($_POST['holiday_id'] ?? 0),
            'calendar_id'    => !empty($_POST['calendar_id']) ? (int)$_POST['calendar_id'] : null,
            'name'           => trim($_POST['name'] ?? ''),
            'date'           => trim($_POST['date'] ?? ''),
            'is_recurring'   => (int)($_POST['is_recurring'] ?? 0),
            'type'           => trim($_POST['type'] ?? 'holiday'),
            'applies_to_all' => (int)($_POST['applies_to_all'] ?? 1),
            'branch_ids'     => trim($_POST['branch_ids'] ?? ''),
            'default_closed' => (int)($_POST['default_closed'] ?? 1),
            'open_override'  => (int)($_POST['open_override'] ?? 0),
            'open_time'      => !empty($_POST['open_time']) ? trim($_POST['open_time']) : null,
            'close_time'     => !empty($_POST['close_time']) ? trim($_POST['close_time']) : null,
            'note'           => trim($_POST['note'] ?? ''),
            'highlight'      => (int)($_POST['highlight'] ?? 0),
            'highlight_text' => trim($_POST['highlight_text'] ?? ''),
        ];

        if (empty($data['name'])) {
            return ['success' => false, 'errors' => ['Name ist ein Pflichtfeld.']];
        }

        if (empty($data['date'])) {
            return ['success' => false, 'errors' => ['Datum ist ein Pflichtfeld.']];
        }

        try {
            $holidayId = $this->holidayModel->save($data);
            return [
                'success'   => true,
                'flag'      => true,
                'message'   => 'Feiertag erfolgreich gespeichert.',
                'holidayId' => $holidayId,
            ];
        } catch (\Throwable $e) {
            return ['success' => false, 'errors' => ['Fehler beim Speichern: ' . $e->getMessage()]];
        }
    }

    /**
     * Delete a holiday.
     */
    private function deleteHoliday(): array
    {
        $id = (int)($_POST['holiday_id'] ?? 0);
        if ($id <= 0) {
            return ['success' => false, 'errors' => ['Ungültige ID.']];
        }

        $this->holidayModel->delete($id);

        return ['success' => true, 'flag' => true, 'message' => 'Feiertag gelöscht.'];
    }

    // =========================================================================
    // Gallery Actions
    // =========================================================================

    /**
     * Upload an image to the branch gallery.
     */
    private function uploadGalleryImage(): array
    {
        $branchId = (int)($_POST['branch_id'] ?? 0);
        if ($branchId <= 0) {
            return ['success' => false, 'errors' => ['Ungültige Filial-ID.']];
        }

        if (empty($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
            return ['success' => false, 'errors' => ['Kein Bild hochgeladen.']];
        }

        $uploadDir = $this->plugin->getPaths()->getFrontendPath() . 'img/gallery';
        $filename = $this->branchService->handleImageUpload($_FILES['image'], $uploadDir);

        if (!$filename) {
            return ['success' => false, 'errors' => ['Upload fehlgeschlagen. Erlaubte Formate: JPG, PNG, GIF, WebP, SVG (max. 5MB).']];
        }

        // Determine next sort order
        $existing = $this->galleryModel->getByBranchId($branchId);
        $nextSort = 0;
        foreach ($existing as $img) {
            if ((int)$img->sort_order >= $nextSort) {
                $nextSort = (int)$img->sort_order + 1;
            }
        }

        $galleryId = $this->galleryModel->save([
            'branch_id'  => $branchId,
            'image_path' => $filename,
            'title'      => trim($_POST['title'] ?? ''),
            'alt_text'   => trim($_POST['alt_text'] ?? ''),
            'sort_order' => $nextSort,
        ]);

        $frontendUrl = $this->plugin->getPaths()->getFrontendURL() . 'img/gallery/' . $filename;

        return [
            'success'   => true,
            'flag'      => true,
            'message'   => 'Bild zur Galerie hinzugefügt.',
            'galleryId' => $galleryId,
            'filename'  => $filename,
            'url'       => $frontendUrl,
        ];
    }

    /**
     * Delete a gallery image (file and DB record).
     */
    private function deleteGalleryImage(): array
    {
        $id = (int)($_POST['gallery_id'] ?? 0);
        if ($id <= 0) {
            return ['success' => false, 'errors' => ['Ungültige ID.']];
        }

        // Get record to find the file
        $images = $this->db->queryPrepared(
            'SELECT * FROM `bbf_filialfinder_gallery` WHERE `id` = :id',
            ['id' => $id],
            1
        );

        if ($images && !empty($images->image_path)) {
            $filePath = $this->plugin->getPaths()->getFrontendPath() . 'img/gallery/' . basename($images->image_path);
            if (file_exists($filePath)) {
                @unlink($filePath);
            }
        }

        $this->galleryModel->delete($id);

        return ['success' => true, 'flag' => true, 'message' => 'Galeriebild gelöscht.'];
    }

    /**
     * Update sort order for gallery images.
     * Expects JSON array of {id: sortOrder} pairs in POST 'order'.
     */
    private function sortGallery(): array
    {
        $orderJson = $_POST['order'] ?? '[]';
        $order = json_decode($orderJson, true);

        if (!is_array($order) || empty($order)) {
            return ['success' => false, 'errors' => ['Keine Sortierung angegeben.']];
        }

        foreach ($order as $id => $sortOrder) {
            $this->galleryModel->updateSortOrder((int)$id, (int)$sortOrder);
        }

        return ['success' => true, 'flag' => true, 'message' => 'Sortierung aktualisiert.'];
    }

    // =========================================================================
    // Video Actions
    // =========================================================================

    /**
     * Save a video with automatic type detection.
     */
    private function saveVideo(): array
    {
        $data = [
            'id'        => (int)($_POST['video_id'] ?? 0),
            'branch_id' => (int)($_POST['branch_id'] ?? 0),
            'video_url' => trim($_POST['video_url'] ?? ''),
            'title'     => trim($_POST['title'] ?? ''),
            'sort_order' => (int)($_POST['sort_order'] ?? 0),
        ];

        if ($data['branch_id'] <= 0) {
            return ['success' => false, 'errors' => ['Ungültige Filial-ID.']];
        }

        if (empty($data['video_url'])) {
            return ['success' => false, 'errors' => ['Video-URL ist ein Pflichtfeld.']];
        }

        // Auto-detect video type from URL
        $data['video_type'] = $this->detectVideoType($data['video_url']);

        // Handle optional thumbnail upload
        if (!empty($_FILES['thumbnail']) && $_FILES['thumbnail']['error'] === UPLOAD_ERR_OK) {
            $uploadDir = $this->plugin->getPaths()->getFrontendPath() . 'img/videos';
            $filename = $this->branchService->handleImageUpload($_FILES['thumbnail'], $uploadDir);
            if ($filename) {
                $data['thumbnail_path'] = $filename;
            }
        }

        try {
            $videoId = $this->videoModel->save($data);
            return [
                'success' => true,
                'flag'    => true,
                'message' => 'Video erfolgreich gespeichert.',
                'videoId' => $videoId,
            ];
        } catch (\Throwable $e) {
            return ['success' => false, 'errors' => ['Fehler beim Speichern: ' . $e->getMessage()]];
        }
    }

    /**
     * Delete a video record.
     */
    private function deleteVideo(): array
    {
        $id = (int)($_POST['video_id'] ?? 0);
        if ($id <= 0) {
            return ['success' => false, 'errors' => ['Ungültige ID.']];
        }

        // Delete thumbnail if exists
        $video = $this->db->queryPrepared(
            'SELECT * FROM `bbf_filialfinder_videos` WHERE `id` = :id',
            ['id' => $id],
            1
        );

        if ($video && !empty($video->thumbnail_path)) {
            $filePath = $this->plugin->getPaths()->getFrontendPath() . 'img/videos/' . basename($video->thumbnail_path);
            if (file_exists($filePath)) {
                @unlink($filePath);
            }
        }

        $this->videoModel->delete($id);

        return ['success' => true, 'flag' => true, 'message' => 'Video gelöscht.'];
    }

    /**
     * Detect video type from URL.
     */
    private function detectVideoType(string $url): string
    {
        $urlLower = strtolower($url);

        if (str_contains($urlLower, 'youtube.com') || str_contains($urlLower, 'youtu.be')) {
            return 'youtube';
        }

        if (str_contains($urlLower, 'vimeo.com')) {
            return 'vimeo';
        }

        if (str_ends_with($urlLower, '.mp4')) {
            return 'mp4';
        }

        return 'embed';
    }

    // =========================================================================
    // Import / Export Actions
    // =========================================================================

    /**
     * Export branches in the chosen format (csv, json, xml).
     * Returns downloadable content with appropriate headers.
     */
    private function exportBranches(): array
    {
        $format = strtolower(trim($_POST['format'] ?? 'csv'));
        $branches = $this->branchModel->getAll();

        // Enrich branches with hours, special days, tags
        $exportData = [];
        foreach ($branches as $branch) {
            $branchData = (array)$branch;
            $branchData['hours'] = $this->hoursModel->getByBranchId((int)$branch->id);
            $branchData['special_days'] = $this->specialDayModel->getByBranchId((int)$branch->id);
            $exportData[] = $branchData;
        }

        return match ($format) {
            'json' => $this->exportAsJson($exportData),
            'xml'  => $this->exportAsXml($exportData),
            default => $this->exportAsCsv($exportData),
        };
    }

    /**
     * Export as CSV (semicolon-delimited, UTF-8 BOM, flat structure).
     *
     * @param array<int, array<string, mixed>> $branches
     */
    private function exportAsCsv(array $branches): array
    {
        $flatFields = [
            'id', 'name', 'description', 'description_html', 'street', 'zip', 'city', 'country',
            'phone', 'email', 'website', 'latitude', 'longitude', 'google_place_id',
            'marker_color', 'css_class', 'sort_order', 'is_active', 'image_path', 'tags',
        ];

        // Build hour column headers (Mon-Sun, open1/close1/open2/close2)
        $dayNames = ['mo', 'di', 'mi', 'do', 'fr', 'sa', 'so'];
        $hourHeaders = [];
        foreach ($dayNames as $day) {
            $hourHeaders[] = $day . '_is_open';
            $hourHeaders[] = $day . '_open_1';
            $hourHeaders[] = $day . '_close_1';
            $hourHeaders[] = $day . '_open_2';
            $hourHeaders[] = $day . '_close_2';
        }

        $allHeaders = array_merge($flatFields, $hourHeaders);

        $output = "\xEF\xBB\xBF"; // UTF-8 BOM
        $output .= implode(';', $allHeaders) . "\r\n";

        foreach ($branches as $branch) {
            $row = [];
            foreach ($flatFields as $field) {
                $value = $branch[$field] ?? '';
                $value = str_replace(['"', "\r", "\n"], ['""', '', ' '], (string)$value);
                $row[] = '"' . $value . '"';
            }

            // Opening hours columns
            $hours = $branch['hours'] ?? [];
            $hoursByDay = [];
            foreach ($hours as $h) {
                $h = (object)$h;
                $hoursByDay[(int)$h->day_of_week] = $h;
            }

            for ($d = 0; $d < 7; $d++) {
                $h = $hoursByDay[$d] ?? null;
                $row[] = '"' . ($h ? (string)($h->is_open ?? '0') : '0') . '"';
                $row[] = '"' . ($h->open_time_1 ?? '') . '"';
                $row[] = '"' . ($h->close_time_1 ?? '') . '"';
                $row[] = '"' . ($h->open_time_2 ?? '') . '"';
                $row[] = '"' . ($h->close_time_2 ?? '') . '"';
            }

            $output .= implode(';', $row) . "\r\n";
        }

        $filename = 'filialen_export_' . date('Y-m-d_His') . '.csv';

        return [
            'success'  => true,
            'download' => true,
            'filename' => $filename,
            'mimetype' => 'text/csv; charset=utf-8',
            'content'  => base64_encode($output),
        ];
    }

    /**
     * Export as JSON (nested structure).
     *
     * @param array<int, array<string, mixed>> $branches
     */
    private function exportAsJson(array $branches): array
    {
        // Convert hour/special_day objects to arrays for clean JSON
        $cleanData = [];
        foreach ($branches as $branch) {
            $hours = [];
            foreach (($branch['hours'] ?? []) as $h) {
                $hours[] = (array)$h;
            }
            $specialDays = [];
            foreach (($branch['special_days'] ?? []) as $sd) {
                $specialDays[] = (array)$sd;
            }

            $entry = $branch;
            $entry['hours'] = $hours;
            $entry['special_days'] = $specialDays;
            $cleanData[] = $entry;
        }

        $json = json_encode($cleanData, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        $filename = 'filialen_export_' . date('Y-m-d_His') . '.json';

        return [
            'success'  => true,
            'download' => true,
            'filename' => $filename,
            'mimetype' => 'application/json; charset=utf-8',
            'content'  => base64_encode($json),
        ];
    }

    /**
     * Export as XML (proper structure).
     *
     * @param array<int, array<string, mixed>> $branches
     */
    private function exportAsXml(array $branches): array
    {
        $xml = new \SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><branches/>');

        foreach ($branches as $branch) {
            $node = $xml->addChild('branch');

            $skipFields = ['hours', 'special_days'];
            foreach ($branch as $key => $value) {
                if (in_array($key, $skipFields, true)) {
                    continue;
                }
                if ($value === null) {
                    $value = '';
                }
                $node->addChild($key, htmlspecialchars((string)$value, ENT_XML1, 'UTF-8'));
            }

            // Hours
            $hoursNode = $node->addChild('opening_hours');
            foreach (($branch['hours'] ?? []) as $h) {
                $h = (object)$h;
                $dayNode = $hoursNode->addChild('day');
                $dayNode->addChild('day_of_week', (string)($h->day_of_week ?? ''));
                $dayNode->addChild('is_open', (string)($h->is_open ?? '0'));
                $dayNode->addChild('open_time_1', (string)($h->open_time_1 ?? ''));
                $dayNode->addChild('close_time_1', (string)($h->close_time_1 ?? ''));
                $dayNode->addChild('open_time_2', (string)($h->open_time_2 ?? ''));
                $dayNode->addChild('close_time_2', (string)($h->close_time_2 ?? ''));
            }

            // Special days
            $sdNode = $node->addChild('special_days');
            foreach (($branch['special_days'] ?? []) as $sd) {
                $sd = (object)$sd;
                $entry = $sdNode->addChild('special_day');
                $entry->addChild('date', (string)($sd->date ?? ''));
                $entry->addChild('is_closed', (string)($sd->is_closed ?? '0'));
                $entry->addChild('open_time', (string)($sd->open_time ?? ''));
                $entry->addChild('close_time', (string)($sd->close_time ?? ''));
                $entry->addChild('note', htmlspecialchars((string)($sd->note ?? ''), ENT_XML1, 'UTF-8'));
            }
        }

        $xmlString = $xml->asXML();
        $filename = 'filialen_export_' . date('Y-m-d_His') . '.xml';

        return [
            'success'  => true,
            'download' => true,
            'filename' => $filename,
            'mimetype' => 'application/xml; charset=utf-8',
            'content'  => base64_encode($xmlString),
        ];
    }

    /**
     * Import branches from an uploaded file (CSV, JSON, or XML).
     */
    private function importBranches(): array
    {
        if (empty($_FILES['import_file']) || $_FILES['import_file']['error'] !== UPLOAD_ERR_OK) {
            return ['success' => false, 'errors' => ['Keine Datei hochgeladen.']];
        }

        $file = $_FILES['import_file'];
        $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        $content = file_get_contents($file['tmp_name']);

        if ($content === false || $content === '') {
            return ['success' => false, 'errors' => ['Datei ist leer oder konnte nicht gelesen werden.']];
        }

        return match ($ext) {
            'json' => $this->importFromJson($content),
            'xml'  => $this->importFromXml($content),
            'csv', 'txt' => $this->importFromCsv($content),
            default => ['success' => false, 'errors' => ['Nicht unterstütztes Format: ' . $ext . '. Erlaubt: CSV, JSON, XML.']],
        };
    }

    /**
     * Import branches from CSV content.
     */
    private function importFromCsv(string $content): array
    {
        $errors = [];
        $imported = 0;

        // Remove UTF-8 BOM if present
        if (str_starts_with($content, "\xEF\xBB\xBF")) {
            $content = substr($content, 3);
        }

        // Detect delimiter (semicolon or comma)
        $firstLine = strtok($content, "\r\n");
        $delimiter = substr_count($firstLine, ';') >= substr_count($firstLine, ',') ? ';' : ',';

        // Parse CSV
        $lines = str_getcsv_lines($content, $delimiter);
        if ($lines === null) {
            // Fallback: manual parsing
            $lines = $this->parseCsvString($content, $delimiter);
        }

        if (empty($lines)) {
            return ['success' => false, 'errors' => ['CSV-Datei enthält keine Daten.']];
        }

        $headers = array_shift($lines);
        $headers = array_map('trim', $headers);

        $dayNames = ['mo', 'di', 'mi', 'do', 'fr', 'sa', 'so'];

        foreach ($lines as $lineNum => $row) {
            if (count($row) < 2) {
                continue; // Skip empty rows
            }

            $rowData = [];
            foreach ($headers as $i => $header) {
                $rowData[$header] = $row[$i] ?? '';
            }

            $name = trim($rowData['name'] ?? '');
            if (empty($name)) {
                $errors[] = 'Zeile ' . ($lineNum + 2) . ': Name fehlt, übersprungen.';
                continue;
            }

            // Build branch data (exclude id to always create new)
            $branchData = [
                'name'             => $name,
                'description'      => $rowData['description'] ?? '',
                'description_html' => $rowData['description_html'] ?? '',
                'street'           => trim($rowData['street'] ?? ''),
                'zip'              => trim($rowData['zip'] ?? ''),
                'city'             => trim($rowData['city'] ?? ''),
                'country'          => trim($rowData['country'] ?? 'DE'),
                'phone'            => trim($rowData['phone'] ?? ''),
                'email'            => trim($rowData['email'] ?? ''),
                'website'          => trim($rowData['website'] ?? ''),
                'latitude'         => !empty($rowData['latitude']) ? (float)$rowData['latitude'] : null,
                'longitude'        => !empty($rowData['longitude']) ? (float)$rowData['longitude'] : null,
                'google_place_id'  => trim($rowData['google_place_id'] ?? ''),
                'marker_color'     => trim($rowData['marker_color'] ?? ''),
                'css_class'        => trim($rowData['css_class'] ?? ''),
                'sort_order'       => (int)($rowData['sort_order'] ?? 0),
                'is_active'        => (int)($rowData['is_active'] ?? 1),
                'tags'             => $rowData['tags'] ?? '[]',
            ];

            // Parse opening hours from flat columns
            $hours = [];
            for ($d = 0; $d < 7; $d++) {
                $prefix = $dayNames[$d];
                $hours[$d] = [
                    'is_open'      => (int)($rowData[$prefix . '_is_open'] ?? 0),
                    'open_time_1'  => $rowData[$prefix . '_open_1'] ?? null,
                    'close_time_1' => $rowData[$prefix . '_close_1'] ?? null,
                    'open_time_2'  => $rowData[$prefix . '_open_2'] ?? null,
                    'close_time_2' => $rowData[$prefix . '_close_2'] ?? null,
                ];
            }

            try {
                $this->branchService->saveFull($branchData, $hours);
                $imported++;
            } catch (\Throwable $e) {
                $errors[] = 'Zeile ' . ($lineNum + 2) . ' (' . $name . '): ' . $e->getMessage();
            }
        }

        return [
            'success'  => $imported > 0,
            'flag'     => $imported > 0,
            'message'  => $imported . ' Filialen erfolgreich importiert.',
            'imported' => $imported,
            'errors'   => $errors,
        ];
    }

    /**
     * Parse a CSV string into an array of rows.
     *
     * @return array<int, array<int, string>>
     */
    private function parseCsvString(string $content, string $delimiter): array
    {
        $lines = [];
        $stream = fopen('php://temp', 'r+');
        fwrite($stream, $content);
        rewind($stream);

        while (($row = fgetcsv($stream, 0, $delimiter, '"', '\\')) !== false) {
            $lines[] = $row;
        }

        fclose($stream);

        return $lines;
    }

    /**
     * Import branches from JSON content.
     */
    private function importFromJson(string $content): array
    {
        $errors = [];
        $imported = 0;

        $data = json_decode($content, true);
        if (!is_array($data)) {
            return ['success' => false, 'errors' => ['Ungültiges JSON-Format.']];
        }

        // If it's a single object, wrap in array
        if (isset($data['name'])) {
            $data = [$data];
        }

        foreach ($data as $index => $entry) {
            $name = trim($entry['name'] ?? '');
            if (empty($name)) {
                $errors[] = 'Eintrag ' . ($index + 1) . ': Name fehlt, übersprungen.';
                continue;
            }

            $branchData = [
                'name'             => $name,
                'description'      => $entry['description'] ?? '',
                'description_html' => $entry['description_html'] ?? '',
                'street'           => trim($entry['street'] ?? ''),
                'zip'              => trim($entry['zip'] ?? ''),
                'city'             => trim($entry['city'] ?? ''),
                'country'          => trim($entry['country'] ?? 'DE'),
                'phone'            => trim($entry['phone'] ?? ''),
                'email'            => trim($entry['email'] ?? ''),
                'website'          => trim($entry['website'] ?? ''),
                'latitude'         => isset($entry['latitude']) ? (float)$entry['latitude'] : null,
                'longitude'        => isset($entry['longitude']) ? (float)$entry['longitude'] : null,
                'google_place_id'  => trim($entry['google_place_id'] ?? ''),
                'marker_color'     => trim($entry['marker_color'] ?? ''),
                'css_class'        => trim($entry['css_class'] ?? ''),
                'sort_order'       => (int)($entry['sort_order'] ?? 0),
                'is_active'        => (int)($entry['is_active'] ?? 1),
                'tags'             => isset($entry['tags']) ? (is_array($entry['tags']) ? json_encode($entry['tags'], JSON_UNESCAPED_UNICODE) : $entry['tags']) : '[]',
            ];

            // Parse hours (nested array format)
            $hours = [];
            if (!empty($entry['hours']) && is_array($entry['hours'])) {
                foreach ($entry['hours'] as $h) {
                    $h = (array)$h;
                    $dayOfWeek = (int)($h['day_of_week'] ?? -1);
                    if ($dayOfWeek >= 0 && $dayOfWeek <= 6) {
                        $hours[$dayOfWeek] = [
                            'is_open'      => (int)($h['is_open'] ?? 0),
                            'open_time_1'  => $h['open_time_1'] ?? null,
                            'close_time_1' => $h['close_time_1'] ?? null,
                            'open_time_2'  => $h['open_time_2'] ?? null,
                            'close_time_2' => $h['close_time_2'] ?? null,
                        ];
                    }
                }
            }

            // Parse special days (nested array format)
            $specialDays = [];
            if (!empty($entry['special_days']) && is_array($entry['special_days'])) {
                foreach ($entry['special_days'] as $sd) {
                    $sd = (array)$sd;
                    if (!empty($sd['date'])) {
                        $specialDays[] = [
                            'date'       => $sd['date'],
                            'is_closed'  => (int)($sd['is_closed'] ?? 0),
                            'open_time'  => $sd['open_time'] ?? null,
                            'close_time' => $sd['close_time'] ?? null,
                            'note'       => $sd['note'] ?? '',
                        ];
                    }
                }
            }

            try {
                $this->branchService->saveFull($branchData, $hours, $specialDays);
                $imported++;
            } catch (\Throwable $e) {
                $errors[] = 'Eintrag ' . ($index + 1) . ' (' . $name . '): ' . $e->getMessage();
            }
        }

        return [
            'success'  => $imported > 0,
            'flag'     => $imported > 0,
            'message'  => $imported . ' Filialen erfolgreich importiert.',
            'imported' => $imported,
            'errors'   => $errors,
        ];
    }

    /**
     * Import branches from XML content.
     */
    private function importFromXml(string $content): array
    {
        $errors = [];
        $imported = 0;

        libxml_use_internal_errors(true);
        $xml = simplexml_load_string($content);
        if ($xml === false) {
            $xmlErrors = libxml_get_errors();
            libxml_clear_errors();
            $errorMsg = !empty($xmlErrors) ? $xmlErrors[0]->message : 'Unbekannter Fehler';
            return ['success' => false, 'errors' => ['Ungültiges XML: ' . trim($errorMsg)]];
        }

        $branchNodes = $xml->branch ?? [];

        foreach ($branchNodes as $index => $node) {
            $name = trim((string)($node->name ?? ''));
            if (empty($name)) {
                $errors[] = 'Eintrag ' . ($index + 1) . ': Name fehlt, übersprungen.';
                continue;
            }

            $branchData = [
                'name'             => $name,
                'description'      => (string)($node->description ?? ''),
                'description_html' => (string)($node->description_html ?? ''),
                'street'           => trim((string)($node->street ?? '')),
                'zip'              => trim((string)($node->zip ?? '')),
                'city'             => trim((string)($node->city ?? '')),
                'country'          => trim((string)($node->country ?? 'DE')),
                'phone'            => trim((string)($node->phone ?? '')),
                'email'            => trim((string)($node->email ?? '')),
                'website'          => trim((string)($node->website ?? '')),
                'latitude'         => !empty((string)$node->latitude) ? (float)(string)$node->latitude : null,
                'longitude'        => !empty((string)$node->longitude) ? (float)(string)$node->longitude : null,
                'google_place_id'  => trim((string)($node->google_place_id ?? '')),
                'marker_color'     => trim((string)($node->marker_color ?? '')),
                'css_class'        => trim((string)($node->css_class ?? '')),
                'sort_order'       => (int)(string)($node->sort_order ?? '0'),
                'is_active'        => (int)(string)($node->is_active ?? '1'),
                'tags'             => (string)($node->tags ?? '[]'),
            ];

            // Parse opening hours
            $hours = [];
            if (isset($node->opening_hours->day)) {
                foreach ($node->opening_hours->day as $dayNode) {
                    $dayOfWeek = (int)(string)($dayNode->day_of_week ?? '-1');
                    if ($dayOfWeek >= 0 && $dayOfWeek <= 6) {
                        $hours[$dayOfWeek] = [
                            'is_open'      => (int)(string)($dayNode->is_open ?? '0'),
                            'open_time_1'  => (string)($dayNode->open_time_1 ?? ''),
                            'close_time_1' => (string)($dayNode->close_time_1 ?? ''),
                            'open_time_2'  => (string)($dayNode->open_time_2 ?? ''),
                            'close_time_2' => (string)($dayNode->close_time_2 ?? ''),
                        ];
                    }
                }
            }

            // Parse special days
            $specialDays = [];
            if (isset($node->special_days->special_day)) {
                foreach ($node->special_days->special_day as $sdNode) {
                    $date = (string)($sdNode->date ?? '');
                    if (!empty($date)) {
                        $specialDays[] = [
                            'date'       => $date,
                            'is_closed'  => (int)(string)($sdNode->is_closed ?? '0'),
                            'open_time'  => (string)($sdNode->open_time ?? ''),
                            'close_time' => (string)($sdNode->close_time ?? ''),
                            'note'       => (string)($sdNode->note ?? ''),
                        ];
                    }
                }
            }

            try {
                $this->branchService->saveFull($branchData, $hours, $specialDays);
                $imported++;
            } catch (\Throwable $e) {
                $errors[] = 'Eintrag ' . ($index + 1) . ' (' . $name . '): ' . $e->getMessage();
            }
        }

        return [
            'success'  => $imported > 0,
            'flag'     => $imported > 0,
            'message'  => $imported . ' Filialen erfolgreich importiert.',
            'imported' => $imported,
            'errors'   => $errors,
        ];
    }

    // =========================================================================
    // Tag Actions
    // =========================================================================

    /**
     * Save tags for a branch (comma-separated string stored as JSON).
     */
    private function saveTags(): array
    {
        $branchId = (int)($_POST['branch_id'] ?? 0);
        if ($branchId <= 0) {
            return ['success' => false, 'errors' => ['Ungültige Filial-ID.']];
        }

        $tagsRaw = trim($_POST['tags'] ?? '');
        $tags = [];
        if ($tagsRaw !== '') {
            $tags = array_map('trim', explode(',', $tagsRaw));
            $tags = array_values(array_filter($tags, static fn(string $t): bool => $t !== ''));
        }

        $tagsJson = json_encode($tags, JSON_UNESCAPED_UNICODE);

        $this->db->queryPrepared(
            'UPDATE `bbf_filialfinder_branch` SET `tags` = :tags WHERE `id` = :id',
            ['tags' => $tagsJson, 'id' => $branchId]
        );

        return [
            'success' => true,
            'flag'    => true,
            'message' => 'Tags gespeichert.',
            'tags'    => $tags,
        ];
    }

    /**
     * Delete a single tag from a branch.
     */
    private function deleteTag(): array
    {
        $branchId = (int)($_POST['branch_id'] ?? 0);
        $tagToDelete = trim($_POST['tag'] ?? '');

        if ($branchId <= 0) {
            return ['success' => false, 'errors' => ['Ungültige Filial-ID.']];
        }

        if ($tagToDelete === '') {
            return ['success' => false, 'errors' => ['Kein Tag angegeben.']];
        }

        $branch = $this->branchModel->getById($branchId);
        if (!$branch) {
            return ['success' => false, 'errors' => ['Filiale nicht gefunden.']];
        }

        $tags = json_decode($branch->tags ?? '[]', true);
        if (!is_array($tags)) {
            $tags = [];
        }

        $tags = array_values(array_filter($tags, static fn(string $t): bool => $t !== $tagToDelete));
        $tagsJson = json_encode($tags, JSON_UNESCAPED_UNICODE);

        $this->db->queryPrepared(
            'UPDATE `bbf_filialfinder_branch` SET `tags` = :tags WHERE `id` = :id',
            ['tags' => $tagsJson, 'id' => $branchId]
        );

        return [
            'success' => true,
            'flag'    => true,
            'message' => 'Tag gelöscht.',
            'tags'    => $tags,
        ];
    }

    /**
     * Get all unique tags across all branches (for autocomplete).
     */
    private function getTags(): array
    {
        $branches = $this->branchModel->getAll();
        $allTags = [];

        foreach ($branches as $branch) {
            $tags = json_decode($branch->tags ?? '[]', true);
            if (is_array($tags)) {
                foreach ($tags as $tag) {
                    $tag = trim((string)$tag);
                    if ($tag !== '' && !in_array($tag, $allTags, true)) {
                        $allTags[] = $tag;
                    }
                }
            }
        }

        sort($allTags, SORT_LOCALE_STRING);

        return [
            'success' => true,
            'tags'    => $allTags,
        ];
    }

    // =========================================================================
    // Helper Methods
    // =========================================================================

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
