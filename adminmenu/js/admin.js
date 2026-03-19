/**
 * BBF Filialfinder – Admin Alpine.js Application
 */

function bbfFilialfinder() {
    return {
        page: 'branches',
        pageContent: '',
        sidebarOpen: false,
        loading: false,

        init() {
            this.loadPage('branches');

            // Restore sidebar state
            try {
                if (localStorage.getItem('bbf_ff_sidebar') === 'collapsed') {
                    var sidebar = document.getElementById('bbf-sidebar');
                    if (sidebar) sidebar.classList.add('bbf-sidebar-collapsed');
                }
            } catch(e) {}
        },

        loadPage(pageName) {
            this.page = pageName;
            this.loading = true;
            this.sidebarOpen = false;

            var container = document.getElementById('bbf-page-content');
            if (container) {
                container.innerHTML = '<div class="bbf-text-center" style="padding:60px 0"><div class="bbf-spinner bbf-spinner-lg"></div><br><small class="bbf-text-muted">Lade...</small></div>';
            }

            var self = this;
            var xhr = new XMLHttpRequest();
            xhr.open('POST', postURL, true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.responseType = 'json';
            xhr.onload = function() {
                if (xhr.status === 200 && xhr.response) {
                    if (xhr.response.content) {
                        container.innerHTML = xhr.response.content;
                        // Fade-in animation
                        container.classList.remove('bbf-page-enter');
                        void container.offsetWidth;
                        container.classList.add('bbf-page-enter');
                        // Init page-specific scripts
                        self.initPageScripts(pageName);
                        self.evalInlineScripts(container);
                    }
                    if (xhr.response.errors) {
                        xhr.response.errors.forEach(function(err) {
                            bbfToast(err, 'error');
                        });
                    }
                } else {
                    container.innerHTML = '<div class="bbf-card"><p>Laden fehlgeschlagen.</p></div>';
                }
                self.loading = false;
            };
            xhr.onerror = function() {
                container.innerHTML = '<div class="bbf-card"><p>Verbindungsfehler.</p></div>';
                self.loading = false;
            };
            xhr.send('action=getPage&page=' + encodeURIComponent(pageName) + '&is_ajax=1&jtl_token=' + encodeURIComponent(jtlToken));
        },

        initPageScripts(pageName) {
            // Initialize page-specific features after AJAX load
            switch (pageName) {
                case 'branches':
                    bbfInitBranchesPage();
                    break;
                case 'layouts':
                    bbfInitLayoutsPage();
                    break;
                case 'styling':
                    bbfInitStylingPage();
                    break;
                case 'css_editor':
                    bbfInitCssEditor();
                    break;
                case 'documentation':
                    bbfInitAccordions();
                    break;
            }

            // Init tabs on all pages
            bbfInitTabs();
            // Init toggle switches
            bbfInitToggles();
        },

        evalInlineScripts(container) {
            var scripts = container.querySelectorAll('script');
            scripts.forEach(function(script) {
                var newScript = document.createElement('script');
                if (script.src) {
                    newScript.src = script.src;
                } else {
                    newScript.textContent = script.textContent;
                }
                document.head.appendChild(newScript);
                document.head.removeChild(newScript);
            });
        }
    };
}

/* ═══════════════════════════════════════════════════════════
   Toast Notifications
   ═══════════════════════════════════════════════════════════ */

function bbfToast(message, type) {
    type = type || 'success';
    var toast = document.createElement('div');
    toast.className = 'bbf-toast bbf-toast--' + type;
    var icon = type === 'success' ? '✓' : type === 'error' ? '✕' : '⚠';
    toast.innerHTML = '<span>' + icon + '</span> ' + bbfEscape(message);
    document.body.appendChild(toast);
    setTimeout(function() {
        if (toast.parentNode) toast.parentNode.removeChild(toast);
    }, 3500);
}

/* ═══════════════════════════════════════════════════════════
   AJAX Helpers
   ═══════════════════════════════════════════════════════════ */

function bbfAjax(action, data, callback) {
    var params = 'action=' + encodeURIComponent(action) + '&is_ajax=1&jtl_token=' + encodeURIComponent(jtlToken);
    if (typeof data === 'string') {
        params += '&' + data;
    } else if (data instanceof FormData) {
        data.append('action', action);
        data.append('is_ajax', '1');
        data.append('jtl_token', jtlToken);
        var xhr = new XMLHttpRequest();
        xhr.open('POST', postURL, true);
        xhr.responseType = 'json';
        xhr.onload = function() {
            if (callback) callback(xhr.response);
        };
        xhr.send(data);
        return;
    } else if (typeof data === 'object') {
        for (var key in data) {
            if (data.hasOwnProperty(key)) {
                params += '&' + encodeURIComponent(key) + '=' + encodeURIComponent(data[key]);
            }
        }
    }

    var xhr = new XMLHttpRequest();
    xhr.open('POST', postURL, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.responseType = 'json';
    xhr.onload = function() {
        if (callback) callback(xhr.response);
    };
    xhr.onerror = function() {
        bbfToast('Verbindungsfehler', 'error');
    };
    xhr.send(params);
}

function bbfSaveSettings(formId, page) {
    var form = document.getElementById(formId);
    if (!form) return;

    var formData = new FormData(form);
    formData.append('settings_page', page || '');

    // Handle unchecked checkboxes (toggles)
    form.querySelectorAll('input[type="checkbox"]').forEach(function(cb) {
        if (!cb.checked) {
            formData.set(cb.name, '0');
        }
    });

    bbfAjax('saveSettings', formData, function(response) {
        if (response && response.success) {
            bbfToast(response.message || 'Gespeichert', 'success');
        } else if (response && response.errors) {
            response.errors.forEach(function(e) { bbfToast(e, 'error'); });
        } else {
            bbfToast('Speichern fehlgeschlagen', 'error');
        }
    });
}

/* ═══════════════════════════════════════════════════════════
   Page: Branches
   ═══════════════════════════════════════════════════════════ */

function bbfInitBranchesPage() {
    var searchInput = document.getElementById('bbf-branch-search');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            bbfFilterBranchTable(this.value);
        });
    }

    // Per-page selector
    var perPage = document.getElementById('bbf-per-page');
    if (perPage) {
        perPage.addEventListener('change', function() {
            bbfPaginateBranches(1, parseInt(this.value));
        });
    }

    // Init pagination
    bbfPaginateBranches(1, 10);

    // Bulk select all
    var selectAll = document.getElementById('bbf-select-all');
    if (selectAll) {
        selectAll.addEventListener('change', function() {
            var checked = this.checked;
            document.querySelectorAll('.bbf-branch-checkbox').forEach(function(cb) {
                cb.checked = checked;
            });
            bbfUpdateBulkBar();
        });
    }
}

