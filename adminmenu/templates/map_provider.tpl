<form id="bbf-map-provider-form">

  {* ── Card 1: Kartenanbieter wählen ── *}
  <div class="bbf-card">
    <div class="bbf-card-title">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/><line x1="8" y1="2" x2="8" y2="18"/><line x1="16" y1="6" x2="16" y2="22"/></svg>
      Kartenanbieter wählen
    </div>

    <div class="bbf-grid-2">

      {* Google Maps *}
      <label class="bbf-layout-option{if $allSettings.map_provider|default:'osm' eq 'google'} selected{/if}" onclick="bbfSelectProvider(this, 'google')">
        <input type="radio" name="setting_map_provider" value="google"{if $allSettings.map_provider|default:'osm' eq 'google'} checked{/if}>
        <span class="bbf-radio-dot"></span>
        <div>
          <div class="bbf-layout-name">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: -2px; margin-right: 4px;"><polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/><line x1="8" y1="2" x2="8" y2="18"/><line x1="16" y1="6" x2="16" y2="22"/></svg>
            Google Maps
          </div>
          <div class="bbf-layout-desc">Erfordert einen gültigen Google Maps API-Key. Bietet erweiterte Funktionen wie Street View, individuelle Kartenstile und Satellitendarstellung.</div>
        </div>
      </label>

      {* OpenStreetMap *}
      <label class="bbf-layout-option{if $allSettings.map_provider|default:'osm' eq 'osm'} selected{/if}" onclick="bbfSelectProvider(this, 'osm')">
        <input type="radio" name="setting_map_provider" value="osm"{if $allSettings.map_provider|default:'osm' eq 'osm'} checked{/if}>
        <span class="bbf-radio-dot"></span>
        <div>
          <div class="bbf-layout-name">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: -2px; margin-right: 4px;"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
            OpenStreetMap (Leaflet.js)
          </div>
          <div class="bbf-layout-desc">Kostenlos und ohne API-Key nutzbar. Basiert auf Leaflet.js mit verschiedenen Tile-Servern zur Auswahl.</div>
        </div>
      </label>

    </div>
  </div>

  {* ── Card 2: Google Maps Einstellungen ── *}
  <div class="bbf-card" id="bbf-google-settings" style="display:{if $allSettings.map_provider|default:'osm' eq 'google'}block{else}none{/if}">
    <div class="bbf-card-title">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
      Google Maps Einstellungen
    </div>

    {* API-Key *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">API-Key</label>
      <div class="bbf-flex bbf-gap-8">
        <input type="text" id="bbf-google-api-key" name="setting_google_api_key" class="bbf-form-control" value="{$allSettings.google_api_key|default:''|escape:'html'}" placeholder="AIzaSy...">
        <button type="button" class="bbf-btn bbf-btn-secondary" onclick="bbfTestApiKey()">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
          API-Key testen
        </button>
      </div>
      <p class="bbf-form-hint">Den API-Key finden Sie in der Google Cloud Console unter "APIs & Dienste".</p>
    </div>

    {* Karten-Typ *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Karten-Typ</label>
      <div class="bbf-flex bbf-gap-16" style="flex-wrap: wrap;">
        <label class="bbf-flex bbf-gap-8" style="cursor: pointer;">
          <input type="radio" name="setting_google_map_type" value="roadmap"{if $allSettings.google_map_type|default:'roadmap' eq 'roadmap'} checked{/if}> Straßenkarte
        </label>
        <label class="bbf-flex bbf-gap-8" style="cursor: pointer;">
          <input type="radio" name="setting_google_map_type" value="satellite"{if $allSettings.google_map_type|default:'roadmap' eq 'satellite'} checked{/if}> Satellit
        </label>
        <label class="bbf-flex bbf-gap-8" style="cursor: pointer;">
          <input type="radio" name="setting_google_map_type" value="terrain"{if $allSettings.google_map_type|default:'roadmap' eq 'terrain'} checked{/if}> Gelände
        </label>
        <label class="bbf-flex bbf-gap-8" style="cursor: pointer;">
          <input type="radio" name="setting_google_map_type" value="hybrid"{if $allSettings.google_map_type|default:'roadmap' eq 'hybrid'} checked{/if}> Hybrid
        </label>
      </div>
    </div>

    {* Gestylte Karte *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Gestylte Karte</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_google_styled_map" value="1" id="bbf-styled-map-toggle"{if $allSettings.google_styled_map|default:'0' eq '1'} checked{/if} onchange="document.getElementById('bbf-style-json-group').style.display = this.checked ? 'block' : 'none'">
          <span class="bbf-toggle-slider"></span>
        </label>
        Benutzerdefiniertes Karten-Styling aktivieren
      </label>
    </div>

    {* JSON-Style *}
    <div class="bbf-form-group" id="bbf-style-json-group" style="display:{if $allSettings.google_styled_map|default:'0' eq '1'}block{else}none{/if}">
      <label class="bbf-form-label">JSON-Style</label>
      <textarea name="setting_google_map_style_json" class="bbf-form-control" rows="8" placeholder='[{ldelim}"featureType": "all", "stylers": [{ldelim}"saturation": -100{rdelim}]{rdelim}]'>{$allSettings.google_map_style_json|default:''|escape:'html'}</textarea>
      <p class="bbf-form-hint">Erstellen Sie Ihren Kartenstil unter <a href="https://mapstyle.withgoogle.com/" target="_blank" rel="noopener">mapstyle.withgoogle.com</a> und fügen Sie den JSON-Code hier ein.</p>
    </div>
  </div>

  {* ── Card 3: OpenStreetMap Einstellungen ── *}
  <div class="bbf-card" id="bbf-osm-settings" style="display:{if $allSettings.map_provider|default:'osm' eq 'osm'}block{else}none{/if}">
    <div class="bbf-card-title">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
      OpenStreetMap Einstellungen
    </div>

    {* Tile-Server *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Tile-Server</label>
      <div style="display: flex; flex-direction: column; gap: 8px;">
        {foreach $tileServers as $serverKey => $server}
          <label class="bbf-layout-option{if $allSettings.osm_tile_server|default:'osm_default' eq $serverKey} selected{/if}" onclick="bbfSelectTileServer(this, '{$serverKey|escape:'javascript'}')">
            <input type="radio" name="setting_osm_tile_server" value="{$serverKey|escape:'html'}"{if $allSettings.osm_tile_server|default:'osm_default' eq $serverKey} checked{/if}>
            <span class="bbf-radio-dot"></span>
            <div>
              <div class="bbf-layout-name">{$server.name|escape:'html'}</div>
              {if isset($server.description)}
                <div class="bbf-layout-desc">{$server.description|escape:'html'}</div>
              {/if}
            </div>
          </label>
        {/foreach}
      </div>
    </div>

    {* MapTiler API-Key *}
    <div class="bbf-form-group" id="bbf-maptiler-key-group" style="display:{if $allSettings.osm_tile_server|default:'osm_default' eq 'maptiler'}block{else}none{/if}">
      <label class="bbf-form-label">MapTiler API-Key</label>
      <input type="text" name="setting_osm_maptiler_api_key" class="bbf-form-control" value="{$allSettings.osm_maptiler_api_key|default:''|escape:'html'}" placeholder="Ihr MapTiler API-Key">
      <p class="bbf-form-hint">Registrieren Sie sich kostenlos bei <a href="https://www.maptiler.com/" target="_blank" rel="noopener">maptiler.com</a> und erstellen Sie einen API-Key.</p>
    </div>

    {* Custom Tile URL *}
    <div class="bbf-form-group" id="bbf-custom-tile-group" style="display:{if $allSettings.osm_tile_server|default:'osm_default' eq 'custom'}block{else}none{/if}">
      <label class="bbf-form-label">Eigene Tile-URL</label>
      <input type="text" name="setting_osm_custom_tile_url" class="bbf-form-control" value="{$allSettings.osm_custom_tile_url|default:''|escape:'html'}" placeholder="https://{ldelim}s{rdelim}.tile.example.com/{ldelim}z{rdelim}/{ldelim}x{rdelim}/{ldelim}y{rdelim}.png">
      <p class="bbf-form-hint">Geben Sie die vollständige Tile-URL mit Platzhaltern {ldelim}s{rdelim}, {ldelim}z{rdelim}, {ldelim}x{rdelim}, {ldelim}y{rdelim} ein.</p>
    </div>
  </div>

  {* ── Card 4: Gemeinsame Kartenoptionen ── *}
  <div class="bbf-card">
    <div class="bbf-card-title">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
      Gemeinsame Kartenoptionen
    </div>

    {* Standard-Zoom *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Standard-Zoom</label>
      <div class="bbf-range-group">
        <input type="range" name="setting_map_default_zoom" min="1" max="20" value="{$allSettings.map_default_zoom|default:14}" data-unit="" oninput="this.parentNode.querySelector('.bbf-range-value').textContent = this.value">
        <span class="bbf-range-value">{$allSettings.map_default_zoom|default:14}</span>
      </div>
    </div>

    {* Max. Zoom *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Max. Zoom</label>
      <div class="bbf-range-group">
        <input type="range" name="setting_map_max_zoom" min="1" max="20" value="{$allSettings.map_max_zoom|default:18}" data-unit="" oninput="this.parentNode.querySelector('.bbf-range-value').textContent = this.value">
        <span class="bbf-range-value">{$allSettings.map_max_zoom|default:18}</span>
      </div>
    </div>

    {* Min. Zoom *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Min. Zoom</label>
      <div class="bbf-range-group">
        <input type="range" name="setting_map_min_zoom" min="1" max="20" value="{$allSettings.map_min_zoom|default:5}" data-unit="" oninput="this.parentNode.querySelector('.bbf-range-value').textContent = this.value">
        <span class="bbf-range-value">{$allSettings.map_min_zoom|default:5}</span>
      </div>
    </div>

    {* Scroll-Zoom *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Scroll-Zoom</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_map_scroll_zoom" value="1"{if $allSettings.map_scroll_zoom|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Zoomen per Mausrad erlauben
      </label>
    </div>

    {* Kartenhöhe *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Kartenhöhe (px)</label>
      <input type="number" name="setting_map_height" class="bbf-form-control" value="{$allSettings.map_height|default:450}" min="200" max="1200" style="max-width: 200px;">
      <p class="bbf-form-hint">Höhe der Karte in Pixeln (200 – 1200).</p>
    </div>

    {* Auto-Zoom *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Auto-Zoom</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_map_auto_zoom" value="1"{if $allSettings.map_auto_zoom|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Karte automatisch an alle Marker anpassen
      </label>
    </div>

    {* Cluster-Marker *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Cluster-Marker</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_map_cluster_markers" value="1"{if $allSettings.map_cluster_markers|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Nahe beieinander liegende Marker gruppieren
      </label>
    </div>

    {* Vollbild-Button *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Vollbild-Button</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_map_fullscreen_btn" value="1"{if $allSettings.map_fullscreen_btn|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Vollbild-Schaltfläche auf der Karte anzeigen
      </label>
    </div>

    {* Straßenansicht (nur Google) *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Straßenansicht (nur Google)</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_map_street_view" value="1"{if $allSettings.map_street_view|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Google Street View Pegman anzeigen
      </label>
    </div>

    {* Routenplanung-Link *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Routenplanung-Link</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_map_route_link" value="1"{if $allSettings.map_route_link|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Link zur Routenplanung in Filial-Details anzeigen
      </label>
    </div>
  </div>

  {* ── Card 5: Marker-Icon ── *}
  <div class="bbf-card">
    <div class="bbf-card-title">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
      Marker-Icon
    </div>

    <div class="bbf-form-group">
      <label class="bbf-form-label">Icon-Typ</label>
      <div class="bbf-flex bbf-gap-16" style="flex-wrap: wrap;">
        <label class="bbf-flex bbf-gap-8" style="cursor: pointer;">
          <input type="radio" name="setting_marker_icon_type" value="svg"{if $allSettings.marker_icon_type|default:'svg' eq 'svg'} checked{/if} onchange="document.getElementById('bbf-marker-color-group').style.display='block';document.getElementById('bbf-custom-marker-group').style.display='none';"> SVG-Pin (Plugin-Farbe)
        </label>
        <label class="bbf-flex bbf-gap-8" style="cursor: pointer;">
          <input type="radio" name="setting_marker_icon_type" value="default"{if $allSettings.marker_icon_type|default:'svg' eq 'default'} checked{/if} onchange="document.getElementById('bbf-marker-color-group').style.display='none';document.getElementById('bbf-custom-marker-group').style.display='none';"> Leaflet Standard
        </label>
        <label class="bbf-flex bbf-gap-8" style="cursor: pointer;">
          <input type="radio" name="setting_marker_icon_type" value="custom"{if $allSettings.marker_icon_type|default:'svg' eq 'custom'} checked{/if} onchange="document.getElementById('bbf-marker-color-group').style.display='none';document.getElementById('bbf-custom-marker-group').style.display='block';"> Eigenes Bild
        </label>
      </div>
    </div>

    <div class="bbf-form-group" id="bbf-marker-color-group" style="display:{if $allSettings.marker_icon_type|default:'svg' eq 'svg'}block{else}none{/if}">
      <label class="bbf-form-label">Marker-Farbe</label>
      <input type="color" name="setting_marker_icon_svg_color" value="{$allSettings.marker_icon_svg_color|default:'#C8B831'}" style="width:60px;height:36px;border:1px solid #ddd;border-radius:4px;cursor:pointer;">
      <p class="bbf-form-hint">Farbe des SVG-Marker-Pins auf der Karte.</p>
    </div>

    <div class="bbf-form-group" id="bbf-custom-marker-group" style="display:{if $allSettings.marker_icon_type|default:'svg' eq 'custom'}block{else}none{/if}">
      <label class="bbf-form-label">Eigenes Marker-Bild URL (PNG/SVG, empfohlen 32x32 bis 64x64)</label>
      <input type="text" name="setting_marker_custom_icon_url" class="bbf-form-control" value="{$allSettings.marker_custom_icon_url|default:''|escape:'html'}" placeholder="https://example.com/marker.png">
      <p class="bbf-form-hint">Vollständige URL zum eigenen Marker-Bild.</p>
    </div>

    <div style="margin-top:12px;padding:12px;background:#f8f9fa;border-radius:6px;">
      <strong>Vorschau:</strong>
      <div style="margin-top:8px;">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 36" width="28" height="42">
          <path d="M12 0C5.4 0 0 5.4 0 12c0 9 12 24 12 24s12-15 12-24C24 5.4 18.6 0 12 0z" fill="{$allSettings.marker_icon_svg_color|default:'#C8B831'}" stroke="#fff" stroke-width="1.5"/>
          <circle cx="12" cy="12" r="5" fill="#fff"/>
        </svg>
        <span style="margin-left:8px;font-size:0.85rem;color:#666;">Aktueller SVG-Pin</span>
      </div>
    </div>
  </div>

  {* ── Save Button ── *}
  <div class="bbf-flex bbf-gap-8" style="justify-content: flex-end;">
    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-map-provider-form', 'map_provider')">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
      Einstellungen speichern
    </button>
  </div>

</form>

<script>
function bbfSelectProvider(el, provider) {
    document.querySelectorAll('#bbf-map-provider-form .bbf-layout-option').forEach(function(opt) {
        if (opt.closest('.bbf-card').querySelector('.bbf-card-title').textContent.trim().indexOf('Kartenanbieter') >= 0) {
            opt.classList.remove('selected');
        }
    });
    el.classList.add('selected');
    var radio = el.querySelector('input[type="radio"]');
    if (radio) radio.checked = true;

    document.getElementById('bbf-google-settings').style.display = (provider === 'google') ? 'block' : 'none';
    document.getElementById('bbf-osm-settings').style.display = (provider === 'osm') ? 'block' : 'none';
}

function bbfSelectTileServer(el, serverKey) {
    el.closest('.bbf-form-group').querySelectorAll('.bbf-layout-option').forEach(function(opt) {
        opt.classList.remove('selected');
    });
    el.classList.add('selected');
    var radio = el.querySelector('input[type="radio"]');
    if (radio) radio.checked = true;

    document.getElementById('bbf-custom-tile-group').style.display = (serverKey === 'custom') ? 'block' : 'none';
    document.getElementById('bbf-maptiler-key-group').style.display = (serverKey === 'maptiler') ? 'block' : 'none';
}
</script>
