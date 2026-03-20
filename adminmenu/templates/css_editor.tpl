{* ===== CodeMirror CSS/JS (MIT License) ===== *}
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/codemirror.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/theme/monokai.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/dialog/dialog.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/codemirror.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/mode/css/css.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/edit/matchbrackets.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/search/search.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/search/searchcursor.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.18/addon/dialog/dialog.min.js"></script>

{* ===== Card 1: Benutzerdefiniertes CSS ===== *}
<div class="bbf-card">
    <div class="bbf-card-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
        Benutzerdefiniertes CSS
    </div>

    <div class="bbf-form-group">
        <textarea id="bbf-css-textarea" name="custom_css" style="display:none;">{$customCss|default:''}</textarea>
        <div id="bbf-css-editor" style="border:1px solid var(--bbf-border);border-radius:var(--bbf-card-radius);overflow:hidden;"></div>
        <div class="bbf-form-hint" style="margin-top:8px;">
            Eigenes CSS wird nach den Standard-Styles geladen. <strong>Strg+F</strong> zum Suchen, <strong>Strg+H</strong> zum Ersetzen.
        </div>
    </div>

    <div class="bbf-flex-between" style="margin-top:16px;">
        <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveCss()">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
            CSS speichern
        </button>
        <button type="button" class="bbf-btn bbf-btn-danger" onclick="bbfResetCss()">CSS zur&uuml;cksetzen</button>
    </div>
</div>

{* ===== Card 2: Verf&uuml;gbare CSS-Klassen ===== *}
<div class="bbf-card">
    <div class="bbf-card-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
        Verf&uuml;gbare CSS-Klassen
    </div>

    <table class="bbf-table">
        <thead>
            <tr>
                <th style="width:300px;">Klasse</th>
                <th>Beschreibung</th>
            </tr>
        </thead>
        <tbody>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-wrapper</code></td><td>Hauptcontainer</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-layout--default</code></td><td>Standard-Layout (Liste + Karte)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card</code></td><td>Filial-Karte</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card--active</code></td><td>Aktive/Ausgew&auml;hlte Filiale</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-name</code></td><td>Filialname (h3)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-address</code></td><td>Adresse</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-phone</code></td><td>Telefonnummer</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-hours</code></td><td>&Ouml;ffnungszeiten-Block</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-columns</code></td><td>2-Spalten Container (Info + &Ouml;ffnungszeiten)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-map</code></td><td>Karten-Container</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-status--open</code></td><td>Ge&ouml;ffnet (gr&uuml;n)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-status--closed</code></td><td>Geschlossen (rot)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-btn--route</code></td><td>Route-berechnen Button</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-marker</code></td><td>SVG Kartenmarker</td></tr>
        </tbody>
    </table>
</div>

<script>
(function() {
    var textarea = document.getElementById('bbf-css-textarea');
    var editorDiv = document.getElementById('bbf-css-editor');
    if (!textarea || !editorDiv || typeof CodeMirror === 'undefined') return;

    window.bbfCssEditor = CodeMirror(editorDiv, {
        value: textarea.value,
        mode: 'css',
        theme: 'monokai',
        lineNumbers: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        lineWrapping: true,
        extraKeys: {
            'Ctrl-S': function() { bbfSaveCss(); },
            'Cmd-S': function() { bbfSaveCss(); }
        }
    });
    bbfCssEditor.setSize(null, 450);

    // Sync back to textarea before save
    var origSave = window.bbfSaveCss;
    window.bbfSaveCss = function() {
        textarea.value = bbfCssEditor.getValue();
        if (typeof origSave === 'function') {
            origSave();
        } else {
            var formData = new FormData();
            formData.append('action', 'saveSettings');
            formData.append('setting_custom_css', bbfCssEditor.getValue());
            formData.append('settings_page', 'css_editor');
            formData.append('is_ajax', '1');
            formData.append('jtl_token', typeof jtlToken !== 'undefined' ? jtlToken : '');
            fetch(typeof postURL !== 'undefined' ? postURL : '', { method: 'POST', body: formData })
                .then(function(r) { return r.json(); })
                .then(function(d) {
                    if (d.success && typeof bbfToast === 'function') bbfToast('CSS gespeichert', 'success');
                });
        }
    };
})();
</script>
