/**
 * BBF Filialfinder - Google Maps Integration
 * Vanilla ES6+, no jQuery dependencies
 */
(function () {
    'use strict';

    var EVENT_MAP_READY     = 'bbf-filialfinder:map-ready';
    var EVENT_BRANCH_SELECT = 'bbf-filialfinder:branch-select';

    /* =============================================
       Google Maps Handler
       ============================================= */

    function GoogleMapsHandler(container) {
        this.container = container;
        this.mapEl = container.querySelector('.bbf-filialfinder-map');
        this.map = null;
        this.markers = {};
        this.infoWindow = null;
        this.markerClusterer = null;
        this.coreInstance = null;
        this.consentGiven = false;
        this.settings = {};

        this.init();
    }

    GoogleMapsHandler.prototype.init = function () {
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

    GoogleMapsHandler.prototype.hasConsent = function () {
        // Check cookie or localStorage for consent
        return localStorage.getItem('bbf_maps_consent') === '1';
    };

    GoogleMapsHandler.prototype.showConsentPlaceholder = function () {
        var self = this;
        var placeholder = document.createElement('div');
        placeholder.className = 'bbf-filialfinder-consent-placeholder';
        placeholder.innerHTML =
            '<p>Zur Anzeige der Karte wird Google Maps verwendet. ' +
            'Mit dem Laden der Karte akzeptieren Sie die Datenschutzbestimmungen von Google.</p>' +
            '<button type="button">Karte laden</button>';

        placeholder.querySelector('button').addEventListener('click', function () {
            localStorage.setItem('bbf_maps_consent', '1');
            self.consentGiven = true;
            placeholder.remove();
            self.loadMap();
        });

        this.mapEl.appendChild(placeholder);
    };

    /* ----- Map Initialization ----- */

    GoogleMapsHandler.prototype.loadMap = function () {
        if (typeof google === 'undefined' || !google.maps) {
            console.warn('[BbfFilialfinder] Google Maps API not loaded.');
            return;
        }

        var mapSettings = this.settings.map || {};
        var center = {
            lat: parseFloat(mapSettings.centerLat) || 51.1657,
            lng: parseFloat(mapSettings.centerLng) || 10.4515
        };

        var mapOptions = {
            zoom: parseInt(mapSettings.zoom, 10) || 6,
            center: center,
            mapTypeId: mapSettings.mapType || 'roadmap',
            disableDefaultUI: false,
            zoomControl: true,
            mapTypeControl: false,
            streetViewControl: false,
            fullscreenControl: false // We add our own
        };

        // Apply custom map styles if provided
        if (mapSettings.styles && Array.isArray(mapSettings.styles)) {
            mapOptions.styles = mapSettings.styles;
        }

        this.map = new google.maps.Map(this.mapEl, mapOptions);
        this.infoWindow = new google.maps.InfoWindow();

        this.addMarkers();
        this.addFullscreenButton();
        this.bindEvents();
        this.fitBounds();

        // Dispatch map ready event
        this.container.dispatchEvent(new CustomEvent(EVENT_MAP_READY, {
            bubbles: true,
            detail: { provider: 'google', map: this.map }
        }));
    };

    /* ----- Markers ----- */

    GoogleMapsHandler.prototype.addMarkers = function () {
        var self = this;
        var branches = this.coreInstance ? this.coreInstance.branches : [];
        var mapSettings = this.settings.map || {};
        var markerArray = [];

        branches.forEach(function (branch) {
            if (!branch.lat || !branch.lng) return;

            var markerOptions = {
                position: {
                    lat: parseFloat(branch.lat),
                    lng: parseFloat(branch.lng)
                },
                map: self.map,
                title: branch.name || ''
            };

            // Custom marker icon
            if (branch.markerIcon || mapSettings.markerIcon) {
                markerOptions.icon = {
                    url: branch.markerIcon || mapSettings.markerIcon,
                    scaledSize: new google.maps.Size(
                        mapSettings.markerWidth || 32,
                        mapSettings.markerHeight || 40
                    )
                };
            }

            var marker = new google.maps.Marker(markerOptions);

            marker.addListener('click', function () {
                self.openInfoWindow(branch, marker);
                if (self.coreInstance) {
                    self.coreInstance.selectBranch(branch.id);
                }
            });

            self.markers[branch.id] = marker;
            markerArray.push(marker);
        });

        // MarkerClusterer
        if (mapSettings.enableClustering && typeof MarkerClusterer !== 'undefined') {
            this.markerClusterer = new MarkerClusterer(this.map, markerArray, {
                imagePath: mapSettings.clusterImagePath || 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m',
                maxZoom: mapSettings.clusterMaxZoom || 14,
                gridSize: mapSettings.clusterGridSize || 60
            });
        }
    };

    /* ----- Info Window ----- */

    GoogleMapsHandler.prototype.openInfoWindow = function (branch, marker) {
        var statusHtml = this.buildStatusHtml(branch);
        var directionsUrl = this.getDirectionsUrl(branch);

        var html =
            '<div class="bbf-filialfinder-info-window">' +
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

        this.infoWindow.setContent(html);
        this.infoWindow.open(this.map, marker);
    };

    GoogleMapsHandler.prototype.buildStatusHtml = function (branch) {
        if (!window.BbfFilialfinder || !this.coreInstance) return '';
        var statusData = this.coreInstance.statusData[branch.id];
        if (!statusData) return '';

        var result = window.BbfFilialfinder.getOpeningStatus(branch.id, statusData);
        return '<div class="bbf-filialfinder-status bbf-filialfinder-status--' + result.cssClass + '">' +
                   '<span class="bbf-filialfinder-status__dot"></span>' +
                   '<span class="bbf-filialfinder-status__text">' + escapeHtml(result.text) + '</span>' +
               '</div>';
    };

    GoogleMapsHandler.prototype.getDirectionsUrl = function (branch) {
        var destination = encodeURIComponent(
            (branch.street || '') + ', ' +
            (branch.zip || '') + ' ' +
            (branch.city || '')
        );
        return 'https://www.google.com/maps/dir/?api=1&destination=' + destination;
    };

    /* ----- Fit Bounds ----- */

    GoogleMapsHandler.prototype.fitBounds = function () {
        var bounds = new google.maps.LatLngBounds();
        var hasMarkers = false;

        for (var id in this.markers) {
            if (this.markers.hasOwnProperty(id)) {
                bounds.extend(this.markers[id].getPosition());
                hasMarkers = true;
            }
        }

        if (hasMarkers) {
            this.map.fitBounds(bounds);
            // Prevent over-zoom on single marker
            var self = this;
            google.maps.event.addListenerOnce(this.map, 'bounds_changed', function () {
                if (self.map.getZoom() > 15) {
                    self.map.setZoom(15);
                }
            });
        }
    };

    /* ----- Event Bindings ----- */

    GoogleMapsHandler.prototype.bindEvents = function () {
        var self = this;

        // Listen for branch selection from cards
        this.container.addEventListener(EVENT_BRANCH_SELECT, function (e) {
            var branchId = e.detail.branchId;
            self.zoomToMarker(branchId);
        });
    };

    GoogleMapsHandler.prototype.zoomToMarker = function (branchId) {
        var marker = this.markers[branchId];
        if (!marker) return;

        this.map.setZoom(15);
        this.map.panTo(marker.getPosition());

        // Open info window
        var branch = this.coreInstance ? this.coreInstance.getBranchById(branchId) : null;
        if (branch) {
            this.openInfoWindow(branch, marker);
        }
    };

    /* ----- Fullscreen Button ----- */

    GoogleMapsHandler.prototype.addFullscreenButton = function () {
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

    function initGoogle() {
        var containers = document.querySelectorAll('[data-filialfinder][data-map-provider="google"]');
        containers.forEach(function (container) {
            if (container._bbfGoogleMap) return;
            var handler = new GoogleMapsHandler(container);
            container._bbfGoogleMap = handler;
        });
    }

    // Initialize when Google Maps API is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () {
            // Delay slightly to ensure core is initialized first
            setTimeout(initGoogle, 50);
        });
    } else {
        setTimeout(initGoogle, 50);
    }

    /* =============================================
       Public API Extension
       ============================================= */

    if (window.BbfFilialfinder) {
        window.BbfFilialfinder.google = {
            init: initGoogle,
            getInstance: function (container) {
                return container._bbfGoogleMap || null;
            }
        };
    }

})();
