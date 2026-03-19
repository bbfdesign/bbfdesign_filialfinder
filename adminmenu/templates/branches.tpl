{* ── Branch List View ── *}
<div id="bbf-branch-list">
  <div class="bbf-card">
    <div class="bbf-flex-between">
      <h2 class="bbf-card-title">Standorte</h2>
      <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfShowBranchForm(0)">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        Neue Filiale anlegen
      </button>
    </div>

    {* ── Bulk Action Bar ── *}
    <div class="bbf-bulk-bar" id="bbf-bulk-bar" style="display:none;">
      <span id="bbf-bulk-count">0</span> ausgew&auml;hlt:
      <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfBulkAction('activate')">Aktivieren</button>
      <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfBulkAction('deactivate')">Deaktivieren</button>
      <button type="button" class="bbf-btn bbf-btn-danger bbf-btn-sm" onclick="bbfBulkAction('delete')">L&ouml;schen</button>
    </div>

    {* ── Table Toolbar ── *}
    <div class="bbf-table-toolbar">
      <div class="bbf-flex bbf-gap-12">
        <input type="text" class="bbf-search-input" id="bbf-branch-search" placeholder="Filiale suchen..." oninput="bbfFilterBranches()">
      </div>
      <div class="bbf-flex bbf-gap-12">
        <label class="bbf-form-label" style="white-space:nowrap;align-self:center;">Pro Seite:</label>
        <select class="bbf-form-control" id="bbf-per-page" onchange="bbfChangePerPage()" style="width:auto;">
          <option value="10">10</option>
          <option value="25" selected>25</option>
          <option value="50">50</option>
          <option value="100">100</option>
        </select>
      </div>
    </div>

    {* ── Branches Table ── *}
    <table class="bbf-table" id="bbf-branch-table">
      <thead>
        <tr>
          <th style="width:40px;">
            <label class="bbf-toggle">
              <input type="checkbox" id="bbf-select-all" onchange="bbfToggleSelectAll(this)">
              <span class="bbf-toggle-slider"></span>
            </label>
          </th>
          <th style="width:70px;">Status</th>
          <th>Name</th>
          <th>Stadt</th>
          <th style="width:100px;">Sortierung</th>
          <th style="width:140px;">Aktionen</th>
        </tr>
      </thead>
      <tbody>
        {if !empty($branches)}
          {foreach $branches as $branch}
            <tr data-branch-id="{$branch->id}">
              <td>
                <label class="bbf-toggle">
                  <input type="checkbox" class="bbf-branch-check" value="{$branch->id}" onchange="bbfUpdateBulkBar()">
                  <span class="bbf-toggle-slider"></span>
                </label>
              </td>
              <td>
                <label class="bbf-toggle">
                  <input type="checkbox" {if $branch->is_active}checked{/if} onchange="bbfToggleBranchStatus({$branch->id}, this)">
                  <span class="bbf-toggle-slider"></span>
                </label>
              </td>
              <td>{$branch->name|escape:'html'}</td>
              <td>{$branch->city|escape:'html'}</td>
              <td>{$branch->sort_order|escape:'html'}</td>
              <td>
                <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm" title="Bearbeiten" onclick="bbfShowBranchForm({$branch->id})">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                </button>
                <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm" title="Duplizieren" onclick="bbfDuplicateBranch({$branch->id})">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                </button>
                <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm bbf-btn-danger" title="L&ouml;schen" onclick="bbfDeleteBranch({$branch->id})">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                </button>
              </td>
            </tr>
          {/foreach}
        {else}
          <tr>
            <td colspan="6" style="text-align:center;padding:40px 0;">
              <p class="bbf-text-muted">Noch keine Filialen vorhanden.</p>
              <button type="button" class="bbf-btn bbf-btn-primary bbf-btn-sm" onclick="bbfShowBranchForm(0)" style="margin-top:12px;">Jetzt erste Filiale anlegen</button>
            </td>
          </tr>
        {/if}
      </tbody>
    </table>

    {* ── Pagination ── *}
    <div class="bbf-pagination" id="bbf-branch-pagination"></div>
  </div>
