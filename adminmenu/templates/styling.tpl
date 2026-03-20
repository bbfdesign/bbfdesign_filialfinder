<form id="bbf-styling-form">

    {* ===== 2-Column Layout: Settings + Preview ===== *}
    <div style="display:flex;gap:24px;align-items:flex-start;">

        {* ── Left Column: Settings ── *}
        <div style="flex:1;min-width:0;">

            {* Farben (2-Spalten Grid) *}
            <div class="bbf-card">
                <div class="bbf-card-title">Farben</div>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px 20px;">
                    {foreach ['primary' => ['Prim&auml;rfarbe', '#C8B831'], 'secondary' => ['Sekund&auml;rfarbe', '#1f2937'], 'bg' => ['Hintergrund', '#ffffff'], 'text' => ['Textfarbe', '#1f2937'], 'open' => ['Ge&ouml;ffnet', '#28a745'], 'closed' => ['Geschlossen', '#dc3545'], 'marker' => ['Marker', '#C8B831']] as $key => $meta}
                        <div class="bbf-form-group" style="margin:0;">
                            <label class="bbf-form-label" style="font-size:12px;margin-bottom:4px;">{$meta[0]}</label>
                            <div class="bbf-colorpicker">
                                <input type="color" value="{$allSettings["styling_{$key}_color"]|default:$meta[1]}" onchange="this.nextElementSibling.value=this.value;bbfUpdatePreview()">
                                <input type="text" name="setting_styling_{$key}_color" class="bbf-form-control" value="{$allSettings["styling_{$key}_color"]|default:$meta[1]}" style="width:90px;font-size:12px;" onchange="this.previousElementSibling.value=this.value;bbfUpdatePreview()">
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>

            {* Layout-Details *}
            <div class="bbf-card">
                <div class="bbf-card-title">Layout-Details</div>
                <div class="bbf-form-group">
                    <label class="bbf-form-label">Border-Radius</label>
                    <div class="bbf-range-group">
                        <input type="range" name="setting_styling_border_radius" min="0" max="30" value="{$allSettings.styling_border_radius|default:'8'}" oninput="this.parentNode.querySelector('.bbf-range-value').textContent=this.value+'px';bbfUpdatePreview()">
                        <span class="bbf-range-value">{$allSettings.styling_border_radius|default:'8'}px</span>
                    </div>
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-form-label">Schatten-Intensit&auml;t</label>
                    <div class="bbf-range-group">
                        <input type="range" name="setting_styling_shadow_intensity" min="0" max="5" value="{$allSettings.styling_shadow_intensity|default:'2'}" oninput="this.parentNode.querySelector('.bbf-range-value').textContent=this.value">
                        <span class="bbf-range-value">{$allSettings.styling_shadow_intensity|default:'2'}</span>
                    </div>
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-form-label">Schriftart</label>
                    <select name="setting_styling_font" class="bbf-form-control">
                        <option value="inherit" {if ($allSettings.styling_font|default:'inherit') === 'inherit'}selected{/if}>Shop-Schrift (inherit)</option>
                        <option value="Manrope" {if ($allSettings.styling_font|default:'inherit') === 'Manrope'}selected{/if}>Manrope</option>
                        <option value="Arial" {if ($allSettings.styling_font|default:'inherit') === 'Arial'}selected{/if}>Arial</option>
                        <option value="Georgia" {if ($allSettings.styling_font|default:'inherit') === 'Georgia'}selected{/if}>Georgia</option>
                    </select>
                </div>
            </div>

            {* &Uuml;berschrift & Text *}
            <div class="bbf-card">
                <div class="bbf-card-title">&Uuml;berschrift &amp; Text</div>
                <div class="bbf-grid-2">
                    <div class="bbf-form-group">
                        <label class="bbf-form-label">&Uuml;berschrift</label>
                        <input type="text" name="setting_styling_title" class="bbf-form-control" value="{$allSettings.styling_title|default:'Unsere Filialen'}">
                    </div>
                    <div class="bbf-form-group">
                        <label class="bbf-form-label">HTML-Tag</label>
                        <select name="setting_styling_title_tag" class="bbf-form-control">
                            <option value="h1" {if ($allSettings.styling_title_tag|default:'h2') === 'h1'}selected{/if}>h1</option>
                            <option value="h2" {if ($allSettings.styling_title_tag|default:'h2') === 'h2'}selected{/if}>h2</option>
                            <option value="h3" {if ($allSettings.styling_title_tag|default:'h2') === 'h3'}selected{/if}>h3</option>
                            <option value="h4" {if ($allSettings.styling_title_tag|default:'h2') === 'h4'}selected{/if}>h4</option>
                        </select>
                    </div>
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-form-label">Ausrichtung</label>
                    <div class="bbf-form-row">
                        <label><input type="radio" name="setting_styling_title_align" value="left" {if ($allSettings.styling_title_align|default:'center') === 'left'}checked{/if}> Links</label>
                        <label><input type="radio" name="setting_styling_title_align" value="center" {if ($allSettings.styling_title_align|default:'center') === 'center'}checked{/if}> Zentriert</label>
                        <label><input type="radio" name="setting_styling_title_align" value="right" {if ($allSettings.styling_title_align|default:'center') === 'right'}checked{/if}> Rechts</label>
                    </div>
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-form-label">Unter&uuml;berschrift</label>
                    <input type="text" name="setting_styling_subtitle" class="bbf-form-control" value="{$allSettings.styling_subtitle|default:''}">
                </div>
                <div class="bbf-form-group">
                    <div class="bbf-flex-between">
                        <label class="bbf-form-label">Trennlinie</label>
                        <label class="bbf-toggle">
                            <input type="checkbox" name="setting_styling_divider" value="1" {if $allSettings.styling_divider|default:'0' == '1'}checked{/if}>
                            <span class="bbf-toggle-slider"></span>
                        </label>
                    </div>
                </div>
                <div class="bbf-grid-2">
                    <div class="bbf-form-group">
                        <label class="bbf-form-label">Trennlinien-Farbe</label>
                        <div class="bbf-colorpicker">
                            <input type="color" value="{$allSettings.styling_divider_color|default:'#C8B831'}" onchange="this.nextElementSibling.value=this.value">
                            <input type="text" name="setting_styling_divider_color" class="bbf-form-control" value="{$allSettings.styling_divider_color|default:'#C8B831'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
                        </div>
                    </div>
                    <div class="bbf-form-group">
                        <label class="bbf-form-label">Dicke (px)</label>
                        <input type="number" name="setting_styling_divider_width" class="bbf-form-control" value="{$allSettings.styling_divider_width|default:'2'}" min="1" max="20">
                    </div>
                </div>
                <div class="bbf-form-group">
                    <label class="bbf-form-label">Kein-Ergebnis-Text</label>
                    <input type="text" name="setting_styling_no_results_text" class="bbf-form-control" value="{$allSettings.styling_no_results_text|default:'Keine Filialen gefunden.'}">
                </div>
            </div>
        </div>

        {* ── Right Column: Live Preview ── *}
        <div style="flex:0 0 340px;position:sticky;top:20px;">
            <div class="bbf-card">
                <div class="bbf-card-title">Live-Vorschau</div>
                <div id="bbf-style-preview" style="padding:16px;border-radius:8px;border:1px solid #e5e7eb;">
                    <div id="bbf-preview-card" style="padding:14px 16px;border-radius:8px;border:1px solid #e5e7eb;margin-bottom:12px;">
                        <h3 style="margin:0 0 6px;font-weight:700;font-size:1rem;" id="bbf-preview-name">Musterfiliale Berlin</h3>
                        <p style="margin:0 0 4px;font-size:0.85rem;" id="bbf-preview-address">Friedrichstra&szlig;e 123, 10117 Berlin</p>
                        <p style="margin:0 0 6px;font-size:0.85rem;">Telefon: 030 12345678</p>
                        <span id="bbf-preview-status-open" style="display:inline-flex;align-items:center;gap:4px;font-size:0.75rem;font-weight:600;padding:2px 8px;border-radius:999px;">
                            <span style="width:7px;height:7px;border-radius:50%;display:inline-block;"></span>
                            Jetzt ge&ouml;ffnet (bis 18:00)
                        </span>
                        <div style="margin-top:8px;">
                            <a id="bbf-preview-btn" style="display:inline-block;padding:5px 12px;border-radius:4px;font-size:0.75rem;font-weight:600;text-decoration:none;text-transform:uppercase;">Route berechnen</a>
                        </div>
                    </div>
                    <div id="bbf-preview-card-closed" style="padding:14px 16px;border-radius:8px;border:1px solid #e5e7eb;">
                        <h3 style="margin:0 0 6px;font-weight:700;font-size:1rem;">Musterfiliale M&uuml;nchen</h3>
                        <p style="margin:0 0 4px;font-size:0.85rem;">Marienplatz 1, 80331 M&uuml;nchen</p>
                        <span id="bbf-preview-status-closed" style="display:inline-flex;align-items:center;gap:4px;font-size:0.75rem;font-weight:600;padding:2px 8px;border-radius:999px;">
                            <span style="width:7px;height:7px;border-radius:50%;display:inline-block;"></span>
                            Geschlossen
                        </span>
                    </div>
                    <div style="margin-top:12px;text-align:center;">
                        <svg id="bbf-preview-marker" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 36" width="28" height="42">
                            <path d="M12 0C5.4 0 0 5.4 0 12c0 9 12 24 12 24s12-15 12-24C24 5.4 18.6 0 12 0z" stroke="#fff" stroke-width="1.5"/>
                            <circle cx="12" cy="12" r="5" fill="#fff"/>
                        </svg>
                        <small style="display:block;margin-top:4px;color:#999;">Kartenmarker</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" style="margin-top:16px;" onclick="bbfSaveSettings('bbf-styling-form', 'styling')">Einstellungen speichern</button>