function bbfFilterBranchTable(query) {
    query = query.toLowerCase();
    document.querySelectorAll('#bbf-branch-tbody tr').forEach(function(row) {
        var text = row.textContent.toLowerCase();
        row.style.display = text.indexOf(query) >= 0 ? '' : 'none';
    });
}

var bbfCurrentPage = 1;
var bbfPerPage = 10;

function bbfPaginateBranches(page, perPage) {
    bbfCurrentPage = page || 1;
    bbfPerPage = perPage || bbfPerPage;
    var rows = document.querySelectorAll('#bbf-branch-tbody tr');
    var total = rows.length;
    var totalPages = Math.ceil(total / bbfPerPage);
    var start = (bbfCurrentPage - 1) * bbfPerPage;
    var end = start + bbfPerPage;

    rows.forEach(function(row, i) {
        row.style.display = (i >= start && i < end) ? '' : 'none';
    });

    // Update pagination
    var pag = document.getElementById('bbf-pagination');
    if (pag) {
        var html = '';
        html += '<button ' + (bbfCurrentPage <= 1 ? 'disabled' : '') + ' onclick="bbfPaginateBranches(' + (bbfCurrentPage - 1) + ')">&laquo;</button>';
        for (var p = 1; p <= totalPages; p++) {
            html += '<button class="' + (p === bbfCurrentPage ? 'active' : '') + '" onclick="bbfPaginateBranches(' + p + ')">' + p + '</button>';
        }
        html += '<button ' + (bbfCurrentPage >= totalPages ? 'disabled' : '') + ' onclick="bbfPaginateBranches(' + (bbfCurrentPage + 1) + ')">&raquo;</button>';
        pag.innerHTML = html;
    }

    var info = document.getElementById('bbf-page-info');
    if (info) {
        info.textContent = 'Zeige ' + (total > 0 ? start + 1 : 0) + '-' + Math.min(end, total) + ' von ' + total;
    }
}

