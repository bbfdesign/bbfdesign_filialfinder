/**
 * BBF Filialfinder - Leaflet / OpenStreetMap Integration
 * Vanilla ES6+, no jQuery dependencies
 */
(function () {
    'use strict';

    var EVENT_MAP_READY     = 'bbf-filialfinder:map-ready';
    var EVENT_BRANCH_SELECT = 'bbf-filialfinder:branch-select';

    var DEFAULT_TILE_URL = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    var DEFAULT_TILE_ATTRIBUTION = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';

    /* =============================================
       Leaflet Maps Handler
       ============================================= */

    function LeafletHandler(container) {
        this.container = container;
        this.mapEl = container.querySelector('.bbf-filialfinder-map');
        this.map = null;
        this.markers = {};
        this.markerClusterGroup = null;
        this.coreInstance = null;
        this.settings = {};

        this.init();
    }

    LeafletHandler.prototype.init = function () {
        if (!this.mapEl) return;

        this.coreInstance = window.BbfFilialfinder
            ? window.BbfFilialfinder.getInstance(this.container)
            : null;

        this.settings = this.coreInstance ? this.coreInstance.settings : {};
        var mapSettings = this.settings.map || {};

        // Check consent
        if (mapSettings.requireConsent && !this.hasConsent()) {
            this.showConsentPlaceholder();
            return;
        }

        this.loadMap();
    };

    /* ----- Consent ----- */

    LeafletHandler.prototype.hasConsent = function () {
        return localStorage.getItem('bbf_maps_consent') === '1';
    };

    LeafletHandler.prototype.showConsentPlaceholder = function () {
        var self = this;
        var placeholder = document.createElement('div');
        placeholder.className = 'bbf-filialfinder-consent-placeholder';
        placeholder.innerHTML =
            '<p>Zur Anzeige der Karte wird OpenStreetMap verwendet. ' +
            'Mit dem Laden der Karte akzeptieren Sie die Datenschutzbestimmungen.</p>' +
            '<button type="button">Karte laden</button>';

        placeholder.querySelector('button').addEventListener('click', function () {
            localStorage.setItem('bbf_maps_consent', '1');
            placeholder.remove();
            self.loadMap();
        });

        this.mapEl.appendChild(placeholder);
    };

    /* ----- Map Initialization ----- */

    LeafletHandler.prototype.loadMap = function () {
        if (typeof L === 'undefined') {
            console.warn('[BbfFilialfinder] Leaflet library not loaded.');
            return;
        }

        var mapSettings = this.settings.map || {};
        var centerLat = parseFloat(mapSettings.centerLat) || 51.1657;
        var centerLng = parseFloat(mapSettings.centerLng) || 10.4515;
        var zoom = parseInt(mapSettings.zoom, 10) || 6;

        this.map = L.map(this.mapEl, {
            center: [centerLat, centerLng],
            zoom: zoom,
            zoomControl: true,
            attributionControl: true
        });

        // Tile layer
        var tileUrl = mapSettings.tileServer || DEFAULT_TILE_URL;
        var tileAttribution = mapSettings.tileAttribution || DEFAULT_TILE_ATTRIBUTION;

        L.tileLayer(tileUrl, {
            attribution: tileAttribution,
            maxZoom: 19
        }).addTo(this.map);

        this.addMarkers();
        this.addFullscreenButton();
        this.bindEvents();
        this.fitBounds();

        // Dispatch map ready event
        this.container.dispatchEvent(new CustomEvent(EVENT_MAP_READY, {
            bubbles: true,
            detail: { provider: 'leaflet', map: this.map }
        }));
    };

    /* ----- Markers ----- */

    LeafletHandler.prototype.addMarkers = function () {
        var self = this;
        var branches = this.coreInstance ? this.coreInstance.branches : [];
        var mapSettings = this.settings.map || {};
        var useClustering = mapSettings.enableClustering && typeof L.markerClusterGroup === 'function';

        if (useClustering) {
            this.markerClusterGroup = L.markerClusterGroup({
                maxClusterRadius: mapSettings.clusterGridSize || 60,
                disableClusteringAtZoom: mapSettings.clusterMaxZoom || 15
            });
        }

        branches.forEach(function (branch) {
            if (!branch.lat || !branch.lng) return;

            var lat = parseFloat(branch.lat);
            var lng = parseFloat(branch.lng);
            var markerOptions = {};

            // Custom marker icon
            var iconUrl = branch.markerIcon || mapSettings.markerIcon;
            if (iconUrl) {
                markerOptions.icon = L.icon({
                    iconUrl: iconUrl,
                    iconSize: [
                        mapSettings.markerWidth || 32,
                        mapSettings.markerHeight || 40
                    ],
                    iconAnchor: [
                        (mapSettings.markerWidth || 32) / 2,
                        mapSettings.markerHeight || 40
                    ],
                    popupAnchor: [0, -(mapSettings.markerHeight || 40)]
                });
            }

            var marker = L.marker([lat, lng], markerOptions);

            // Popup
            var popupContent = self.buildPopupContent(branch);
            marker.bindPopup(popupContent, { maxWidth: 280 });

            marker.on('click', function () {
                if (self.coreInstance) {
                    self.coreInstance.selectBranch(branch.id);
                }
            });

            self.markers[branch.id] = marker;

            if (useClustering) {
                self.markerClusterGroup.addLayer(marker);
            } else {
                marker.addTo(self.map);
            }
        });

        if (useClustering && this.markerClusterGroup) {
            this.map.addLayer(this.markerClusterGroup);
        }
    };

    /* ----- Popup Content ----- */

    LeafletHandler.prototype.buildPopupContent = function (branch) {
        var statusHtml = this.buildStatusHtml(branch);
        var directionsUrl = this.getDirectionsUrl(branch);

        return '<div class="bbf-filialfinder-info-window">' +
                '<div class="bbf-filialfinder-card__name">' + escapeHtml(branch.name || '') + '</div>' +
                '<div class="bbf-filialfinder-card__address">' +
                    escapeHtml(branch.street || '') + '<br>' +
                    escapeHtml(branch.zip || '') + ' ' + escapeHtml(branch.city || '') +
                '</div>' +
                (branch.phone
                    ? '<a class="bbf-filialfinder-card__phone" href="tel:' + escapeHtml(branch.phone) + '">' + escapeHtml(branch.phone) + '</a>'
                    : '') +
                (branch.email
                    ? '<a class="bbf-filialfinder-card__email" href="mailto:' + escapeHtml(branch.email) + '">' + escapeHtml(branch.email) + '</a>'
                    : '') +
                statusHtml +
                '<a class="bbf-filialfinder-directions" href="' + directionsUrl + '" target="_blank" rel="noopener noreferrer">' +
                    'Route planen' +
                '</a>' +
            '</div>';
    };

    LeafletHandler.prototype.buildStatusHtml = function (branch) {
        if (!window.BbfFilialfinder || !this.coreInstance) return '';
        var statusData = this.coreInstance.statusData[branch.id];
        if (!statusData) return '';

        var result = window.BbfFilialfinder.getOpeningStatus(branch.id, statusData);
        return '<div class="bbf-filialfinder-status bbf-filialfinder-status--' + result.cssClass + '">' +
                   '<span class="bbf-filialfinder-status__dot"></span>' +
                   '<span class="bbf-filialfinder-status__text">' + escapeHtml(result.text) + '</span>' +
               '</div>';
    };

    LeafletHandler.prototype.getDirectionsUrl = function (branch) {
        var lat = parseFloat(branch.lat) || 0;
        var lng = parseFloat(branch.lng) || 0;
        return 'https://www.openstreetmap.org/directions?route=;' + lat + ',' + lng;
    };

    /* ----- Fit Bounds ----- */

    LeafletHandler.prototype.fitBounds = function () {
        var latLngs = [];

        for (var id in this.markers) {
            if (this.markers.hasOwnProperty(id)) {
                latLngs.push(this.markers[id].getLatLng());
            }
        }

        if (latLngs.length > 0) {
            var bounds = L.latLngBounds(latLngs);
            this.map.fitBounds(bounds, { padding: [30, 30], maxZoom: 15 });
        }
    };

    /* ----- Event Bindings ----- */

    LeafletHandler.prototype.bindEvents = function () {
        var self = this;

        this.container.addEventListener(EVENT_BRANCH_SELECT, function (e) {
            var branchId = e.detail.branchId;
            self.flyToMarker(branchId);
        });
    };

    LeafletHandler.prototype.flyToMarker = function (branchId) {
        var marker = this.markers[branchId];
        if (!marker) return;

        var latLng = marker.getLatLng();
        this.map.flyTo(latLng, 15, { duration: 0.8 });

        // Open popup
        marker.openPopup();
    };

    /* ----- Fullscreen Button ----- */

    LeafletHandler.prototype.addFullscreenButton = function () {
        var self = this;
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'bbf-filialfinder-fullscreen-btn';
        btn.title = 'Vollbild';
        btn.innerHTML = '<svg viewBox="0 0 24 24"><path d="M7 14H5v5h5v-2H7v-3zm-2-4h2V7h3V5H5v5zm12 7h-3v2h5v-5h-2v3zM14 5v2h3v3h2V5h-5z"/></svg>';

        btn.addEventListener('click', function () {
            if (!document.fullscreenElement) {
                self.mapEl.requestFullscreen().catch(function () {});
            } else {
                document.exitFullscreen();
            }
        });

        this.mapEl.style.position = 'relative';
        this.mapEl.appendChild(btn);
    };

    /* =============================================
       HTML Escaping
       ============================================= */

    function escapeHtml(str) {
        var div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    /* =============================================
       Auto-Initialize
       ============================================= */

    function initLeaflet() {
        var containers = document.querySelectorAll('[data-filialfinder][data-map-provider="leaflet"]');
        containers.forEach(function (container) {
            if (container._bbfLeafletMap) return;
            var handler = new LeafletHandler(container);
            container._bbfLeafletMap = handler;
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () {
            setTimeout(initLeaflet, 50);
        });
    } else {
        setTimeout(initLeaflet, 50);
    }

    /* =============================================
       Public API Extension
       ============================================= */

    if (window.BbfFilialfinder) {
        window.BbfFilialfinder.leaflet = {
            init: initLeaflet,
            getInstance: function (container) {
                return container._bbfLeafletMap || null;
            }
        };
    }

})();
