{* ── Import / Export ── *}

{* ── Card 1: Export ── *}
<div class="bbf-card">
  <h2 class="bbf-card-title">Export</h2>
  <p class="bbf-form-hint" style="margin-bottom:20px;">Exportieren Sie Ihre Filialdaten in verschiedenen Formaten.</p>

  {* Export Format Selection *}
  <div class="bbf-form-group">
    <label class="bbf-form-label">Export-Format</label>
    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-top:8px;">

      <label class="bbf-card" style="cursor:pointer;padding:16px;text-align:center;border:2px solid var(--bbf-border);transition:border-color 0.2s,box-shadow 0.2s;" id="bbf-export-format-csv-card">
        <input type="radio" name="export_format" value="csv" checked style="display:none;" onchange="bbfUpdateFormatCards()">
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto 8px;display:block;color:var(--bbf-primary);">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="8" y1="13" x2="16" y2="13"/><line x1="8" y1="17" x2="16" y2="17"/><polyline points="10 9 9 9 8 9"/>
        </svg>
        <div style="font-weight:600;font-size:14px;margin-bottom:4px;">CSV</div>
        <div style="font-size:12px;color:var(--bbf-text-muted);line-height:1.4;">Tabellarisches Format, kompatibel mit Excel und Google Sheets</div>
      </label>

      <label class="bbf-card" style="cursor:pointer;padding:16px;text-align:center;border:2px solid var(--bbf-border);transition:border-color 0.2s,box-shadow 0.2s;" id="bbf-export-format-json-card">
        <input type="radio" name="export_format" value="json" style="display:none;" onchange="bbfUpdateFormatCards()">
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto 8px;display:block;color:var(--bbf-primary);">
          <polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/>
        </svg>
        <div style="font-weight:600;font-size:14px;margin-bottom:4px;">JSON</div>
        <div style="font-size:12px;color:var(--bbf-text-muted);line-height:1.4;">Strukturiertes Format mit verschachtelten Daten (&Ouml;ffnungszeiten, Tags)</div>
      </label>

      <label class="bbf-card" style="cursor:pointer;padding:16px;text-align:center;border:2px solid var(--bbf-border);transition:border-color 0.2s,box-shadow 0.2s;" id="bbf-export-format-xml-card">
        <input type="radio" name="export_format" value="xml" style="display:none;" onchange="bbfUpdateFormatCards()">
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto 8px;display:block;color:var(--bbf-primary);">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><path d="M8 13l2 2-2 2"/><path d="M16 13l-2 2 2 2"/>
        </svg>
        <div style="font-weight:600;font-size:14px;margin-bottom:4px;">XML</div>
        <div style="font-size:12px;color:var(--bbf-text-muted);line-height:1.4;">Standard-Austauschformat f&uuml;r Systeme und APIs</div>
      </label>

    </div>
  </div>

  {* Data to include *}
  <div class="bbf-form-group">
    <label class="bbf-form-label">Daten einschlie&szlig;en</label>
    <div style="display:flex;flex-direction:column;gap:12px;margin-top:8px;">

      <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:var(--bbf-bg-secondary);border-radius:var(--bbf-radius);">
        <div>
          <div style="font-weight:500;font-size:14px;">&Ouml;ffnungszeiten</div>
          <div style="font-size:12px;color:var(--bbf-text-muted);">Regul&auml;re Zeiten pro Wochentag</div>
        </div>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-export-hours" checked>
          <span class="bbf-toggle-slider"></span>
        </label>
      </div>

      <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:var(--bbf-bg-secondary);border-radius:var(--bbf-radius);">
        <div>
          <div style="font-weight:500;font-size:14px;">Sondertage</div>
          <div style="font-size:12px;color:var(--bbf-text-muted);">Feiertage und besondere &Ouml;ffnungszeiten</div>
        </div>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-export-special-days" checked>
          <span class="bbf-toggle-slider"></span>
        </label>
      </div>

      <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:var(--bbf-bg-secondary);border-radius:var(--bbf-radius);">
        <div>
          <div style="font-weight:500;font-size:14px;">Tags</div>
          <div style="font-size:12px;color:var(--bbf-text-muted);">Kategorien und Schlagw&ouml;rter</div>
        </div>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-export-tags" checked>
          <span class="bbf-toggle-slider"></span>
        </label>
      </div>

      <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:var(--bbf-bg-secondary);border-radius:var(--bbf-radius);">
        <div>
          <div style="font-weight:500;font-size:14px;">Galerie-Pfade</div>
          <div style="font-size:12px;color:var(--bbf-text-muted);">Pfade zu Bildern in der Galerie</div>
        </div>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-export-gallery">
          <span class="bbf-toggle-slider"></span>
        </label>
      </div>

    </div>
  </div>

  {* Export all toggle *}
  <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:var(--bbf-bg-secondary);border-radius:var(--bbf-radius);margin-bottom:16px;">
    <div>
      <div style="font-weight:500;font-size:14px;">Alle Filialen exportieren</div>
      <div style="font-size:12px;color:var(--bbf-text-muted);">Einschlie&szlig;lich inaktiver Filialen</div>
    </div>
    <label class="bbf-toggle">
      <input type="checkbox" id="bbf-export-all">
      <span class="bbf-toggle-slider"></span>
    </label>
  </div>

  <p class="bbf-form-hint" style="margin-bottom:16px;">
    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;margin-right:4px;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
    Es werden nur aktive Filialen exportiert, sofern nicht anders angegeben.
  </p>

  <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfExportBranches()">
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
    Filialen exportieren (<span id="bbf-export-count">{$branchCount}</span> Filialen)
  </button>