function bbfUpdateBulkBar() {
    var checked = document.querySelectorAll('.bbf-branch-checkbox:checked').length;
    var bar = document.getElementById('bbf-bulk-bar');
    if (bar) {
        if (checked > 0) {
            bar.classList.add('visible');
            document.getElementById('bbf-bulk-count').textContent = checked + ' ausgewählt';
        } else {
            bar.classList.remove('visible');
        }
    }
}

function bbfToggleBranchActive(id, active) {
    bbfAjax('toggleActive', { branch_id: id, is_active: active ? 1 : 0 }, function(response) {
        if (response && response.success) {
            bbfToast('Status aktualisiert', 'success');
        }
    });
}

function bbfDeleteBranch(id) {
    if (!confirm('Möchten Sie diese Filiale wirklich löschen?')) return;
    bbfAjax('deleteBranch', { branch_id: id }, function(response) {
        if (response && response.success) {
            bbfToast(response.message || 'Gelöscht', 'success');
            bbfReloadPage('branches');
        } else if (response && response.errors) {
            response.errors.forEach(function(e) { bbfToast(e, 'error'); });
        }
    });
}

function bbfDuplicateBranch(id) {
    bbfAjax('duplicateBranch', { branch_id: id }, function(response) {
        if (response && response.success) {
            bbfToast(response.message || 'Dupliziert', 'success');
            bbfReloadPage('branches');
        }
    });
}

function bbfBulkAction(action) {
    var ids = [];
    document.querySelectorAll('.bbf-branch-checkbox:checked').forEach(function(cb) {
        ids.push(cb.value);
    });
    if (ids.length === 0) return;

    if (action === 'delete' && !confirm('Möchten Sie ' + ids.length + ' Filialen wirklich löschen?')) return;

    var formData = new FormData();
    formData.append('bulk_action', action);
    ids.forEach(function(id) {
        formData.append('branch_ids[]', id);
    });

    bbfAjax('bulkAction', formData, function(response) {
        if (response && response.success) {
            bbfToast(response.message, 'success');
            bbfReloadPage('branches');
        }
    });
}

function bbfShowBranchForm(id) {
    var formContainer = document.getElementById('bbf-branch-form');
    var listContainer = document.getElementById('bbf-branch-list');
    if (formContainer && listContainer) {
        listContainer.style.display = 'none';
        formContainer.style.display = 'block';
    }
    if (id && id > 0) {
        bbfLoadBranchData(id);
    }
}

function bbfHideBranchForm() {
    var formContainer = document.getElementById('bbf-branch-form');
    var listContainer = document.getElementById('bbf-branch-list');
    if (formContainer && listContainer) {
        formContainer.style.display = 'none';
        listContainer.style.display = 'block';
    }
}

function bbfLoadBranchData(id) {
    bbfAjax('getBranch', { branch_id: id }, function(response) {
        if (response && response.success && response.branch) {
            bbfPopulateBranchForm(response.branch);
        }
    });
}