</div>

{* ── Branch Form View ── *}
<div id="bbf-branch-form" style="display:none;">
  <div class="bbf-card">
    <div class="bbf-flex-between">
      <h2 class="bbf-card-title" id="bbf-branch-form-title">Neue Filiale anlegen</h2>
      <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfHideBranchForm()">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
        Zur&uuml;ck zur Liste
      </button>
    </div>

    <form id="bbf-branch-form-data" onsubmit="event.preventDefault(); bbfSaveBranch();">
      <input type="hidden" id="bbf-field-branch_id" name="branch_id" value="0">

      {* ── Tabs ── *}
      <div class="bbf-tabs">
        <a href="#" class="bbf-tab-link active" data-tab="tab-general" onclick="bbfSwitchTab(event, 'tab-general')">Allgemein</a>
        <a href="#" class="bbf-tab-link" data-tab="tab-contact" onclick="bbfSwitchTab(event, 'tab-contact')">Kontakt &amp; Adresse</a>
        <a href="#" class="bbf-tab-link" data-tab="tab-hours" onclick="bbfSwitchTab(event, 'tab-hours')">&Ouml;ffnungszeiten</a>
        <a href="#" class="bbf-tab-link" data-tab="tab-advanced" onclick="bbfSwitchTab(event, 'tab-advanced')">Erweitert</a>
      </div>

      {* ── Tab: Allgemein ── *}
      <div class="bbf-tab-content active" id="tab-general">
        <div class="bbf-form-group">
          <label class="bbf-form-label" for="bbf-field-name">Name <span style="color:var(--bbf-danger);">*</span></label>
          <input type="text" class="bbf-form-control" id="bbf-field-name" name="name" required placeholder="z.B. Filiale Berlin Mitte">
        </div>

        <div class="bbf-form-group">
          <label class="bbf-form-label" for="bbf-field-description">Beschreibung</label>
          <textarea class="bbf-form-control" id="bbf-field-description" name="description" rows="4" placeholder="Optionale Beschreibung der Filiale..."></textarea>
        </div>

        <div class="bbf-form-group">
          <label class="bbf-form-label">Bild</label>
          <div class="bbf-upload-area" id="bbf-image-upload" onclick="document.getElementById('bbf-field-image').click();" ondragover="event.preventDefault();this.classList.add('bbf-drag-over');" ondragleave="this.classList.remove('bbf-drag-over');" ondrop="event.preventDefault();this.classList.remove('bbf-drag-over');bbfHandleImageDrop(event);">
            <input type="file" id="bbf-field-image" name="image" accept="image/*" style="display:none;" onchange="bbfPreviewImage(this);">
            <div id="bbf-image-preview" style="display:none;">
              <img id="bbf-image-preview-img" src="" alt="Vorschau" style="max-width:200px;max-height:150px;">
              <br>
              <button type="button" class="bbf-btn bbf-btn-danger bbf-btn-sm" onclick="event.stopPropagation();bbfRemoveImage();" style="margin-top:8px;">Bild entfernen</button>
            </div>
            <div id="bbf-image-placeholder">
              <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
              <p style="margin-top:8px;">Bild hierher ziehen oder klicken zum Ausw&auml;hlen</p>
            </div>
          </div>
        </div>

        <div class="bbf-form-row">
          <div class="bbf-form-group">
            <label class="bbf-form-label" for="bbf-field-is_active">Aktiv</label>
            <label class="bbf-toggle">
              <input type="checkbox" id="bbf-field-is_active" name="is_active" value="1" checked>
              <span class="bbf-toggle-slider"></span>
            </label>
            <span class="bbf-form-hint">Filiale im Frontend anzeigen</span>
          </div>

          <div class="bbf-form-group">
            <label class="bbf-form-label" for="bbf-field-sort_order">Sortierung</label>
            <input type="number" class="bbf-form-control" id="bbf-field-sort_order" name="sort_order" value="0" min="0" step="1" style="width:120px;">
            <span class="bbf-form-hint">Niedrigere Werte werden zuerst angezeigt</span>
          </div>
        </div>
      </div>

      {* ── Tab: Kontakt & Adresse ── *}
      <div class="bbf-tab-content" id="tab-contact">
        <div class="bbf-form-group">
          <label class="bbf-form-label" for="bbf-field-street">Stra&szlig;e &amp; Hausnummer</label>
          <input type="text" class="bbf-form-control" id="bbf-field-street" name="street" placeholder="Musterstra&szlig;e 1">
        </div>

        <div class="bbf-form-row">
          <div class="bbf-form-group">
            <label class="bbf-form-label" for="bbf-field-zip">PLZ</label>
            <input type="text" class="bbf-form-control" id="bbf-field-zip" name="zip" placeholder="10115">
          </div>
          <div class="bbf-form-group">
            <label class="bbf-form-label" for="bbf-field-city">Stadt</label>
            <input type="text" class="bbf-form-control" id="bbf-field-city" name="city" placeholder="Berlin">
          </div>
        </div>

        <div class="bbf-form-group">
          <label class="bbf-form-label" for="bbf-field-country">Land</label>
          <select class="bbf-form-control" id="bbf-field-country" name="country">
            <option value="">-- Land w&auml;hlen --</option>
            {if !empty($countries)}
              {foreach $countries as $code => $countryName}
                <option value="{$code|escape:'html'}">{$countryName|escape:'html'}</option>
              {/foreach}
            {/if}
          </select>
        </div>

        <div class="bbf-form-row">
          <div class="bbf-form-group">
            <label class="bbf-form-label" for="bbf-field-phone">Telefon</label>
            <input type="text" class="bbf-form-control" id="bbf-field-phone" name="phone" placeholder="+49 30 123456">
          </div>
          <div class="bbf-form-group">
            <label class="bbf-form-label" for="bbf-field-email">E-Mail</label>
            <input type="email" class="bbf-form-control" id="bbf-field-email" name="email" placeholder="filiale@example.de">
          </div>
        </div>

        <div class="bbf-form-group">
          <label class="bbf-form-label" for="bbf-field-website">Website</label>
          <input type="url" class="bbf-form-control" id="bbf-field-website" name="website" placeholder="https://www.example.de">
        </div>

        <div class="bbf-form-row">
          <div class="bbf-form-group">
            <label class="bbf-form-label" for="bbf-field-latitude">Breitengrad (Latitude)</label>
            <input type="text" class="bbf-form-control" id="bbf-field-latitude" name="latitude" placeholder="52.520008">
          </div>
          <div class="bbf-form-group">
            <label class="bbf-form-label" for="bbf-field-longitude">L&auml;ngengrad (Longitude)</label>
            <input type="text" class="bbf-form-control" id="bbf-field-longitude" name="longitude" placeholder="13.404954">
          </div>
        </div>

        <div class="bbf-form-group">
          <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfGeocode()">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="22" y1="12" x2="18" y2="12"/><line x1="6" y1="12" x2="2" y2="12"/><line x1="12" y1="6" x2="12" y2="2"/><line x1="12" y1="22" x2="12" y2="18"/></svg>
            Koordinaten aus Adresse ermitteln
          </button>
          <span class="bbf-form-hint">Ermittelt Latitude/Longitude automatisch anhand der eingegebenen Adresse.</span>
        </div>

        <div class="bbf-form-group">
          <label class="bbf-form-label">Kartenvorschau</label>
          <div id="bbf-mini-map" style="width:100%;height:250px;background:var(--bbf-bg-secondary);border:1px solid var(--bbf-border);border-radius:var(--bbf-radius);display:flex;align-items:center;justify-content:center;">
            <span class="bbf-text-muted">Koordinaten eingeben, um Vorschau zu laden</span>
          </div>
        </div>
      </div>

      {* ── Tab: Öffnungszeiten ── *}
      <div class="bbf-tab-content" id="tab-hours">
        <div class="bbf-flex-between" style="margin-bottom:16px;">
          <h3 style="margin:0;">Regul&auml;re &Ouml;ffnungszeiten</h3>
          <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfCopyMondayToAll()">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
            Montag auf alle Tage &uuml;bernehmen
          </button>
        </div>

        {assign var="dayNames" value=["Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"]}
        {assign var="dayKeys" value=["mon","tue","wed","thu","fri","sat","sun"]}

        {foreach $dayNames as $idx => $dayName}
          <div class="bbf-hours-row" data-day="{$dayKeys[$idx]}" style="display:flex;align-items:center;gap:12px;padding:10px 0;border-bottom:1px solid var(--bbf-border);">
            <div style="width:120px;font-weight:500;">{$dayName}</div>
            <div style="width:60px;">
              <label class="bbf-toggle">
                <input type="checkbox" id="bbf-hours-open-{$dayKeys[$idx]}" name="hours_open_{$dayKeys[$idx]}" value="1" {if $idx < 5}checked{/if} onchange="bbfToggleDayHours('{$dayKeys[$idx]}', this)">
                <span class="bbf-toggle-slider"></span>
              </label>
            </div>
            <div class="bbf-hours-times" id="bbf-hours-times-{$dayKeys[$idx]}" style="display:flex;flex-wrap:wrap;gap:8px;align-items:center;{if $idx >= 5}opacity:0.4;pointer-events:none;{/if}">
              <input type="time" class="bbf-form-control" id="bbf-hours-open-time-1-{$dayKeys[$idx]}" name="hours_open_time_1_{$dayKeys[$idx]}" value="09:00" style="width:130px;">
              <span>&ndash;</span>
              <input type="time" class="bbf-form-control" id="bbf-hours-close-time-1-{$dayKeys[$idx]}" name="hours_close_time_1_{$dayKeys[$idx]}" value="17:00" style="width:130px;">
              <span style="margin:0 4px;color:var(--bbf-text-muted);">|</span>
              <input type="time" class="bbf-form-control" id="bbf-hours-open-time-2-{$dayKeys[$idx]}" name="hours_open_time_2_{$dayKeys[$idx]}" value="" style="width:130px;" placeholder="--:--">
              <span>&ndash;</span>
              <input type="time" class="bbf-form-control" id="bbf-hours-close-time-2-{$dayKeys[$idx]}" name="hours_close_time_2_{$dayKeys[$idx]}" value="" style="width:130px;" placeholder="--:--">
            </div>
          </div>
        {/foreach}

        {* ── Special Days ── *}
        <div style="margin-top:24px;">
          <div class="bbf-flex-between" style="margin-bottom:12px;">
            <h3 style="margin:0;">Sondertage / Feiertage</h3>
            <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfAddSpecialDayRow()">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
              Sondertag hinzuf&uuml;gen
            </button>
          </div>
          <p class="bbf-form-hint" style="margin-bottom:12px;">Sondertage &uuml;berschreiben die regul&auml;ren &Ouml;ffnungszeiten am jeweiligen Datum.</p>
          <div id="bbf-special-days">
            {* Special day rows are added dynamically *}
          </div>
          <template id="bbf-special-day-template">
            <div class="bbf-special-day-row" style="display:flex;align-items:center;gap:12px;padding:10px 0;border-bottom:1px solid var(--bbf-border);">
              <input type="date" class="bbf-form-control" name="special_date[]" style="width:160px;">
              <input type="text" class="bbf-form-control" name="special_label[]" placeholder="Bezeichnung (z.B. Weihnachten)" style="flex:1;">
              <label class="bbf-toggle" title="Ge&ouml;ffnet">
                <input type="checkbox" name="special_open[]" value="1">
                <span class="bbf-toggle-slider"></span>
              </label>
              <input type="time" class="bbf-form-control" name="special_open_time[]" style="width:130px;">
              <span>&ndash;</span>
              <input type="time" class="bbf-form-control" name="special_close_time[]" style="width:130px;">
              <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm bbf-btn-danger" title="Entfernen" onclick="this.closest('.bbf-special-day-row').remove();">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
              </button>
            </div>
          </template>
        </div>
      </div>

      {* ── Tab: Erweitert ── *}
      <div class="bbf-tab-content" id="tab-advanced">
        <div class="bbf-form-group">
          <label class="bbf-form-label" for="bbf-field-google_place_id">Google Place ID</label>
          <input type="text" class="bbf-form-control" id="bbf-field-google_place_id" name="google_place_id" placeholder="ChIJN1t_tDeuEmsRUsoyG83frY4">
          <span class="bbf-form-hint">Optionale Google Place ID f&uuml;r erweiterte Kartenfunktionen und Bewertungen.</span>
        </div>

        <div class="bbf-form-group">
          <label class="bbf-form-label" for="bbf-field-marker_color">Marker-Farbe</label>
          <div style="display:flex;align-items:center;gap:12px;">
            <input type="color" id="bbf-field-marker_color" name="marker_color" value="#e74c3c" style="width:48px;height:36px;border:1px solid var(--bbf-border);border-radius:var(--bbf-radius);cursor:pointer;padding:2px;">
            <input type="text" class="bbf-form-control" id="bbf-field-marker_color_hex" value="#e74c3c" style="width:120px;" oninput="document.getElementById('bbf-field-marker_color').value=this.value;" onchange="document.getElementById('bbf-field-marker_color').value=this.value;">
          </div>
          <span class="bbf-form-hint">Farbe des Karten-Markers f&uuml;r diese Filiale.</span>
        </div>

        <div class="bbf-form-group">
          <label class="bbf-form-label" for="bbf-field-css_class">CSS-Klasse</label>
          <input type="text" class="bbf-form-control" id="bbf-field-css_class" name="css_class" placeholder="meine-filiale">
          <span class="bbf-form-hint">Zus&auml;tzliche CSS-Klasse f&uuml;r individuelles Styling dieser Filiale.</span>
        </div>
      </div>

      {* ── Form Actions ── *}
      <div class="bbf-form-group" style="display:flex;gap:12px;margin-top:24px;padding-top:20px;border-top:1px solid var(--bbf-border);">
        <button type="submit" class="bbf-btn bbf-btn-primary">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
          Speichern
        </button>
        <button type="button" class="bbf-btn bbf-btn-secondary" onclick="bbfHideBranchForm()">Abbrechen</button>
      </div>
    </form>
  </div>
