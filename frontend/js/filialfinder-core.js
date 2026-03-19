/**
 * BBF Filialfinder - Core Module
 * Vanilla ES6+, no jQuery dependencies
 */
(function () {
    'use strict';

    /* =============================================
       Constants
       ============================================= */
    var STATUS_OPEN     = 'open';
    var STATUS_CLOSED   = 'closed';
    var STATUS_CLOSING  = 'closing';
    var STATUS_OPENING  = 'opening';

    var EVENT_BRANCH_SELECT = 'bbf-filialfinder:branch-select';
    var EVENT_MAP_READY     = 'bbf-filialfinder:map-ready';

    var STATUS_UPDATE_INTERVAL = 60000; // 60 seconds

    /* =============================================
       Utility Helpers
       ============================================= */

    /**
     * Parse JSON from a data attribute, return fallback on failure.
     */
    function parseJsonAttr(el, attr, fallback) {
        var raw = el.getAttribute(attr);
        if (!raw) return fallback !== undefined ? fallback : null;
        try {
            return JSON.parse(raw);
        } catch (e) {
            console.warn('[BbfFilialfinder] Could not parse attribute ' + attr, e);
            return fallback !== undefined ? fallback : null;
        }
    }

    /**
     * Haversine distance in km between two lat/lng pairs.
     */
    function haversineDistance(lat1, lon1, lat2, lon2) {
        var R = 6371; // Earth radius in km
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

    /**
     * Format distance for display.
     */
    function formatDistance(km) {
        if (km < 1) {
            return Math.round(km * 1000) + ' m';
        }
        return km.toFixed(1) + ' km';
    }

    /**
     * Get current day name in lowercase (english).
     */
    function getCurrentDayName() {
        var days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
        return days[new Date().getDay()];
    }

    /**
     * Parse a time string "HH:MM" to minutes since midnight.
     */
    function timeToMinutes(timeStr) {
        if (!timeStr || typeof timeStr !== 'string') return null;
        var parts = timeStr.split(':');
        if (parts.length < 2) return null;
        return parseInt(parts[0], 10) * 60 + parseInt(parts[1], 10);
    }

    /**
     * Format date as YYYY-MM-DD.
     */
    function formatDateKey(date) {
        var y = date.getFullYear();
        var m = String(date.getMonth() + 1).padStart(2, '0');
        var d = String(date.getDate()).padStart(2, '0');
        return y + '-' + m + '-' + d;
    }

    /* =============================================
       Opening Status Calculation
       ============================================= */

    /**
     * Calculate the current opening status for a branch.
     *
     * @param {string|number} branchId - The branch identifier
     * @param {object} statusData - Opening hours data for the branch:
     *   {
     *     regular: {
     *       monday: [ { open: "09:00", close: "18:00" } ],
     *       ...
     *     },
     *     special: [
     *       { date: "2026-01-01", closed: true },
     *       { date: "2026-12-24", open: "09:00", close: "14:00" }
     *     ],
     *     closingSoonMinutes: 30,
     *     openingSoonMinutes: 30
     *   }
     *
     * @returns {{ status: string, text: string, cssClass: string }}
     */
    function getOpeningStatus(branchId, statusData) {
        if (!statusData) {
            return { status: STATUS_CLOSED, text: 'Geschlossen', cssClass: STATUS_CLOSED };
        }

        var now = new Date();
        var currentMinutes = now.getHours() * 60 + now.getMinutes();
        var todayKey = formatDateKey(now);
        var closingSoonMin = statusData.closingSoonMinutes || 30;
        var openingSoonMin = statusData.openingSoonMinutes || 30;

        // 1. Check special days first
        if (statusData.special && Array.isArray(statusData.special)) {
            for (var i = 0; i < statusData.special.length; i++) {
                var special = statusData.special[i];
                if (special.date === todayKey) {
                    if (special.closed) {
                        return { status: STATUS_CLOSED, text: 'Heute geschlossen', cssClass: STATUS_CLOSED };
                    }
                    // Special day with custom hours
                    return evaluateTimeSlot(
                        special.open, special.close, currentMinutes, closingSoonMin, openingSoonMin
                    );
                }
            }
        }

        // 2. Check regular hours
        var dayName = getCurrentDayName();
        if (!statusData.regular || !statusData.regular[dayName]) {
            return { status: STATUS_CLOSED, text: 'Heute geschlossen', cssClass: STATUS_CLOSED };
        }

        var slots = statusData.regular[dayName];
        if (!Array.isArray(slots) || slots.length === 0) {
            return { status: STATUS_CLOSED, text: 'Heute geschlossen', cssClass: STATUS_CLOSED };
        }

        // Check each time slot
        for (var j = 0; j < slots.length; j++) {
            var result = evaluateTimeSlot(
                slots[j].open, slots[j].close, currentMinutes, closingSoonMin, openingSoonMin
            );
            if (result.status === STATUS_OPEN || result.status === STATUS_CLOSING) {
                return result;
            }
            if (result.status === STATUS_OPENING) {
                return result;
            }
        }

        // Check if there is a future slot today (opening soon)
        for (var k = 0; k < slots.length; k++) {
            var openMin = timeToMinutes(slots[k].open);
            if (openMin !== null && openMin > currentMinutes && (openMin - currentMinutes) <= openingSoonMin) {
                return {
                    status: STATUS_OPENING,
                    text: 'Oeffnet in ' + (openMin - currentMinutes) + ' Min.',
                    cssClass: STATUS_OPENING
                };
            }
        }

        return { status: STATUS_CLOSED, text: 'Geschlossen', cssClass: STATUS_CLOSED };
    }

    /**
     * Evaluate a single time slot.
     */
    function evaluateTimeSlot(openStr, closeStr, currentMinutes, closingSoonMin, openingSoonMin) {
        var openMin = timeToMinutes(openStr);
        var closeMin = timeToMinutes(closeStr);

        if (openMin === null || closeMin === null) {
            return { status: STATUS_CLOSED, text: 'Geschlossen', cssClass: STATUS_CLOSED };
        }

        // Currently within open hours
        if (currentMinutes >= openMin && currentMinutes < closeMin) {
            var remainingMin = closeMin - currentMinutes;
            if (remainingMin <= closingSoonMin) {
                return {
                    status: STATUS_CLOSING,
                    text: 'Schliesst in ' + remainingMin + ' Min.',
                    cssClass: STATUS_CLOSING
                };
            }
            return {
                status: STATUS_OPEN,
                text: 'Geoeffnet bis ' + closeStr + ' Uhr',
                cssClass: STATUS_OPEN
            };
        }

        // Opening soon
        if (currentMinutes < openMin && (openMin - currentMinutes) <= openingSoonMin) {
            return {
                status: STATUS_OPENING,
                text: 'Oeffnet in ' + (openMin - currentMinutes) + ' Min.',
                cssClass: STATUS_OPENING
            };
        }

        return { status: STATUS_CLOSED, text: 'Geschlossen', cssClass: STATUS_CLOSED };
    }

    /* =============================================
       Core Filialfinder Class
       ============================================= */

    function Filialfinder(container) {
        this.container = container;
        this.branches = parseJsonAttr(container, 'data-branches', []);
        this.settings = parseJsonAttr(container, 'data-settings', {});
        this.statusData = parseJsonAttr(container, 'data-status', {});
        this.activeBranchId = null;
        this.userLocation = null;
        this.statusTimer = null;

        // DOM refs
        this.searchInput = container.querySelector('.bbf-filialfinder-search-input');
        this.searchBtn = container.querySelector('.bbf-filialfinder-search-btn');
        this.listEl = container.querySelector('.bbf-filialfinder-list');
        this.cards = [];

        this.init();
    }

    Filialfinder.prototype.init = function () {
        this.bindSearch();
        this.bindCards();
        this.bindAccordion();
        this.startStatusUpdater();
        this.updateAllStatuses();
    };

    /* ----- Search ----- */

    Filialfinder.prototype.bindSearch = function () {
        var self = this;
        if (!this.searchInput) return;

        var doSearch = function () {
            self.filterBranches(self.searchInput.value.trim());
        };

        this.searchInput.addEventListener('input', debounce(doSearch, 300));

        if (this.searchBtn) {
            this.searchBtn.addEventListener('click', function (e) {
                e.preventDefault();
                doSearch();
            });
        }

        this.searchInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                doSearch();
            }
        });
    };

    Filialfinder.prototype.filterBranches = function (query) {
        var cards = this.container.querySelectorAll('[data-branch-id]');
        var noResults = this.container.querySelector('.bbf-filialfinder-no-results');
        var visibleCount = 0;
        var q = query.toLowerCase();

        cards.forEach(function (card) {
            var name = (card.getAttribute('data-branch-name') || '').toLowerCase();
            var city = (card.getAttribute('data-branch-city') || '').toLowerCase();
            var zip = (card.getAttribute('data-branch-zip') || '').toLowerCase();

            var match = !q || name.indexOf(q) !== -1 || city.indexOf(q) !== -1 || zip.indexOf(q) !== -1;
            card.style.display = match ? '' : 'none';
            if (match) visibleCount++;
        });

        if (noResults) {
            noResults.style.display = visibleCount === 0 ? '' : 'none';
        }
    };

    /* ----- Cards / Branch Selection ----- */

    Filialfinder.prototype.bindCards = function () {
        var self = this;
        var cards = this.container.querySelectorAll('[data-branch-id]');

        cards.forEach(function (card) {
            card.addEventListener('click', function () {
                var branchId = card.getAttribute('data-branch-id');
                self.selectBranch(branchId);
            });
        });

        this.cards = cards;
    };

    Filialfinder.prototype.selectBranch = function (branchId) {
        // Deactivate previous
        this.cards.forEach(function (c) {
            c.classList.remove('bbf-filialfinder-card-active');
        });

        // Activate new
        var target = this.container.querySelector('[data-branch-id="' + branchId + '"]');
        if (target) {
            target.classList.add('bbf-filialfinder-card-active');
            target.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }

        this.activeBranchId = branchId;

        // Find branch data
        var branch = this.getBranchById(branchId);

        // Dispatch custom event
        this.container.dispatchEvent(new CustomEvent(EVENT_BRANCH_SELECT, {
            bubbles: true,
            detail: { branchId: branchId, branch: branch }
        }));
    };

    Filialfinder.prototype.getBranchById = function (id) {
        for (var i = 0; i < this.branches.length; i++) {
            if (String(this.branches[i].id) === String(id)) {
                return this.branches[i];
            }
        }
        return null;
    };

    /* ----- Accordion ----- */

    Filialfinder.prototype.bindAccordion = function () {
        var headers = this.container.querySelectorAll('.bbf-filialfinder-accordion__header');

        headers.forEach(function (header) {
            header.addEventListener('click', function () {
                var item = header.closest('.bbf-filialfinder-accordion__item');
                if (!item) return;

                var isOpen = item.classList.contains('bbf-filialfinder-accordion__item--open');

                // Close all siblings
                var siblings = item.parentElement.querySelectorAll('.bbf-filialfinder-accordion__item');
                siblings.forEach(function (sib) {
                    sib.classList.remove('bbf-filialfinder-accordion__item--open');
                });

                // Toggle current
                if (!isOpen) {
                    item.classList.add('bbf-filialfinder-accordion__item--open');
                }
            });
        });
    };

    /* ----- Status Updater ----- */

    Filialfinder.prototype.startStatusUpdater = function () {
        var self = this;
        this.statusTimer = setInterval(function () {
            self.updateAllStatuses();
        }, STATUS_UPDATE_INTERVAL);
    };

    Filialfinder.prototype.updateAllStatuses = function () {
        var self = this;
        var statusEls = this.container.querySelectorAll('[data-status-branch]');

        statusEls.forEach(function (el) {
            var branchId = el.getAttribute('data-status-branch');
            var branchStatus = self.statusData[branchId] || null;
            var result = getOpeningStatus(branchId, branchStatus);

            // Update CSS class
            el.className = 'bbf-filialfinder-status bbf-filialfinder-status--' + result.cssClass;

            // Update text
            var textEl = el.querySelector('.bbf-filialfinder-status__text');
            if (textEl) {
                textEl.textContent = result.text;
            }
        });
    };

    Filialfinder.prototype.destroy = function () {
        if (this.statusTimer) {
            clearInterval(this.statusTimer);
            this.statusTimer = null;
        }
    };

    /* ----- Distance / Sorting ----- */

    Filialfinder.prototype.calculateDistances = function (lat, lng) {
        this.userLocation = { lat: lat, lng: lng };

        for (var i = 0; i < this.branches.length; i++) {
            var b = this.branches[i];
            if (b.lat && b.lng) {
                b.distance = haversineDistance(lat, lng, parseFloat(b.lat), parseFloat(b.lng));
            } else {
                b.distance = Infinity;
            }
        }
    };

    Filialfinder.prototype.sortByDistance = function () {
        this.branches.sort(function (a, b) {
            return (a.distance || Infinity) - (b.distance || Infinity);
        });
        this.reorderCards();
    };

    Filialfinder.prototype.reorderCards = function () {
        if (!this.listEl) return;
        var self = this;

        this.branches.forEach(function (branch) {
            var card = self.container.querySelector('[data-branch-id="' + branch.id + '"]');
            if (card && card.parentNode === self.listEl) {
                self.listEl.appendChild(card);
            }
        });

        this.updateDistanceDisplay();
    };

    Filialfinder.prototype.updateDistanceDisplay = function () {
        var self = this;
        this.branches.forEach(function (branch) {
            if (branch.distance === undefined || branch.distance === Infinity) return;
            var card = self.container.querySelector('[data-branch-id="' + branch.id + '"]');
            if (!card) return;
            var distEl = card.querySelector('.bbf-filialfinder-card__distance');
            if (distEl) {
                distEl.textContent = formatDistance(branch.distance);
                distEl.style.display = '';
            }
        });
    };

    /* =============================================
       Debounce Utility
       ============================================= */
    function debounce(fn, delay) {
        var timer;
        return function () {
            var context = this;
            var args = arguments;
            clearTimeout(timer);
            timer = setTimeout(function () {
                fn.apply(context, args);
            }, delay);
        };
    }

    /* =============================================
       Auto-Initialization
       ============================================= */

    var instances = [];

    function initAll() {
        var containers = document.querySelectorAll('[data-filialfinder]');
        containers.forEach(function (container) {
            // Avoid double init
            if (container._bbfFilialfinder) return;
            var instance = new Filialfinder(container);
            container._bbfFilialfinder = instance;
            instances.push(instance);
        });
    }

    // Auto-init on DOMContentLoaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initAll);
    } else {
        initAll();
    }

    /* =============================================
       Public API
       ============================================= */
    window.BbfFilialfinder = {
        // Re-initialize (e.g. after dynamic content load)
        init: initAll,

        // Get instance by container element
        getInstance: function (container) {
            return container._bbfFilialfinder || null;
        },

        // Get all instances
        getInstances: function () {
            return instances.slice();
        },

        // Utility: opening status calculation
        getOpeningStatus: getOpeningStatus,

        // Utility: haversine distance
        haversineDistance: haversineDistance,

        // Utility: format distance
        formatDistance: formatDistance,

        // Constants
        events: {
            BRANCH_SELECT: EVENT_BRANCH_SELECT,
            MAP_READY: EVENT_MAP_READY
        }
    };

})();
