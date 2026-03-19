{* ── Layout Selection Page ── *}
<div class="bbf-grid-2">

  {* ── Left: Layout Options ── *}
  <div>
    <div class="bbf-card">
      <h2 class="bbf-card-title">Vorlage ausw&auml;hlen</h2>

      <form id="bbf-layout-form" onsubmit="event.preventDefault(); bbfSaveLayout();">
        <div class="bbf-layout-options">

          {if !empty($layouts)}
            {foreach $layouts as $key => $layout}
              <div class="bbf-layout-option{if $currentLayout === $key} active{/if}" data-layout="{$key|escape:'html'}" onclick="bbfSelectLayout('{$key|escape:'javascript'}', this);">
                <label style="display:flex;align-items:flex-start;gap:12px;cursor:pointer;width:100%;">
                  <input type="radio" name="layout" value="{$key|escape:'html'}" {if $currentLayout === $key}checked{/if} style="margin-top:3px;">
                  <div>
                    <strong>{$layout.name|escape:'html'}</strong>
                    <p class="bbf-form-hint" style="margin:4px 0 0;">{$layout.description|escape:'html'}</p>
                  </div>
                </label>
              </div>
            {/foreach}
          {else}
            {* Fallback: hardcoded layout options *}
            <div class="bbf-layout-option{if $currentLayout === 'default'} active{/if}" data-layout="default" onclick="bbfSelectLayout('default', this);">
              <label style="display:flex;align-items:flex-start;gap:12px;cursor:pointer;width:100%;">
                <input type="radio" name="layout" value="default" {if $currentLayout === 'default'}checked{/if} style="margin-top:3px;">
                <div>
                  <strong>Karte &amp; Liste</strong>
                  <p class="bbf-form-hint" style="margin:4px 0 0;">Klassisches zweispaltiges Layout mit interaktiver Karte links und Filialliste rechts.</p>
                </div>
              </label>
            </div>

            <div class="bbf-layout-option{if $currentLayout === 'map_only'} active{/if}" data-layout="map_only" onclick="bbfSelectLayout('map_only', this);">
              <label style="display:flex;align-items:flex-start;gap:12px;cursor:pointer;width:100%;">
                <input type="radio" name="layout" value="map_only" {if $currentLayout === 'map_only'}checked{/if} style="margin-top:3px;">
                <div>
                  <strong>Nur Karte</strong>
                  <p class="bbf-form-hint" style="margin:4px 0 0;">Vollbreite Karte mit Marker-Popups. Ideal f&uuml;r Seiten mit wenig Platz.</p>
                </div>
              </label>
            </div>

            <div class="bbf-layout-option{if $currentLayout === 'grid'} active{/if}" data-layout="grid" onclick="bbfSelectLayout('grid', this);">
              <label style="display:flex;align-items:flex-start;gap:12px;cursor:pointer;width:100%;">
                <input type="radio" name="layout" value="grid" {if $currentLayout === 'grid'}checked{/if} style="margin-top:3px;">
                <div>
                  <strong>Grid / Kachel-Ansicht</strong>
                  <p class="bbf-form-hint" style="margin:4px 0 0;">Responsive Kachel-Grid mit Filialbildern und kompakten Infokarten.</p>
                </div>
              </label>
            </div>

            <div class="bbf-layout-option{if $currentLayout === 'accordion'} active{/if}" data-layout="accordion" onclick="bbfSelectLayout('accordion', this);">
              <label style="display:flex;align-items:flex-start;gap:12px;cursor:pointer;width:100%;">
                <input type="radio" name="layout" value="accordion" {if $currentLayout === 'accordion'}checked{/if} style="margin-top:3px;">
                <div>
                  <strong>Akkordeon / Kompakt</strong>
                  <p class="bbf-form-hint" style="margin:4px 0 0;">Platzsparende Akkordeon-Darstellung. Details werden per Klick aufgeklappt.</p>
                </div>
              </label>
            </div>

            <div class="bbf-layout-option{if $currentLayout === 'table'} active{/if}" data-layout="table" onclick="bbfSelectLayout('table', this);">
              <label style="display:flex;align-items:flex-start;gap:12px;cursor:pointer;width:100%;">
                <input type="radio" name="layout" value="table" {if $currentLayout === 'table'}checked{/if} style="margin-top:3px;">
                <div>
                  <strong>Tabellarisch</strong>
                  <p class="bbf-form-hint" style="margin:4px 0 0;">Strukturierte Tabellen-Darstellung mit sortierbaren Spalten. Ideal f&uuml;r viele Standorte.</p>
                </div>
              </label>
            </div>
          {/if}

        </div>

        <div style="margin-top:20px;">
          <button type="submit" class="bbf-btn bbf-btn-primary">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
            Vorlage speichern
          </button>
        </div>
      </form>
    </div>
  </div>

  {* ── Right: Live Preview ── *}
  <div>
    <div class="bbf-preview-panel">
      <div class="bbf-preview-header">
        <h3 style="margin:0;">Vorschau</h3>
        <span class="bbf-badge bbf-badge-success" id="bbf-preview-badge">Aktiv</span>
      </div>
      <div class="bbf-preview-body">
        <div id="bbf-layout-preview">
          <div class="bbf-text-center" style="padding:40px 0;">
            <div class="bbf-spinner"></div>
            <p class="bbf-text-muted" style="margin-top:12px;">Vorschau wird geladen...</p>
          </div>
        </div>
      </div>
    </div>
  </div>

</div>

<script>
function bbfSelectLayout(key, el) {
  document.querySelectorAll('.bbf-layout-option').forEach(function(opt) {
    opt.classList.remove('active');
  });
  el.classList.add('active');
  el.querySelector('input[type="radio"]').checked = true;
  bbfLoadPreview(key);
}

function bbfSaveLayout() {
  var selected = document.querySelector('input[name="layout"]:checked');
  if (!selected) { alert('Bitte eine Vorlage ausw\u00e4hlen.'); return; }

  var formData = new FormData();
  formData.append('action', 'saveLayout');
  formData.append('layout', selected.value);
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success) {
        var badge = document.getElementById('bbf-preview-badge');
        badge.textContent = 'Gespeichert';
        badge.className = 'bbf-badge bbf-badge-success';
        setTimeout(function() { badge.textContent = 'Aktiv'; }, 2000);
      } else {
        alert(data.message || 'Fehler beim Speichern.');
      }
    })
    .catch(function() { alert('Fehler beim Speichern.'); });
}

function bbfLoadPreview(layout) {
  var container = document.getElementById('bbf-layout-preview');
  container.innerHTML = '<div class="bbf-text-center" style="padding:40px 0;"><div class="bbf-spinner"></div><p class="bbf-text-muted" style="margin-top:12px;">Vorschau wird geladen...</p></div>';

  var formData = new FormData();
  formData.append('action', 'getLayoutPreview');
  formData.append('layout', layout);
  formData.append('jtl_token', jtlToken);

  fetch(postURL, { method: 'POST', body: formData })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.success && data.html) {
        container.innerHTML = data.html;
      } else {
        container.innerHTML = '<div class="bbf-text-center" style="padding:40px 0;"><p class="bbf-text-muted">Vorschau konnte nicht geladen werden.</p></div>';
      }
    })
    .catch(function() {
      container.innerHTML = '<div class="bbf-text-center" style="padding:40px 0;"><p class="bbf-text-muted">Vorschau konnte nicht geladen werden.</p></div>';
    });
}

(function() {
  var current = document.querySelector('input[name="layout"]:checked');
  if (current) {
    bbfLoadPreview(current.value);
  }
})();
</script>