</form>

<script>
function bbfUpdatePreview() {
    var form = document.getElementById('bbf-styling-form');
    if (!form) return;
    var get = function(name) {
        var el = form.querySelector('[name="setting_styling_' + name + '"]');
        return el ? el.value : '';
    };
    var primary = get('primary_color') || '#C8B831';
    var secondary = get('secondary_color') || '#1f2937';
    var bg = get('bg_color') || '#ffffff';
    var text = get('text_color') || '#1f2937';
    var open = get('open_color') || '#28a745';
    var closed = get('closed_color') || '#dc3545';
    var marker = get('marker_color') || '#C8B831';
    var radius = (get('border_radius') || '8') + 'px';

    var preview = document.getElementById('bbf-style-preview');
    if (preview) preview.style.background = bg;

    var card = document.getElementById('bbf-preview-card');
    var cardClosed = document.getElementById('bbf-preview-card-closed');
    if (card) { card.style.borderRadius = radius; card.style.color = text; }
    if (cardClosed) { cardClosed.style.borderRadius = radius; cardClosed.style.color = text; }

    var name = document.getElementById('bbf-preview-name');
    if (name) name.style.color = secondary;

    var statusOpen = document.getElementById('bbf-preview-status-open');
    if (statusOpen) {
        statusOpen.style.background = open + '1a';
        statusOpen.style.color = open;
        var dot = statusOpen.querySelector('span');
        if (dot) dot.style.background = open;
    }

    var statusClosed = document.getElementById('bbf-preview-status-closed');
    if (statusClosed) {
        statusClosed.style.background = closed + '1a';
        statusClosed.style.color = closed;
        var dot2 = statusClosed.querySelector('span');
        if (dot2) dot2.style.background = closed;
    }

    var btn = document.getElementById('bbf-preview-btn');
    if (btn) { btn.style.background = primary; btn.style.color = '#fff'; btn.style.borderRadius = radius; }

    var markerSvg = document.getElementById('bbf-preview-marker');
    if (markerSvg) {
        var path = markerSvg.querySelector('path');
        if (path) path.setAttribute('fill', marker);
    }
}
// Init preview on load
setTimeout(bbfUpdatePreview, 100);
</script>

<style>
@media (max-width: 900px) {
    #bbf-styling-form > div:first-child { flex-direction: column; }
    #bbf-styling-form > div:first-child > div:last-child { position: static; flex: none; width: 100%; }
}
</style>