</div>

<script>
function bbfSwitchTab(e, tabId) {
  e.preventDefault();
  document.querySelectorAll('#bbf-branch-form .bbf-tab-link').forEach(function(el) { el.classList.remove('active'); });
  document.querySelectorAll('#bbf-branch-form .bbf-tab-content').forEach(function(el) { el.classList.remove('active'); });
  e.currentTarget.classList.add('active');
  document.getElementById(tabId).classList.add('active');
}

function bbfShowBranchForm(id) {
  document.getElementById('bbf-branch-list').style.display = 'none';
  document.getElementById('bbf-branch-form').style.display = '';
  document.getElementById('bbf-field-branch_id').value = id || 0;
  document.getElementById('bbf-branch-form-title').textContent = id ? 'Filiale bearbeiten' : 'Neue Filiale anlegen';
  if (id) {
    bbfLoadBranchData(id);
  } else {
    document.getElementById('bbf-branch-form-data').reset();
    document.getElementById('bbf-field-branch_id').value = 0;
    document.getElementById('bbf-image-preview').style.display = 'none';
    document.getElementById('bbf-image-placeholder').style.display = '';
  }
  document.querySelectorAll('#bbf-branch-form .bbf-tab-link')[0].click();
}

function bbfHideBranchForm() {
  document.getElementById('bbf-branch-form').style.display = 'none';
  document.getElementById('bbf-branch-list').style.display = '';
}