</div>

{* ── Card 2: Import ── *}
<div class="bbf-card" style="margin-top:24px;">
  <h2 class="bbf-card-title">Import</h2>
  <p class="bbf-form-hint" style="margin-bottom:20px;">Importieren Sie Filialdaten aus einer CSV-, JSON- oder XML-Datei.</p>

  {* File Upload Area *}
  <div class="bbf-form-group">
    <label class="bbf-form-label">Datei ausw&auml;hlen</label>
    <div class="bbf-upload-area" id="bbf-import-upload"
         onclick="document.getElementById('bbf-import-file').click();"
         ondragover="event.preventDefault();this.classList.add('bbf-drag-over');"
         ondragleave="this.classList.remove('bbf-drag-over');"
         ondrop="event.preventDefault();this.classList.remove('bbf-drag-over');bbfHandleImportDrop(event);">
      <input type="file" id="bbf-import-file" accept=".csv,.json,.xml" style="display:none;" onchange="bbfPreviewImportFile(this);">
      <div id="bbf-import-placeholder">
        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
        </svg>
        <p style="margin-top:8px;">Datei hierher ziehen oder klicken zum Ausw&auml;hlen</p>
        <p style="font-size:12px;color:var(--bbf-text-muted);margin-top:4px;">CSV, JSON oder XML &ndash; Format wird automatisch erkannt</p>
      </div>
      <div id="bbf-import-file-info" style="display:none;">
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="color:var(--bbf-success);">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/>
        </svg>
        <p style="margin-top:8px;font-weight:600;" id="bbf-import-file-name"></p>
        <p style="font-size:12px;color:var(--bbf-text-muted);margin-top:2px;" id="bbf-import-file-size"></p>
        <button type="button" class="bbf-btn bbf-btn-danger bbf-btn-sm" onclick="event.stopPropagation();bbfRemoveImportFile();" style="margin-top:8px;">Datei entfernen</button>
      </div>
    </div>
  </div>

  {* Import Options *}
  <div class="bbf-form-group">
    <label class="bbf-form-label">Optionen</label>
    <div style="display:flex;flex-direction:column;gap:12px;margin-top:8px;">

      <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:var(--bbf-bg-secondary);border-radius:var(--bbf-radius);">
        <div>
          <div style="font-weight:500;font-size:14px;">Vorhandene Filialen aktualisieren</div>
          <div style="font-size:12px;color:var(--bbf-text-muted);">Abgleich &uuml;ber den Filialnamen</div>
        </div>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-import-update" checked>
          <span class="bbf-toggle-slider"></span>
        </label>
      </div>

      <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:var(--bbf-bg-secondary);border-radius:var(--bbf-radius);">
        <div>
          <div style="font-weight:500;font-size:14px;">Duplikate &uuml;berspringen</div>
          <div style="font-size:12px;color:var(--bbf-text-muted);">Bereits vorhandene Filialen nicht erneut anlegen</div>
        </div>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-import-skip-duplicates" checked>
          <span class="bbf-toggle-slider"></span>
        </label>
      </div>

    </div>
  </div>

  <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfImportBranches()" id="bbf-import-btn">
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
    Filialen importieren
  </button>

  {* Import Results *}
  <div id="bbf-import-results" style="display:none;margin-top:20px;">
    <div style="padding:16px;border-radius:var(--bbf-radius);border:1px solid var(--bbf-border);background:var(--bbf-bg-secondary);">
      <h3 style="margin:0 0 12px;font-size:16px;">Import-Ergebnis</h3>
      <div style="display:flex;gap:16px;margin-bottom:12px;">
        <div style="display:flex;align-items:center;gap:8px;">
          <span style="display:inline-block;width:12px;height:12px;border-radius:50%;background:var(--bbf-success);"></span>
          <span>Erfolgreich: <strong id="bbf-import-success-count">0</strong></span>
        </div>
        <div style="display:flex;align-items:center;gap:8px;">
          <span style="display:inline-block;width:12px;height:12px;border-radius:50%;background:var(--bbf-danger);"></span>
          <span>Fehler: <strong id="bbf-import-error-count">0</strong></span>
        </div>
      </div>
      <div id="bbf-import-error-list" style="display:none;">
        <h4 style="margin:0 0 8px;font-size:14px;color:var(--bbf-danger);">Fehlerdetails:</h4>
        <ul id="bbf-import-errors" style="margin:0;padding-left:20px;font-size:13px;color:var(--bbf-text-muted);line-height:1.8;"></ul>
      </div>
    </div>
  </div>

  {* Template Downloads *}
  <div style="margin-top:20px;padding-top:16px;border-top:1px solid var(--bbf-border);">
    <label class="bbf-form-label" style="margin-bottom:8px;">Vorlagen herunterladen</label>
    <div style="display:flex;gap:12px;flex-wrap:wrap;">
      <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfDownloadTemplate('csv')">
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
        CSV-Vorlage herunterladen
      </button>
      <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfDownloadTemplate('json')">
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
        JSON-Beispiel
      </button>
      <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfDownloadTemplate('xml')">
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
        XML-Beispiel
      </button>
    </div>
  </div>