function bbfPopulateBranchForm(branch) {
    var fields = ['name', 'description', 'street', 'zip', 'city', 'country', 'phone', 'email',
        'website', 'latitude', 'longitude', 'google_place_id', 'marker_color', 'css_class', 'sort_order'];
    fields.forEach(function(field) {
        var el = document.getElementById('bbf-field-' + field);
        if (el) el.value = branch[field] || '';
    });

    var idField = document.getElementById('bbf-field-branch_id');
    if (idField) idField.value = branch.id || '';

    var activeToggle = document.getElementById('bbf-field-is_active');
    if (activeToggle) activeToggle.checked = parseInt(branch.is_active) === 1;

    // Populate opening hours
    if (branch.hours) {
        branch.hours.forEach(function(h) {
            var day = parseInt(h.day_of_week);
            var openToggle = document.getElementById('bbf-hours-open-' + day);
            if (openToggle) openToggle.checked = parseInt(h.is_open) === 1;

            ['open_time_1', 'close_time_1', 'open_time_2', 'close_time_2'].forEach(function(tf) {
                var timeEl = document.getElementById('bbf-hours-' + tf.replace(/_/g, '-') + '-' + day);
                if (timeEl) timeEl.value = h[tf] ? h[tf].substring(0, 5) : '';
            });
        });
    }

    // Populate special days
    if (branch.special_days && branch.special_days.length > 0) {
        var container = document.getElementById('bbf-special-days-container');
        if (container) {
            container.innerHTML = '';
            branch.special_days.forEach(function(sd) {
                bbfAddSpecialDayRow(sd);
            });
        }
    }

    // Image preview
    if (branch.image_path) {
        var preview = document.getElementById('bbf-image-preview');
        if (preview) {
            preview.src = branch.image_path;
            preview.style.display = 'block';
        }
    }
}

function bbfSaveBranch() {
    var form = document.getElementById('bbf-branch-form-data');
    if (!form) return;

    var formData = new FormData(form);
    // Handle unchecked toggles
    form.querySelectorAll('input[type="checkbox"]').forEach(function(cb) {
        if (!formData.has(cb.name)) {
            formData.set(cb.name, '0');
        }
    });

    bbfAjax('saveBranch', formData, function(response) {
        if (response && response.success) {
            bbfToast(response.message || 'Gespeichert', 'success');
            bbfReloadPage('branches');
        } else if (response && response.errors) {
            response.errors.forEach(function(e) { bbfToast(e, 'error'); });
        }
    });
}

function bbfGeocode() {
    var street = document.getElementById('bbf-field-street');
    var zip = document.getElementById('bbf-field-zip');
    var city = document.getElementById('bbf-field-city');
    var country = document.getElementById('bbf-field-country');

    bbfAjax('geocode', {
        street: street ? street.value : '',
        zip: zip ? zip.value : '',
        city: city ? city.value : '',
        country: country ? country.value : 'DE'
    }, function(response) {
        if (response && response.success) {
            var latField = document.getElementById('bbf-field-latitude');
            var lngField = document.getElementById('bbf-field-longitude');
            if (latField) latField.value = response.lat;
            if (lngField) lngField.value = response.lng;
            bbfToast('Koordinaten ermittelt: ' + response.lat.toFixed(6) + ', ' + response.lng.toFixed(6), 'success');
        } else if (response && response.errors) {
            response.errors.forEach(function(e) { bbfToast(e, 'error'); });
        }
    });
}

function bbfCopyMondayToAll() {
    for (var day = 1; day < 7; day++) {
        var openToggle = document.getElementById('bbf-hours-open-' + day);
        var mondayToggle = document.getElementById('bbf-hours-open-0');
        if (openToggle && mondayToggle) openToggle.checked = mondayToggle.checked;

        ['open-time-1', 'close-time-1', 'open-time-2', 'close-time-2'].forEach(function(tf) {
            var src = document.getElementById('bbf-hours-' + tf + '-0');
            var dest = document.getElementById('bbf-hours-' + tf + '-' + day);
            if (src && dest) dest.value = src.value;
        });
    }
    bbfToast('Montag auf alle Tage übertragen', 'success');
}

var bbfSpecialDayIndex = 0;