function bbfSaveBranch() {
  var form = document.getElementById('bbf-branch-form-data');
  var formData = new FormData(form);
  formData.append('action', 'saveBranch');
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success) {
        bbfHideBranchForm();
        if (typeof getPage === 'function') getPage('branches');
      } else {
        alert(data.message || 'Fehler beim Speichern.');
      }
    })
    .catch(function() { alert('Fehler beim Speichern.'); });
}

function bbfLoadBranchData(id) {
  var formData = new FormData();
  formData.append('action', 'getBranch');
  formData.append('branch_id', id);
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success && data.branch) {
        var b = data.branch;
        var fields = ['name','description','street','zip','city','country','phone','email','website','latitude','longitude','google_place_id','css_class','sort_order'];
        fields.forEach(function(f) {
          var el = document.getElementById('bbf-field-' + f);
          if (el) el.value = b[f] || '';
        });
        document.getElementById('bbf-field-is_active').checked = !!b.is_active;
        if (b.marker_color) {
          document.getElementById('bbf-field-marker_color').value = b.marker_color;
          document.getElementById('bbf-field-marker_color_hex').value = b.marker_color;
        }
      }
    });
}

function bbfGeocode() {
  var street = document.getElementById('bbf-field-street').value;
  var zip = document.getElementById('bbf-field-zip').value;
  var city = document.getElementById('bbf-field-city').value;
  var country = document.getElementById('bbf-field-country').value;
  var address = [street, zip + ' ' + city, country].filter(Boolean).join(', ');

  if (!address.trim()) { alert('Bitte zuerst eine Adresse eingeben.'); return; }

  var formData = new FormData();
  formData.append('action', 'geocode');
  formData.append('address', address);
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success && data.lat && data.lng) {
        document.getElementById('bbf-field-latitude').value = data.lat;
        document.getElementById('bbf-field-longitude').value = data.lng;
        bbfUpdateMiniMap(data.lat, data.lng);
      } else {
        alert(data.message || 'Geocoding fehlgeschlagen.');
      }
    })
    .catch(function() { alert('Geocoding fehlgeschlagen.'); });
}