</div>

<script>
{literal}
/* ── Format Card Highlight ── */
function bbfUpdateFormatCards() {
  var formats = ['csv', 'json', 'xml'];
  formats.forEach(function(f) {
    var card = document.getElementById('bbf-export-format-' + f + '-card');
    var radio = card.querySelector('input[type="radio"]');
    if (radio.checked) {
      card.style.borderColor = 'var(--bbf-primary)';
      card.style.boxShadow = '0 0 0 3px rgba(13,110,253,0.12)';
      card.style.background = 'var(--bbf-bg-secondary)';
    } else {
      card.style.borderColor = 'var(--bbf-border)';
      card.style.boxShadow = 'none';
      card.style.background = '';
    }
  });
}

/* ── Export ── */
function bbfExportBranches() {
  var format = document.querySelector('input[name="export_format"]:checked').value;
  var options = {
    format: format,
    includeHours: document.getElementById('bbf-export-hours').checked ? 1 : 0,
    includeSpecialDays: document.getElementById('bbf-export-special-days').checked ? 1 : 0,
    includeTags: document.getElementById('bbf-export-tags').checked ? 1 : 0,
    includeGallery: document.getElementById('bbf-export-gallery').checked ? 1 : 0,
    includeAll: document.getElementById('bbf-export-all').checked ? 1 : 0
  };

  var formData = new FormData();
  formData.append('action', 'exportBranches');
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);
  for (var key in options) {
    formData.append(key, options[key]);
  }

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.blob(); })
    .then(function(blob) {
      var ext = format;
      var mimeTypes = { csv: 'text/csv', json: 'application/json', xml: 'application/xml' };
      var url = window.URL.createObjectURL(blob);
      var a = document.createElement('a');
      a.href = url;
      a.download = 'filialen_export_' + new Date().toISOString().slice(0, 10) + '.' + ext;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      window.URL.revokeObjectURL(url);
    })
    .catch(function() {
      alert('Fehler beim Export. Bitte versuchen Sie es erneut.');
    });
}

