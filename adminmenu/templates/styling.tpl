<form id="bbf-styling-form">

    {* ===== Card 1: Farben ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">Farben</div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Prim&auml;rfarbe</label>
            <div class="bbf-colorpicker">
                <input type="color" value="{$allSettings.styling_primary_color|default:'#C8B831'}" onchange="this.nextElementSibling.value=this.value">
                <input type="text" name="setting_styling_primary_color" class="bbf-form-control" value="{$allSettings.styling_primary_color|default:'#C8B831'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
            </div>
            <div class="bbf-form-hint">Hauptfarbe f&uuml;r Buttons und Akzente</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Sekund&auml;rfarbe</label>
            <div class="bbf-colorpicker">
                <input type="color" value="{$allSettings.styling_secondary_color|default:'#1f2937'}" onchange="this.nextElementSibling.value=this.value">
                <input type="text" name="setting_styling_secondary_color" class="bbf-form-control" value="{$allSettings.styling_secondary_color|default:'#1f2937'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
            </div>
            <div class="bbf-form-hint">Sekund&auml;re Farbe f&uuml;r Hintergr&uuml;nde und Rahmen</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Hintergrundfarbe</label>
            <div class="bbf-colorpicker">
                <input type="color" value="{$allSettings.styling_bg_color|default:'#ffffff'}" onchange="this.nextElementSibling.value=this.value">
                <input type="text" name="setting_styling_bg_color" class="bbf-form-control" value="{$allSettings.styling_bg_color|default:'#ffffff'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
            </div>
            <div class="bbf-form-hint">Hintergrundfarbe des Filialfinders</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Textfarbe</label>
            <div class="bbf-colorpicker">
                <input type="color" value="{$allSettings.styling_text_color|default:'#1f2937'}" onchange="this.nextElementSibling.value=this.value">
                <input type="text" name="setting_styling_text_color" class="bbf-form-control" value="{$allSettings.styling_text_color|default:'#1f2937'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
            </div>
            <div class="bbf-form-hint">Allgemeine Textfarbe</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Akzentfarbe &quot;Ge&ouml;ffnet&quot;</label>
            <div class="bbf-colorpicker">
                <input type="color" value="{$allSettings.styling_open_color|default:'#28a745'}" onchange="this.nextElementSibling.value=this.value">
                <input type="text" name="setting_styling_open_color" class="bbf-form-control" value="{$allSettings.styling_open_color|default:'#28a745'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
            </div>
            <div class="bbf-form-hint">Farbe f&uuml;r den Status &quot;Ge&ouml;ffnet&quot;</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Akzentfarbe &quot;Geschlossen&quot;</label>
            <div class="bbf-colorpicker">
                <input type="color" value="{$allSettings.styling_closed_color|default:'#dc3545'}" onchange="this.nextElementSibling.value=this.value">
                <input type="text" name="setting_styling_closed_color" class="bbf-form-control" value="{$allSettings.styling_closed_color|default:'#dc3545'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
            </div>
            <div class="bbf-form-hint">Farbe f&uuml;r den Status &quot;Geschlossen&quot;</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Kartenmarker-Farbe</label>
            <div class="bbf-colorpicker">
                <input type="color" value="{$allSettings.styling_marker_color|default:'#C8B831'}" onchange="this.nextElementSibling.value=this.value">
                <input type="text" name="setting_styling_marker_color" class="bbf-form-control" value="{$allSettings.styling_marker_color|default:'#C8B831'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
            </div>
            <div class="bbf-form-hint">Farbe der Marker auf der Karte</div>
        </div>
    </div>

    {* ===== Card 2: Layout-Details ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">Layout-Details</div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Border-Radius</label>
            <div class="bbf-range-group">
                <input type="range" name="setting_styling_border_radius" min="0" max="30" value="{$allSettings.styling_border_radius|default:'8'}">
                <span class="bbf-range-value">{$allSettings.styling_border_radius|default:'8'}px</span>
            </div>
            <div class="bbf-form-hint">Abrundung der Ecken in Pixeln</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Schatten-Intensit&auml;t</label>
            <div class="bbf-range-group">
                <input type="range" name="setting_styling_shadow_intensity" min="0" max="5" value="{$allSettings.styling_shadow_intensity|default:'2'}">
                <span class="bbf-range-value">{$allSettings.styling_shadow_intensity|default:'2'}</span>
            </div>
            <div class="bbf-form-hint">St&auml;rke des Schattens (0 = kein Schatten)</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Schriftart</label>
            <select name="setting_styling_font" class="bbf-form-control">
                <option value="inherit" {if ($allSettings.styling_font|default:'inherit') === 'inherit'}selected{/if}>Shop-Schrift (inherit)</option>
                <option value="Manrope" {if ($allSettings.styling_font|default:'inherit') === 'Manrope'}selected{/if}>Manrope</option>
                <option value="Arial" {if ($allSettings.styling_font|default:'inherit') === 'Arial'}selected{/if}>Arial</option>
                <option value="Georgia" {if ($allSettings.styling_font|default:'inherit') === 'Georgia'}selected{/if}>Georgia</option>
            </select>
            <div class="bbf-form-hint">Schriftart f&uuml;r den Filialfinder</div>
        </div>
    </div>

    {* ===== Card 3: Überschrift & Text ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">&Uuml;berschrift &amp; Text</div>

        <div class="bbf-grid-2">
            <div class="bbf-form-group">
                <label class="bbf-form-label">&Uuml;berschrift</label>
                <input type="text" name="setting_styling_title" class="bbf-form-control" value="{$allSettings.styling_title|default:'Unsere Filialen'}">
                <div class="bbf-form-hint">Haupttitel des Filialfinders</div>
            </div>

            <div class="bbf-form-group">
                <label class="bbf-form-label">HTML-Tag</label>
                <select name="setting_styling_title_tag" class="bbf-form-control">
                    <option value="h1" {if ($allSettings.styling_title_tag|default:'h2') === 'h1'}selected{/if}>h1</option>
                    <option value="h2" {if ($allSettings.styling_title_tag|default:'h2') === 'h2'}selected{/if}>h2</option>
                    <option value="h3" {if ($allSettings.styling_title_tag|default:'h2') === 'h3'}selected{/if}>h3</option>
                    <option value="h4" {if ($allSettings.styling_title_tag|default:'h2') === 'h4'}selected{/if}>h4</option>
                    <option value="h5" {if ($allSettings.styling_title_tag|default:'h2') === 'h5'}selected{/if}>h5</option>
                    <option value="h6" {if ($allSettings.styling_title_tag|default:'h2') === 'h6'}selected{/if}>h6</option>
                </select>
                <div class="bbf-form-hint">Semantisches HTML-Tag der &Uuml;berschrift</div>
            </div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Ausrichtung</label>
            <div class="bbf-form-row">
                <label>
                    <input type="radio" name="setting_styling_title_align" value="left" {if ($allSettings.styling_title_align|default:'center') === 'left'}checked{/if}> Links
                </label>
                <label>
                    <input type="radio" name="setting_styling_title_align" value="center" {if ($allSettings.styling_title_align|default:'center') === 'center'}checked{/if}> Zentriert
                </label>
                <label>
                    <input type="radio" name="setting_styling_title_align" value="right" {if ($allSettings.styling_title_align|default:'center') === 'right'}checked{/if}> Rechts
                </label>
            </div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Unter&uuml;berschrift</label>
            <input type="text" name="setting_styling_subtitle" class="bbf-form-control" value="{$allSettings.styling_subtitle|default:''}">
            <div class="bbf-form-hint">Optionaler Text unterhalb der &Uuml;berschrift</div>
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Trennlinie anzeigen</label>
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
                <label class="bbf-form-label">Trennlinien-Dicke</label>
                <input type="number" name="setting_styling_divider_width" class="bbf-form-control" value="{$allSettings.styling_divider_width|default:'2'}" min="1" max="20">
                <div class="bbf-form-hint">Dicke in Pixeln</div>
            </div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Trennlinien-Breite (%)</label>
            <input type="number" name="setting_styling_divider_percent" class="bbf-form-control" value="{$allSettings.styling_divider_percent|default:'50'}" min="1" max="100">
            <div class="bbf-form-hint">Breite der Trennlinie in Prozent</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Kein-Ergebnis-Text</label>
            <input type="text" name="setting_styling_no_results_text" class="bbf-form-control" value="{$allSettings.styling_no_results_text|default:'Keine Filialen gefunden.'}">
            <div class="bbf-form-hint">Text, der angezeigt wird, wenn keine Filialen gefunden werden</div>
        </div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-styling-form', 'styling')">Einstellungen speichern</button>

</form>