function bbfUpdateMiniMap(lat, lng) {
  var container = document.getElementById('bbf-mini-map');
  container.innerHTML = '<img src="https://maps.googleapis.com/maps/api/staticmap?center=' + lat + ',' + lng + '&zoom=15&size=600x250&markers=color:red%7C' + lat + ',' + lng + '&key=" alt="Kartenvorschau" style="width:100%;height:100%;object-fit:cover;border-radius:var(--bbf-radius);">';
}

function bbfCopyMondayToAll() {
  var days = ['tue','wed','thu','fri','sat','sun'];
  var monOpen = document.getElementById('bbf-hours-open-mon').checked;
  var monT1Open = document.getElementById('bbf-hours-open-time-1-mon').value;
  var monT1Close = document.getElementById('bbf-hours-close-time-1-mon').value;
  var monT2Open = document.getElementById('bbf-hours-open-time-2-mon').value;
  var monT2Close = document.getElementById('bbf-hours-close-time-2-mon').value;

  days.forEach(function(day) {
    document.getElementById('bbf-hours-open-' + day).checked = monOpen;
    document.getElementById('bbf-hours-open-time-1-' + day).value = monT1Open;
    document.getElementById('bbf-hours-close-time-1-' + day).value = monT1Close;
    document.getElementById('bbf-hours-open-time-2-' + day).value = monT2Open;
    document.getElementById('bbf-hours-close-time-2-' + day).value = monT2Close;
    bbfToggleDayHours(day, document.getElementById('bbf-hours-open-' + day));
  });
}