function bbfAddSpecialDayRow(data) {
    var container = document.getElementById('bbf-special-days-container');
    if (!container) return;

    var idx = bbfSpecialDayIndex++;
    var row = document.createElement('div');
    row.className = 'bbf-form-row bbf-mb-8';
    row.setAttribute('data-sd-index', idx);
    row.innerHTML =
        '<div class="bbf-form-group">' +
            '<input type="date" name="special_day_date[' + idx + ']" class="bbf-form-control" value="' + (data && data.date ? data.date : '') + '">' +
        '</div>' +
        '<div class="bbf-form-group">' +
            '<label class="bbf-toggle-label"><label class="bbf-toggle"><input type="checkbox" name="special_day_closed[' + idx + ']" value="1"' + (data && parseInt(data.is_closed) ? ' checked' : '') + '><span class="bbf-toggle-slider"></span></label> Geschlossen</label>' +
        '</div>' +
        '<div class="bbf-form-group">' +
            '<input type="time" name="special_day_open_time[' + idx + ']" class="bbf-form-control" value="' + (data && data.open_time ? data.open_time.substring(0, 5) : '') + '" placeholder="Von">' +
        '</div>' +
        '<div class="bbf-form-group">' +
            '<input type="time" name="special_day_close_time[' + idx + ']" class="bbf-form-control" value="' + (data && data.close_time ? data.close_time.substring(0, 5) : '') + '" placeholder="Bis">' +
        '</div>' +
        '<div class="bbf-form-group">' +
            '<input type="text" name="special_day_note[' + idx + ']" class="bbf-form-control" value="' + bbfEscape(data && data.note ? data.note : '') + '" placeholder="Hinweis">' +
        '</div>' +
        '<div class="bbf-form-group">' +
            '<button type="button" class="bbf-btn-icon bbf-btn-icon-danger" onclick="this.closest(\'[data-sd-index]\').remove()">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>' +
            '</button>' +
        '</div>';
    container.appendChild(row);
}

/* ═══════════════════════════════════════════════════════════
   Page: Layouts
   ═══════════════════════════════════════════════════════════ */

function bbfInitLayoutsPage() {
    document.querySelectorAll('.bbf-layout-option').forEach(function(opt) {
        opt.addEventListener('click', function() {
            document.querySelectorAll('.bbf-layout-option').forEach(function(o) {
                o.classList.remove('selected');
            });
            this.classList.add('selected');
            var radio = this.querySelector('input[type="radio"]');
            if (radio) radio.checked = true;
            bbfUpdateLayoutPreview(radio.value);
        });
    });
}

