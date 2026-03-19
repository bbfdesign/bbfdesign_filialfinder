/**
 * BBF Filialfinder – Admin JS
 * jQuery + data-page pattern (proven in bbfdesign_search / bbfdesign_bikepark_routes)
 */

$(document).ready(function () {
    // ── Sidebar Navigation ──
    $('.bbf-sidebar-nav a[data-page]').on('click', function (e) {
        e.preventDefault();
        getPage($(this).data('page'));
    });

    // ── Sidebar Toggle ──
    $('#bbf-sidebar-toggle').on('click', function () {
        $('#bbf-sidebar').toggleClass('bbf-sidebar-collapsed');
    });

    // ── Load initial page ──
    getPage('branches');
});

/* ═══════════════════════════════════════════════════════════
   AJAX Page Navigation
   ═══════════════════════════════════════════════════════════ */

function getPage(page) {
    // Show loading spinner
    $('#bbf-page-content').html(
        '<div style="text-align:center;padding:60px 0;">' +
        '<div class="bbf-spinner bbf-spinner-lg"></div>' +
        '<p style="margin-top:16px;color:#999;font-size:14px;">Lade...</p></div>'
    );

    $.ajax({
        url: postURL,
        method: 'POST',
        dataType: 'json',
        data: {
            action: 'getPage',
            page: page,
            is_ajax: 1,
            jtl_token: jtlToken
        },
        success: function (response) {
            if (response && response.errors && response.errors.length) {
                response.errors.forEach(function (err) {
                    bbfToast(err, 'error');
                });
                return;
            }
            if (response && response.content) {
                $('#bbf-page-content').html(response.content);
                bbfAfterPageLoad(page);
            } else {
                $('#bbf-page-content').html(
                    '<div class="bbf-card"><p>Kein Inhalt geladen. Response: ' +
                    bbfEscape(JSON.stringify(response).substring(0, 200)) + '</p></div>'
                );
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            var detail = (jqXHR.responseText || '').substring(0, 300);
            console.error('BBF getPage error:', textStatus, errorThrown, detail);
            $('#bbf-page-content').html(
                '<div class="bbf-card">' +
                '<p style="color:#dc2626;font-weight:600;">Laden fehlgeschlagen</p>' +
                '<p style="font-size:13px;color:#666;">HTTP ' + (jqXHR.status || '?') + ': ' + bbfEscape(errorThrown || textStatus) + '</p>' +
                '<p style="font-size:12px;color:#999;margin-top:8px;">postURL = ' + bbfEscape(postURL || '(leer)') + '</p>' +
                (detail ? '<pre style="font-size:11px;color:#999;white-space:pre-wrap;margin-top:8px;">' + bbfEscape(detail) + '</pre>' : '') +
                '</div>'
            );
        }
    });
}

function bbfAfterPageLoad(page) {
    // Fade-in
    var el = document.getElementById('bbf-page-content');
    if (el) { el.classList.remove('bbf-page-enter'); void el.offsetWidth; el.classList.add('bbf-page-enter'); }

    // Update active sidebar link
    $('.bbf-sidebar-nav a').removeClass('bbf-nav-active');
    $('.bbf-sidebar-nav a[data-page="' + page + '"]').addClass('bbf-nav-active');

    // Execute inline scripts from loaded template
    $('#bbf-page-content script').each(function () {
        if (this.src) {
            $.getScript(this.src);
        } else {
            try { $.globalEval(this.textContent); } catch (e) { console.warn('BBF script eval:', e); }
        }
    });
}

/* ═══════════════════════════════════════════════════════════
   Toast Notifications
   ═══════════════════════════════════════════════════════════ */

function bbfToast(message, type) {
    type = type || 'success';
    var toast = document.createElement('div');
    toast.className = 'bbf-toast bbf-toast--' + type;
    toast.textContent = (type === 'success' ? '✓ ' : type === 'error' ? '✕ ' : '⚠ ') + message;
    document.body.appendChild(toast);
    setTimeout(function () { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 3500);
}

/* ═══════════════════════════════════════════════════════════
   AJAX Helper
   ═══════════════════════════════════════════════════════════ */

function bbfAjax(action, data, callback) {
    if (data instanceof FormData) {
        data.append('action', action);
        data.append('is_ajax', '1');
        data.append('jtl_token', jtlToken);
        $.ajax({
            url: postURL, method: 'POST', data: data,
            contentType: false, processData: false, dataType: 'json',
            success: function (r) { if (callback) callback(r); },
            error: function () { bbfToast('Verbindungsfehler', 'error'); }
        });
        return;
    }
    var params = { action: action, is_ajax: 1, jtl_token: jtlToken };
    if (typeof data === 'object') $.extend(params, data);
    $.ajax({
        url: postURL, method: 'POST', data: params, dataType: 'json',
        success: function (r) { if (callback) callback(r); },
        error: function () { bbfToast('Verbindungsfehler', 'error'); }
    });
}

function bbfSaveSettings(formId, page) {
    var form = document.getElementById(formId);
    if (!form) return;
    var formData = new FormData(form);
    formData.append('settings_page', page || '');
    form.querySelectorAll('input[type="checkbox"]').forEach(function (cb) {
        if (!cb.checked) formData.set(cb.name, '0');
    });
    bbfAjax('saveSettings', formData, function (r) {
        if (r && r.success) bbfToast(r.message || 'Gespeichert', 'success');
        else if (r && r.errors) r.errors.forEach(function (e) { bbfToast(e, 'error'); });
        else bbfToast('Speichern fehlgeschlagen', 'error');
    });
}

/* ═══════════════════════════════════════════════════════════
   UI Helpers (Tabs, Accordions, etc.)
   ═══════════════════════════════════════════════════════════ */

function bbfInitTabs() {
    $(document).off('click.bbftabs').on('click.bbftabs', '.bbf-tabs .bbf-tab-link', function (e) {
        e.preventDefault();
        var target = $(this).data('tab');
        if (!target) return;
        $(this).closest('.bbf-tabs').find('.bbf-tab-link').removeClass('active');
        $(this).addClass('active');
        var parent = $(this).closest('.bbf-card').length ? $(this).closest('.bbf-card') : $('#bbf-page-content');
        parent.find('.bbf-tab-content').removeClass('active');
        parent.find('[data-tab-content="' + target + '"]').addClass('active');
    });
}

function bbfInitAccordions() {
    document.querySelectorAll('.bbf-accordion-header').forEach(function (header) {
        header.addEventListener('click', function () {
            var body = this.nextElementSibling;
            var isActive = this.classList.contains('active');
            var accordion = this.closest('.bbf-accordion');
            if (accordion) {
                accordion.querySelectorAll('.bbf-accordion-header').forEach(function (h) { h.classList.remove('active'); });
                accordion.querySelectorAll('.bbf-accordion-body').forEach(function (b) { b.classList.remove('active'); });
            }
            if (!isActive) { this.classList.add('active'); if (body) body.classList.add('active'); }
        });
    });
}

function bbfInitLayoutsPage() {
    document.querySelectorAll('.bbf-layout-option').forEach(function (opt) {
        opt.addEventListener('click', function () {
            document.querySelectorAll('.bbf-layout-option').forEach(function (o) { o.classList.remove('selected'); });
            this.classList.add('selected');
            var radio = this.querySelector('input[type="radio"]');
            if (radio) { radio.checked = true; if (typeof bbfUpdateLayoutPreview === 'function') bbfUpdateLayoutPreview(radio.value); }
        });
    });
}

function bbfInitStylingPage() {
    document.querySelectorAll('.bbf-colorpicker').forEach(function (cp) {
        var colorInput = cp.querySelector('input[type="color"]');
        var textInput = cp.querySelector('input[type="text"]');
        if (colorInput && textInput) {
            colorInput.addEventListener('input', function () { textInput.value = this.value; });
            textInput.addEventListener('input', function () { if (/^#[0-9a-fA-F]{6}$/.test(this.value)) colorInput.value = this.value; });
        }
    });
    document.querySelectorAll('.bbf-range-group').forEach(function (rg) {
        var range = rg.querySelector('input[type="range"]');
        var val = rg.querySelector('.bbf-range-value');
        if (range && val) { range.addEventListener('input', function () { val.textContent = this.value + (this.dataset.unit || 'px'); }); }
    });
}

function bbfInitCssEditor() {
    var textarea = document.getElementById('bbf-css-textarea');
    if (textarea && typeof CodeMirror !== 'undefined') {
        window.bbfCssEditor = CodeMirror.fromTextArea(textarea, { mode: 'css', lineNumbers: true, matchBrackets: true });
        window.bbfCssEditor.setSize('100%', '400px');
    }
}

function bbfSaveCss() {
    var css = window.bbfCssEditor ? window.bbfCssEditor.getValue() : (document.getElementById('bbf-css-textarea') || {}).value || '';
    bbfAjax('saveSettings', { setting_custom_css: css, settings_page: 'css_editor' }, function (r) {
        if (r && r.success) bbfToast('CSS gespeichert', 'success');
    });
}

function bbfResetCss() {
    if (!confirm('CSS zurücksetzen?')) return;
    if (window.bbfCssEditor) window.bbfCssEditor.setValue('');
    else { var t = document.getElementById('bbf-css-textarea'); if (t) t.value = ''; }
    bbfSaveCss();
}

function bbfTestApiKey() {
    var el = document.getElementById('bbf-google-api-key');
    if (!el || !el.value.trim()) { bbfToast('Bitte API-Key eingeben', 'error'); return; }
    bbfAjax('testApiKey', { api_key: el.value.trim() }, function (r) {
        bbfToast(r && r.message ? r.message : 'Ergebnis unbekannt', r && r.success ? 'success' : 'error');
    });
}

function bbfSaveLayout() {
    var selected = document.querySelector('.bbf-layout-option.selected input[type="radio"]');
    if (!selected) { bbfToast('Bitte Vorlage auswählen', 'error'); return; }
    bbfAjax('saveSettings', { setting_layout_template: selected.value, settings_page: 'layouts' }, function (r) {
        if (r && r.success) bbfToast('Vorlage gespeichert', 'success');
    });
}

function bbfEscape(str) {
    if (!str) return '';
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
}
