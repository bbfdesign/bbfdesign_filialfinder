/**
 * BBF Filialfinder - Geolocation Module
 * Vanilla ES6+, no jQuery dependencies
 */
(function () {
    'use strict';

    /* =============================================
       Geolocation Handler
       ============================================= */

    function GeoHandler() {
        this.userLat = null;
        this.userLng = null;
        this.hasLocation = false;
    }

    /**
     * Request the user's current location via the browser Geolocation API.
     *
     * @param {object} [options] - PositionOptions (enableHighAccuracy, timeout, maximumAge)
     * @returns {Promise<{lat: number, lng: number}>}
     */
    GeoHandler.prototype.requestLocation = function (options) {
        var self = this;
        var opts = Object.assign({
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 300000 // 5 min cache
        }, options || {});

        return new Promise(function (resolve, reject) {
            if (!navigator.geolocation) {
                reject(new Error('Geolocation wird von Ihrem Browser nicht unterstuetzt.'));
                return;
            }

            navigator.geolocation.getCurrentPosition(
                function (position) {
                    self.userLat = position.coords.latitude;
                    self.userLng = position.coords.longitude;
                    self.hasLocation = true;
                    resolve({ lat: self.userLat, lng: self.userLng });
                },
                function (err) {
                    var message;
                    switch (err.code) {
                        case err.PERMISSION_DENIED:
                            message = 'Standortzugriff wurde verweigert.';
                            break;
                        case err.POSITION_UNAVAILABLE:
                            message = 'Standort konnte nicht ermittelt werden.';
                            break;
                        case err.TIMEOUT:
                            message = 'Standortabfrage hat zu lange gedauert.';
                            break;
                        default:
                            message = 'Unbekannter Fehler bei der Standortermittlung.';
                    }
                    reject(new Error(message));
                },
                opts
            );
        });
    };

    /**
     * Calculate distances from the user's location to all branches of a given instance.
     *
     * @param {object} filialfinderInstance - A BbfFilialfinder core instance
     * @returns {Array} Sorted branches with distance property
     */
    GeoHandler.prototype.calculateDistances = function (filialfinderInstance) {
        if (!this.hasLocation || !filialfinderInstance) return [];

        filialfinderInstance.calculateDistances(this.userLat, this.userLng);
        return filialfinderInstance.branches.slice();
    };

    /**
     * Sort branches by distance and update the DOM.
     *
     * @param {object} filialfinderInstance
     */
    GeoHandler.prototype.sortByDistance = function (filialfinderInstance) {
        if (!this.hasLocation || !filialfinderInstance) return;

        filialfinderInstance.calculateDistances(this.userLat, this.userLng);
        filialfinderInstance.sortByDistance();
    };

    /**
     * Update distance badges on all branch cards.
     *
     * @param {object} filialfinderInstance
     */
    GeoHandler.prototype.updateDistanceDisplay = function (filialfinderInstance) {
        if (!filialfinderInstance) return;
        filialfinderInstance.updateDistanceDisplay();
    };

    /**
     * Filter branches within a given radius (in km).
     *
     * @param {object} filialfinderInstance
     * @param {number} radiusKm - Maximum distance in kilometers
     * @returns {Array} Branches within the radius
     */
    GeoHandler.prototype.radiusFilter = function (filialfinderInstance, radiusKm) {
        if (!this.hasLocation || !filialfinderInstance) return [];

        var container = filialfinderInstance.container;
        var branches = filialfinderInstance.branches;
        var noResults = container.querySelector('.bbf-filialfinder-no-results');
        var visibleCount = 0;

        branches.forEach(function (branch) {
            var card = container.querySelector('[data-branch-id="' + branch.id + '"]');
            if (!card) return;

            var withinRadius = branch.distance !== undefined &&
                               branch.distance !== Infinity &&
                               branch.distance <= radiusKm;

            card.style.display = withinRadius ? '' : 'none';
            if (withinRadius) visibleCount++;
        });

        if (noResults) {
            noResults.style.display = visibleCount === 0 ? '' : 'none';
        }

        return branches.filter(function (b) {
            return b.distance !== undefined && b.distance !== Infinity && b.distance <= radiusKm;
        });
    };

    /**
     * Reset radius filter - show all branches again.
     *
     * @param {object} filialfinderInstance
     */
    GeoHandler.prototype.resetFilter = function (filialfinderInstance) {
        if (!filialfinderInstance) return;

        var container = filialfinderInstance.container;
        var cards = container.querySelectorAll('[data-branch-id]');
        cards.forEach(function (card) {
            card.style.display = '';
        });

        var noResults = container.querySelector('.bbf-filialfinder-no-results');
        if (noResults) {
            noResults.style.display = 'none';
        }
    };

    /**
     * Highlight the nearest branch by selecting it.
     *
     * @param {object} filialfinderInstance
     */
    GeoHandler.prototype.highlightNearest = function (filialfinderInstance) {
        if (!this.hasLocation || !filialfinderInstance) return;

        var branches = filialfinderInstance.branches;
        var nearest = null;
        var minDist = Infinity;

        for (var i = 0; i < branches.length; i++) {
            if (branches[i].distance !== undefined && branches[i].distance < minDist) {
                minDist = branches[i].distance;
                nearest = branches[i];
            }
        }

        if (nearest) {
            filialfinderInstance.selectBranch(nearest.id);
        }
    };

    /**
     * Convenience method: request location, calculate distances, sort, and highlight nearest.
     *
     * @param {object} filialfinderInstance
     * @returns {Promise<{lat: number, lng: number}>}
     */
    GeoHandler.prototype.locateAndSort = function (filialfinderInstance) {
        var self = this;
        return this.requestLocation().then(function (coords) {
            self.calculateDistances(filialfinderInstance);
            self.sortByDistance(filialfinderInstance);
            self.highlightNearest(filialfinderInstance);
            return coords;
        });
    };

    /* =============================================
       Haversine (reuse from core if available)
       ============================================= */

    function haversineDistance(lat1, lon1, lat2, lon2) {
        if (window.BbfFilialfinder && window.BbfFilialfinder.haversineDistance) {
            return window.BbfFilialfinder.haversineDistance(lat1, lon1, lat2, lon2);
        }
        var R = 6371;
        var dLat = toRad(lat2 - lat1);
        var dLon = toRad(lon2 - lon1);
        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
                Math.sin(dLon / 2) * Math.sin(dLon / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    function toRad(deg) {
        return deg * (Math.PI / 180);
    }

    /* =============================================
       Public API Extension
       ============================================= */

    var geoInstance = new GeoHandler();

    if (window.BbfFilialfinder) {
        window.BbfFilialfinder.geo = geoInstance;
    } else {
        // If core is not loaded yet, expose standalone
        window.BbfFilialfinderGeo = geoInstance;

        // Attach to core once available
        var checkCore = setInterval(function () {
            if (window.BbfFilialfinder) {
                window.BbfFilialfinder.geo = geoInstance;
                clearInterval(checkCore);
            }
        }, 100);

        // Stop checking after 10 seconds
        setTimeout(function () {
            clearInterval(checkCore);
        }, 10000);
    }

})();