function bbfUpdateLayoutPreview(layout) {
    var previewBody = document.getElementById('bbf-layout-preview');
    if (!previewBody) return;

    var previews = {
        'default': '<div style="display:flex;gap:16px"><div style="flex:1"><div style="border-left:3px solid #C8B831;padding:12px;margin-bottom:8px;background:#fafafa;border-radius:4px"><strong>God of Games Hof</strong><br><small>Lorenzstraße 14, 95028 Hof</small><br><span style="color:#16a34a;font-size:12px">● Jetzt geöffnet</span></div><div style="border-left:3px solid #C8B831;padding:12px;background:#fafafa;border-radius:4px"><strong>God of Games Plauen</strong><br><small>Postplatz 5, 08523 Plauen</small><br><span style="color:#dc2626;font-size:12px">● Geschlossen</span></div></div><div style="flex:1;background:#e5e7eb;border-radius:8px;display:flex;align-items:center;justify-content:center;min-height:200px;color:#6b7280">Kartenvorschau</div></div>',
        'map_only': '<div style="background:#e5e7eb;border-radius:8px;min-height:300px;display:flex;align-items:center;justify-content:center;color:#6b7280">Vollbreite Kartenansicht mit Markern</div>',
        'grid': '<div style="display:grid;grid-template-columns:1fr 1fr;gap:12px"><div style="border:1px solid #e5e7eb;border-radius:8px;padding:16px;text-align:center"><div style="background:#f0f2f5;height:60px;border-radius:4px;margin-bottom:8px"></div><strong>God of Games Hof</strong><br><small style="color:#6b7280">95028 Hof</small><br><span style="color:#16a34a;font-size:12px">● Geöffnet</span></div><div style="border:1px solid #e5e7eb;border-radius:8px;padding:16px;text-align:center"><div style="background:#f0f2f5;height:60px;border-radius:4px;margin-bottom:8px"></div><strong>God of Games Plauen</strong><br><small style="color:#6b7280">08523 Plauen</small><br><span style="color:#dc2626;font-size:12px">● Geschlossen</span></div></div>',
        'accordion': '<div><div style="border:1px solid #e5e7eb;border-radius:8px;margin-bottom:8px"><div style="padding:12px 16px;font-weight:600;cursor:pointer;display:flex;justify-content:space-between">God of Games Hof <span style="color:#16a34a">● Geöffnet</span></div><div style="padding:12px 16px;border-top:1px solid #e5e7eb;font-size:13px">Lorenzstraße 14, 95028 Hof<br>Tel: 09281 1446128</div></div><div style="border:1px solid #e5e7eb;border-radius:8px"><div style="padding:12px 16px;font-weight:600;cursor:pointer;display:flex;justify-content:space-between">God of Games Plauen <span style="color:#dc2626">● Geschlossen</span></div></div></div>',
        'table': '<table style="width:100%;border-collapse:collapse;font-size:13px"><thead><tr style="background:#f8f9fa"><th style="padding:8px;text-align:left;border-bottom:2px solid #e5e7eb">Name</th><th style="padding:8px;text-align:left;border-bottom:2px solid #e5e7eb">Adresse</th><th style="padding:8px;text-align:left;border-bottom:2px solid #e5e7eb">Telefon</th><th style="padding:8px;text-align:left;border-bottom:2px solid #e5e7eb">Status</th></tr></thead><tbody><tr><td style="padding:8px;border-bottom:1px solid #e5e7eb">God of Games Hof</td><td style="padding:8px;border-bottom:1px solid #e5e7eb">Lorenzstraße 14, 95028 Hof</td><td style="padding:8px;border-bottom:1px solid #e5e7eb">09281 1446128</td><td style="padding:8px;border-bottom:1px solid #e5e7eb"><span style="color:#16a34a">● Geöffnet</span></td></tr><tr><td style="padding:8px">God of Games Plauen</td><td style="padding:8px">Postplatz 5, 08523 Plauen</td><td style="padding:8px">03741 5987412</td><td style="padding:8px"><span style="color:#dc2626">● Geschlossen</span></td></tr></tbody></table>'
    };

    previewBody.innerHTML = previews[layout] || previews['default'];
}

function bbfSaveLayout() {
    var selected = document.querySelector('.bbf-layout-option.selected input[type="radio"]');
    if (!selected) {
        bbfToast('Bitte eine Vorlage auswählen', 'error');
        return;
    }
    bbfAjax('saveSettings', { setting_layout_template: selected.value, settings_page: 'layouts' }, function(response) {
        if (response && response.success) {
            bbfToast('Vorlage gespeichert', 'success');
        }
    });
}

/* ═══════════════════════════════════════════════════════════
   Page: Styling
   ═══════════════════════════════════════════════════════════ */

function bbfInitStylingPage() {
    // Sync color pickers with text inputs
    document.querySelectorAll('.bbf-colorpicker').forEach(function(cp) {
        var colorInput = cp.querySelector('input[type="color"]');
        var textInput = cp.querySelector('input[type="text"]');
        if (colorInput && textInput) {
            colorInput.addEventListener('input', function() {
                textInput.value = this.value;
            });
            textInput.addEventListener('input', function() {
                if (/^#[0-9a-fA-F]{6}$/.test(this.value)) {
                    colorInput.value = this.value;
                }
            });
        }
    });

    // Range sliders with value display
    document.querySelectorAll('.bbf-range-group').forEach(function(rg) {
        var range = rg.querySelector('input[type="range"]');
        var value = rg.querySelector('.bbf-range-value');
        if (range && value) {
            range.addEventListener('input', function() {
                value.textContent = this.value + (this.dataset.unit || 'px');
            });
        }
    });
}

/* ═══════════════════════════════════════════════════════════
   Page: CSS Editor
   ═══════════════════════════════════════════════════════════ */

function bbfInitCssEditor() {
    // If CodeMirror is available, initialize it
    var textarea = document.getElementById('bbf-css-textarea');
    if (textarea && typeof CodeMirror !== 'undefined') {
        window.bbfCssEditor = CodeMirror.fromTextArea(textarea, {
            mode: 'css',
            theme: 'default',
            lineNumbers: true,
            matchBrackets: true,
            autoCloseBrackets: true,
            indentUnit: 2,
            tabSize: 2,
        });
        window.bbfCssEditor.setSize('100%', '400px');
    }
}