function bbfToggleDayHours(day, el) {
  var container = document.getElementById('bbf-hours-times-' + day);
  if (el.checked) {
    container.style.opacity = '1';
    container.style.pointerEvents = '';
  } else {
    container.style.opacity = '0.4';
    container.style.pointerEvents = 'none';
  }
}

function bbfAddSpecialDayRow() {
  var template = document.getElementById('bbf-special-day-template');
  var clone = template.content.cloneNode(true);
  document.getElementById('bbf-special-days').appendChild(clone);
}

function bbfToggleSelectAll(el) {
  document.querySelectorAll('.bbf-branch-check').forEach(function(cb) {
    cb.checked = el.checked;
  });
  bbfUpdateBulkBar();
}

function bbfUpdateBulkBar() {
  var checked = document.querySelectorAll('.bbf-branch-check:checked').length;
  var bar = document.getElementById('bbf-bulk-bar');
  bar.style.display = checked > 0 ? '' : 'none';
  document.getElementById('bbf-bulk-count').textContent = checked;
}

function bbfBulkAction(action) {
  var ids = [];
  document.querySelectorAll('.bbf-branch-check:checked').forEach(function(cb) {
    ids.push(cb.value);
  });
  if (!ids.length) return;
  if (action === 'delete' && !confirm('Ausgew\u00e4hlte Filialen wirklich l\u00f6schen?')) return;

  var formData = new FormData();
  formData.append('action', 'bulkBranch');
  formData.append('bulkAction', action);
  formData.append('ids', JSON.stringify(ids));
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success && typeof getPage === 'function') getPage('branches');
    });
}