/* ── Import ── */
function bbfImportBranches() {
  var fileInput = document.getElementById('bbf-import-file');
  if (!fileInput.files || !fileInput.files.length) {
    alert('Bitte w\u00e4hlen Sie zuerst eine Datei aus.');
    return;
  }

  var formData = new FormData();
  formData.append('action', 'importBranches');
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);
  formData.append('import_file', fileInput.files[0]);
  formData.append('update_existing', document.getElementById('bbf-import-update').checked ? 1 : 0);
  formData.append('skip_duplicates', document.getElementById('bbf-import-skip-duplicates').checked ? 1 : 0);

  var btn = document.getElementById('bbf-import-btn');
  btn.disabled = true;
  btn.innerHTML = '<span class="bbf-spinner bbf-spinner-sm"></span> Importiere...';

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      btn.disabled = false;
      btn.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg> Filialen importieren';

      var resultsEl = document.getElementById('bbf-import-results');
      resultsEl.style.display = '';

      document.getElementById('bbf-import-success-count').textContent = data.successCount || 0;
      document.getElementById('bbf-import-error-count').textContent = data.errorCount || 0;

      var errorList = document.getElementById('bbf-import-error-list');
      var errorsUl = document.getElementById('bbf-import-errors');
      errorsUl.innerHTML = '';

      if (data.errors && data.errors.length > 0) {
        errorList.style.display = '';
        data.errors.forEach(function(err) {
          var li = document.createElement('li');
          li.textContent = err;
          errorsUl.appendChild(li);
        });
      } else {
        errorList.style.display = 'none';
      }
    })
    .catch(function() {
      btn.disabled = false;
      btn.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg> Filialen importieren';
      alert('Fehler beim Import. Bitte versuchen Sie es erneut.');
    });
}

/* ── File Preview ── */
function bbfPreviewImportFile(input) {
  if (input.files && input.files[0]) {
    var file = input.files[0];
    document.getElementById('bbf-import-file-name').textContent = file.name;
    var size = file.size;
    var sizeStr = size < 1024 ? size + ' B' : size < 1048576 ? (size / 1024).toFixed(1) + ' KB' : (size / 1048576).toFixed(1) + ' MB';
    document.getElementById('bbf-import-file-size').textContent = sizeStr;
    document.getElementById('bbf-import-placeholder').style.display = 'none';
    document.getElementById('bbf-import-file-info').style.display = '';
  }
}

function bbfRemoveImportFile() {
  document.getElementById('bbf-import-file').value = '';
  document.getElementById('bbf-import-placeholder').style.display = '';
  document.getElementById('bbf-import-file-info').style.display = 'none';
}

function bbfHandleImportDrop(e) {
  var dt = e.dataTransfer;
  if (dt.files && dt.files.length) {
    document.getElementById('bbf-import-file').files = dt.files;
    bbfPreviewImportFile(document.getElementById('bbf-import-file'));
  }
}