function bbfSaveCss() {
    var css = '';
    if (window.bbfCssEditor) {
        css = window.bbfCssEditor.getValue();
    } else {
        var textarea = document.getElementById('bbf-css-textarea');
        if (textarea) css = textarea.value;
    }
    bbfAjax('saveSettings', { setting_custom_css: css, settings_page: 'css_editor' }, function(response) {
        if (response && response.success) {
            bbfToast('CSS gespeichert', 'success');
        }
    });
}

function bbfResetCss() {
    if (!confirm('Benutzerdefiniertes CSS wirklich zurücksetzen?')) return;
    if (window.bbfCssEditor) {
        window.bbfCssEditor.setValue('');
    } else {
        var textarea = document.getElementById('bbf-css-textarea');
        if (textarea) textarea.value = '';
    }
    bbfSaveCss();
}

/* ═══════════════════════════════════════════════════════════
   Page: Map Provider
   ═══════════════════════════════════════════════════════════ */

function bbfTestApiKey() {
    var apiKey = document.getElementById('bbf-google-api-key');
    if (!apiKey || !apiKey.value.trim()) {
        bbfToast('Bitte einen API-Key eingeben', 'error');
        return;
    }
    bbfAjax('testApiKey', { api_key: apiKey.value.trim() }, function(response) {
        if (response && response.success) {
            bbfToast(response.message || 'API-Key gültig', 'success');
        } else {
            bbfToast(response && response.message ? response.message : 'Ungültiger API-Key', 'error');
        }
    });
}

/* ═══════════════════════════════════════════════════════════
   Shared UI Helpers
   ═══════════════════════════════════════════════════════════ */

function bbfInitTabs() {
    document.querySelectorAll('.bbf-tabs .bbf-tab-link').forEach(function(tab) {
        tab.addEventListener('click', function(e) {
            e.preventDefault();
            var target = this.dataset.tab;
            if (!target) return;

            // Deactivate all tabs in this group
            this.closest('.bbf-tabs').querySelectorAll('.bbf-tab-link').forEach(function(t) {
                t.classList.remove('active');
            });
            this.classList.add('active');

            // Show/hide tab contents
            var parent = this.closest('.bbf-card') || document.getElementById('bbf-page-content');
            if (parent) {
                parent.querySelectorAll('.bbf-tab-content').forEach(function(tc) {
                    tc.classList.remove('active');
                });
                var content = parent.querySelector('[data-tab-content="' + target + '"]');
                if (content) content.classList.add('active');
            }
        });
    });
}

function bbfInitToggles() {
    // Toggles work natively with CSS — no JS needed
}

function bbfInitAccordions() {
    document.querySelectorAll('.bbf-accordion-header').forEach(function(header) {
        header.addEventListener('click', function() {
            var body = this.nextElementSibling;
            var isActive = this.classList.contains('active');

            // Close all in same accordion
            var accordion = this.closest('.bbf-accordion');
            if (accordion) {
                accordion.querySelectorAll('.bbf-accordion-header').forEach(function(h) {
                    h.classList.remove('active');
                });
                accordion.querySelectorAll('.bbf-accordion-body').forEach(function(b) {
                    b.classList.remove('active');
                });
            }

            if (!isActive) {
                this.classList.add('active');
                if (body) body.classList.add('active');
            }
        });
    });
}

function bbfReloadPage(page) {
    var el = document.querySelector('[x-data]');
    if (el && el.__x) {
        el.__x.$data.loadPage(page || el.__x.$data.page);
    } else {
        // Fallback: re-trigger Alpine
        try {
            var alpineEl = document.querySelector('.bbf-plugin-page');
            if (alpineEl && alpineEl._x_dataStack) {
                alpineEl._x_dataStack[0].loadPage(page || 'branches');
            }
        } catch(e) {
            location.reload();
        }
    }
}

function bbfEscape(str) {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
}