function bbfToggleBranchStatus(id, el) {
  var formData = new FormData();
  formData.append('action', 'toggleBranchStatus');
  formData.append('branch_id', id);
  formData.append('is_active', el.checked ? 1 : 0);
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (!data.success) el.checked = !el.checked;
    });
}

function bbfDeleteBranch(id) {
  if (!confirm('Filiale wirklich l\u00f6schen?')) return;

  var formData = new FormData();
  formData.append('action', 'deleteBranch');
  formData.append('branch_id', id);
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success && typeof getPage === 'function') getPage('branches');
    });
}

function bbfDuplicateBranch(id) {
  var formData = new FormData();
  formData.append('action', 'duplicateBranch');
  formData.append('branch_id', id);
  formData.append('is_ajax', '1');
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success && typeof getPage === 'function') getPage('branches');
    });
}

function bbfFilterBranches() {
  var q = document.getElementById('bbf-branch-search').value.toLowerCase();
  document.querySelectorAll('#bbf-branch-table tbody tr').forEach(function(row) {
    var text = row.textContent.toLowerCase();
    row.style.display = text.indexOf(q) !== -1 ? '' : 'none';
  });
}

function bbfChangePerPage() {
  if (typeof getPage === 'function') getPage('branches');
}

function bbfPreviewImage(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function(e) {
      document.getElementById('bbf-image-preview-img').src = e.target.result;
      document.getElementById('bbf-image-preview').style.display = '';
      document.getElementById('bbf-image-placeholder').style.display = 'none';
    };
    reader.readAsDataURL(input.files[0]);
  }
}

function bbfRemoveImage() {
  document.getElementById('bbf-field-image').value = '';
  document.getElementById('bbf-image-preview').style.display = 'none';
  document.getElementById('bbf-image-placeholder').style.display = '';
}

function bbfHandleImageDrop(e) {
  var dt = e.dataTransfer;
  if (dt.files && dt.files.length) {
    document.getElementById('bbf-field-image').files = dt.files;
    bbfPreviewImage(document.getElementById('bbf-field-image'));
  }
}

document.getElementById('bbf-field-marker_color').addEventListener('input', function() {
  document.getElementById('bbf-field-marker_color_hex').value = this.value;
});
</script>