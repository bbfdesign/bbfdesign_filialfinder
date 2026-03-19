{* ── Layout Selection Page ── *}
<div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;align-items:start;">

  {* ── Left: Layout Options ── *}
  <div class="bbf-card">
    <div class="bbf-card-title">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="9" y1="21" x2="9" y2="9"/></svg>
      Vorlage ausw&auml;hlen
    </div>

    <div style="display:flex;flex-direction:column;gap:10px;">

      <label class="bbf-layout-option{if $currentLayout|default:'default' === 'default'} selected{/if}" onclick="bbfSelectLayout('default', this)">
        <input type="radio" name="setting_layout_template" value="default" {if $currentLayout|default:'default' === 'default'}checked{/if} style="display:none;">
        <span class="bbf-radio-dot"></span>
        <div>
          <div class="bbf-layout-name">Karte &amp; Liste</div>
          <div class="bbf-layout-desc">Filial-Liste links, interaktive Karte rechts. Klick auf Filiale zoomt auf Marker.</div>
        </div>
      </label>

      <label class="bbf-layout-option{if $currentLayout === 'map_only'} selected{/if}" onclick="bbfSelectLayout('map_only', this)">
        <input type="radio" name="setting_layout_template" value="map_only" {if $currentLayout === 'map_only'}checked{/if} style="display:none;">
        <span class="bbf-radio-dot"></span>
        <div>
          <div class="bbf-layout-name">Nur Karte</div>
          <div class="bbf-layout-desc">Vollbreite Karte mit allen Filialen als Marker. Klick &ouml;ffnet Info-Window.</div>
        </div>
      </label>

      <label class="bbf-layout-option{if $currentLayout === 'grid'} selected{/if}" onclick="bbfSelectLayout('grid', this)">
        <input type="radio" name="setting_layout_template" value="grid" {if $currentLayout === 'grid'}checked{/if} style="display:none;">
        <span class="bbf-radio-dot"></span>
        <div>
          <div class="bbf-layout-name">Grid / Kachel-Ansicht</div>
          <div class="bbf-layout-desc">Filialen als Cards in responsivem Grid (2&ndash;4 Spalten).</div>
        </div>
      </label>

      <label class="bbf-layout-option{if $currentLayout === 'accordion'} selected{/if}" onclick="bbfSelectLayout('accordion', this)">
        <input type="radio" name="setting_layout_template" value="accordion" {if $currentLayout === 'accordion'}checked{/if} style="display:none;">
        <span class="bbf-radio-dot"></span>
        <div>
          <div class="bbf-layout-name">Akkordeon / Kompakt</div>
          <div class="bbf-layout-desc">Einklappbare Listenansicht. Platzsparend f&uuml;r viele Standorte.</div>
        </div>
      </label>

      <label class="bbf-layout-option{if $currentLayout === 'table'} selected{/if}" onclick="bbfSelectLayout('table', this)">
        <input type="radio" name="setting_layout_template" value="table" {if $currentLayout === 'table'}checked{/if} style="display:none;">
        <span class="bbf-radio-dot"></span>
        <div>
          <div class="bbf-layout-name">Tabellarisch</div>
          <div class="bbf-layout-desc">Responsive Tabelle mit allen Filialen, sortierbar nach Spalten.</div>
        </div>
      </label>

    </div>

    <div style="margin-top:20px;">
      <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveLayout()">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
        Vorlage speichern
      </button>
    </div>
  </div>

  {* ── Right: Live Preview ── *}
  <div class="bbf-card" style="position:sticky;top:20px;">
    <div class="bbf-card-title">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
      Vorschau
    </div>
    <div id="bbf-layout-preview" style="min-height:300px;border:1px solid var(--bbf-border);border-radius:var(--bbf-card-radius);padding:16px;background:#fafafa;overflow:hidden;">
      <p class="bbf-text-muted bbf-text-center">W&auml;hle eine Vorlage aus</p>
    </div>
  </div>

</div>