/* ── Template Download ── */
function bbfDownloadTemplate(format) {
  var content = '';
  var filename = 'filialen_vorlage.' + format;
  var mimeType = '';

  if (format === 'csv') {
    mimeType = 'text/csv;charset=utf-8';
    content = 'name;street;zip;city;country;phone;email;website;latitude;longitude;description;is_active\n';
    content += '"Muster-Filiale";"Musterstra\u00dfe 1";"10115";"Berlin";"DE";"+49 30 123456";"info@example.de";"https://www.example.de";"52.520008";"13.404954";"Beschreibung der Filiale";"1"\n';
  } else if (format === 'json') {
    mimeType = 'application/json;charset=utf-8';
    var template = [{
      name: "Muster-Filiale",
      street: "Musterstra\u00dfe 1",
      zip: "10115",
      city: "Berlin",
      country: "DE",
      phone: "+49 30 123456",
      email: "info@example.de",
      website: "https://www.example.de",
      latitude: 52.520008,
      longitude: 13.404954,
      description: "Beschreibung der Filiale",
      is_active: true,
      opening_hours: {
        mon: { open: true, time1_open: "09:00", time1_close: "17:00", time2_open: "", time2_close: "" },
        tue: { open: true, time1_open: "09:00", time1_close: "17:00", time2_open: "", time2_close: "" },
        wed: { open: true, time1_open: "09:00", time1_close: "17:00", time2_open: "", time2_close: "" },
        thu: { open: true, time1_open: "09:00", time1_close: "17:00", time2_open: "", time2_close: "" },
        fri: { open: true, time1_open: "09:00", time1_close: "17:00", time2_open: "", time2_close: "" },
        sat: { open: false, time1_open: "", time1_close: "", time2_open: "", time2_close: "" },
        sun: { open: false, time1_open: "", time1_close: "", time2_open: "", time2_close: "" }
      },
      tags: ["Zentral", "Parkplatz"]
    }];
    content = JSON.stringify(template, null, 2);
  } else if (format === 'xml') {
    mimeType = 'application/xml;charset=utf-8';
    content = '<?xml version="1.0" encoding="UTF-8"?>\n';
    content += '<branches>\n';
    content += '  <branch>\n';
    content += '    <name>Muster-Filiale</name>\n';
    content += '    <street>Musterstra\u00dfe 1</street>\n';
    content += '    <zip>10115</zip>\n';
    content += '    <city>Berlin</city>\n';
    content += '    <country>DE</country>\n';
    content += '    <phone>+49 30 123456</phone>\n';
    content += '    <email>info@example.de</email>\n';
    content += '    <website>https://www.example.de</website>\n';
    content += '    <latitude>52.520008</latitude>\n';
    content += '    <longitude>13.404954</longitude>\n';
    content += '    <description>Beschreibung der Filiale</description>\n';
    content += '    <is_active>1</is_active>\n';
    content += '    <opening_hours>\n';
    content += '      <day name="mon" open="1" time1_open="09:00" time1_close="17:00" />\n';
    content += '      <day name="tue" open="1" time1_open="09:00" time1_close="17:00" />\n';
    content += '      <day name="wed" open="1" time1_open="09:00" time1_close="17:00" />\n';
    content += '      <day name="thu" open="1" time1_open="09:00" time1_close="17:00" />\n';
    content += '      <day name="fri" open="1" time1_open="09:00" time1_close="17:00" />\n';
    content += '      <day name="sat" open="0" />\n';
    content += '      <day name="sun" open="0" />\n';
    content += '    </opening_hours>\n';
    content += '    <tags>\n';
    content += '      <tag>Zentral</tag>\n';
    content += '      <tag>Parkplatz</tag>\n';
    content += '    </tags>\n';
    content += '  </branch>\n';
    content += '</branches>';
  }

  var blob = new Blob([content], { type: mimeType });
  var url = window.URL.createObjectURL(blob);
  var a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  window.URL.revokeObjectURL(url);
}

/* Initialize format card highlight */
document.addEventListener('DOMContentLoaded', function() {
  bbfUpdateFormatCards();
});
bbfUpdateFormatCards();
{/literal}
</script>