<script>
{literal}
var bbfLayoutPreviews = {
  'default': '<div style="display:flex;gap:12px;font-family:inherit;font-size:13px;"><div style="flex:0 0 200px;display:flex;flex-direction:column;gap:8px;"><div style="border-left:3px solid #db2e87;padding:10px 12px;background:#fff;border-radius:6px;border:1px solid #eee;cursor:pointer;transition:box-shadow 0.2s;" onmouseover="this.style.boxShadow=\'0 2px 8px rgba(0,0,0,0.1)\'" onmouseout="this.style.boxShadow=\'none\'"><strong style="font-size:12px;">God of Games Hof</strong><br><span style="color:#888;font-size:11px;">Lorenzstraße 14, 95028 Hof</span><br><span style="color:#888;font-size:11px;">Tel: 09281 1446128</span><br><span style="background:#e8f5e9;color:#2d8a4e;font-size:10px;padding:1px 6px;border-radius:8px;display:inline-block;margin-top:4px;">● Geöffnet</span></div><div style="border-left:3px solid #db2e87;padding:10px 12px;background:#fff;border-radius:6px;border:1px solid #eee;"><strong style="font-size:12px;">GoG Point Plauen</strong><br><span style="color:#888;font-size:11px;">Postplatz 5, 08523 Plauen</span><br><span style="background:#fce4e4;color:#c0392b;font-size:10px;padding:1px 6px;border-radius:8px;display:inline-block;margin-top:4px;">● Geschlossen</span></div></div><div style="flex:1;background:linear-gradient(135deg,#e8f0fe,#d4e4f7);border-radius:8px;display:flex;align-items:center;justify-content:center;color:#5a7ca8;font-size:12px;min-height:180px;border:1px solid #d0dce8;">🗺 Kartenansicht</div></div>',

  'map_only': '<div style="background:linear-gradient(135deg,#e8f0fe,#d4e4f7);border-radius:8px;display:flex;align-items:center;justify-content:center;color:#5a7ca8;font-size:13px;min-height:240px;border:1px solid #d0dce8;">🗺 Vollbreite Karte mit Markern</div>',

  'grid': '<div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;font-size:12px;"><div style="border:1px solid #eee;border-radius:8px;overflow:hidden;background:#fff;"><div style="background:#f0f2f5;height:50px;"></div><div style="padding:10px;"><strong>God of Games Hof</strong><br><span style="color:#888;font-size:11px;">95028 Hof</span><br><span style="background:#e8f5e9;color:#2d8a4e;font-size:10px;padding:1px 6px;border-radius:8px;display:inline-block;margin-top:4px;">● Geöffnet</span><br><button style="margin-top:6px;font-size:10px;padding:3px 8px;border:1px solid #ddd;border-radius:4px;background:#fff;cursor:pointer;">Details</button></div></div><div style="border:1px solid #eee;border-radius:8px;overflow:hidden;background:#fff;"><div style="background:#f0f2f5;height:50px;"></div><div style="padding:10px;"><strong>GoG Point Plauen</strong><br><span style="color:#888;font-size:11px;">08523 Plauen</span><br><span style="background:#fce4e4;color:#c0392b;font-size:10px;padding:1px 6px;border-radius:8px;display:inline-block;margin-top:4px;">● Geschlossen</span><br><button style="margin-top:6px;font-size:10px;padding:3px 8px;border:1px solid #ddd;border-radius:4px;background:#fff;cursor:pointer;">Details</button></div></div></div>',

  'accordion': '<div style="font-size:12px;"><div style="border:1px solid #eee;border-radius:8px 8px 0 0;"><div style="padding:10px 14px;font-weight:600;display:flex;justify-content:space-between;align-items:center;border-left:3px solid #db2e87;cursor:pointer;background:#fafafa;">God of Games Hof <span style="background:#e8f5e9;color:#2d8a4e;font-size:10px;padding:1px 6px;border-radius:8px;">● Geöffnet</span></div><div style="padding:10px 14px;border-top:1px solid #eee;color:#666;font-size:11px;">Lorenzstraße 14, 95028 Hof<br>Tel: 09281 1446128<br>Mo-Fr: 10:00–19:00</div></div><div style="border:1px solid #eee;border-top:none;border-radius:0 0 8px 8px;"><div style="padding:10px 14px;font-weight:600;display:flex;justify-content:space-between;align-items:center;border-left:3px solid #db2e87;cursor:pointer;background:#fafafa;">GoG Point Plauen <span style="background:#fce4e4;color:#c0392b;font-size:10px;padding:1px 6px;border-radius:8px;">● Geschlossen</span></div></div></div>',

  'table': '<table style="width:100%;border-collapse:collapse;font-size:11px;"><thead><tr style="background:#db2e87;color:#fff;"><th style="padding:6px 10px;text-align:left;font-size:10px;text-transform:uppercase;letter-spacing:0.04em;">Name</th><th style="padding:6px 10px;text-align:left;font-size:10px;text-transform:uppercase;">Adresse</th><th style="padding:6px 10px;text-align:left;font-size:10px;text-transform:uppercase;">Telefon</th><th style="padding:6px 10px;text-align:left;font-size:10px;text-transform:uppercase;">Status</th></tr></thead><tbody><tr style="border-bottom:1px solid #eee;"><td style="padding:6px 10px;font-weight:600;">God of Games Hof</td><td style="padding:6px 10px;color:#666;">Lorenzstr. 14, 95028 Hof</td><td style="padding:6px 10px;color:#666;">09281 1446128</td><td style="padding:6px 10px;"><span style="background:#e8f5e9;color:#2d8a4e;font-size:10px;padding:1px 6px;border-radius:8px;">● Geöffnet</span></td></tr><tr style="background:#f9f9f9;"><td style="padding:6px 10px;font-weight:600;">GoG Point Plauen</td><td style="padding:6px 10px;color:#666;">Postplatz 5, 08523 Plauen</td><td style="padding:6px 10px;color:#666;">03741 5987412</td><td style="padding:6px 10px;"><span style="background:#fce4e4;color:#c0392b;font-size:10px;padding:1px 6px;border-radius:8px;">● Geschlossen</span></td></tr></tbody></table>'
};

function bbfSelectLayout(key, el) {
  document.querySelectorAll('.bbf-layout-option').forEach(function(o) { o.classList.remove('selected'); });
  el.classList.add('selected');
  el.querySelector('input[type="radio"]').checked = true;
  document.getElementById('bbf-layout-preview').innerHTML = bbfLayoutPreviews[key] || '<p class="bbf-text-muted">Keine Vorschau</p>';
}

// Load preview for currently selected layout
(function() {
  var selected = document.querySelector('input[name="setting_layout_template"]:checked');
  if (selected) {
    document.getElementById('bbf-layout-preview').innerHTML = bbfLayoutPreviews[selected.value] || '';
  }
})();
{/literal}
</script>
