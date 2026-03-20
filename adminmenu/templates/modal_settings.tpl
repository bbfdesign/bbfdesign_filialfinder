<form id="bbf-modal-settings-form">

    {* ===== Card 1: Detail-Modal Einstellungen ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">Detail-Modal Einstellungen</div>

        {* Detail-Modal aktivieren *}
        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Detail-Modal aktivieren</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_modal_enabled" value="1" {if $allSettings.modal_enabled|default:'1' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
            <div class="bbf-form-hint">Aktiviert das Detail-Modal f&uuml;r Filialen</div>
        </div>

        {* Modal-Auslöser *}
        <div class="bbf-form-group">
            <label class="bbf-form-label">Modal-Ausl&ouml;ser</label>
            <select name="setting_modal_trigger" class="bbf-form-control">
                <option value="click_card" {if ($allSettings.modal_trigger|default:'button') === 'click_card'}selected{/if}>Klick auf Filial-Karte &ouml;ffnet Modal</option>
                <option value="button" {if ($allSettings.modal_trigger|default:'button') === 'button'}selected{/if}>&quot;Details&quot; Button in der Karte</option>
                <option value="both" {if ($allSettings.modal_trigger|default:'button') === 'both'}selected{/if}>Beides</option>
            </select>
            <div class="bbf-form-hint">Wie soll das Detail-Modal ge&ouml;ffnet werden?</div>
        </div>

        {* Button-Text *}
        <div class="bbf-form-group">
            <label class="bbf-form-label">Button-Text</label>
            <input type="text" name="setting_modal_button_text" class="bbf-form-control" value="{$allSettings.modal_button_text|default:'Details anzeigen'}">
            <div class="bbf-form-hint">Text des Detail-Buttons in der Filial-Karte</div>
        </div>

        {* Modal-Inhalte als kompaktes 2-Spalten Grid *}
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px 16px;margin-bottom:16px;">
            {foreach ['gallery' => 'Galerie', 'videos' => 'Videos', 'description' => 'Beschreibung', 'hours' => '&Ouml;ffnungszeiten', 'map' => 'Karte', 'directions' => 'Route-Button'] as $key => $label}
                <div class="bbf-form-group" style="margin:0;padding:8px 0;border-bottom:1px solid var(--bbf-border);">
                    <div class="bbf-flex-between">
                        <label class="bbf-form-label" style="margin:0;font-size:13px;">{$label}</label>
                        <label class="bbf-toggle">
                            <input type="checkbox" name="setting_modal_show_{$key}" value="1" {if $allSettings["modal_show_{$key}"]|default:'1' == '1'}checked{/if}>
                            <span class="bbf-toggle-slider"></span>
                        </label>
                    </div>
                </div>
            {/foreach}
        </div>

        {* Modal-Breite *}
        <div class="bbf-form-group">
            <label class="bbf-form-label">Modal-Breite</label>
            <select name="setting_modal_width" class="bbf-form-control">
                <option value="small" {if ($allSettings.modal_width|default:'medium') === 'small'}selected{/if}>Klein (500px)</option>
                <option value="medium" {if ($allSettings.modal_width|default:'medium') === 'medium'}selected{/if}>Mittel (700px)</option>
                <option value="large" {if ($allSettings.modal_width|default:'medium') === 'large'}selected{/if}>Gro&szlig; (900px)</option>
                <option value="fullscreen" {if ($allSettings.modal_width|default:'medium') === 'fullscreen'}selected{/if}>Vollbild</option>
            </select>
            <div class="bbf-form-hint">Maximale Breite des Detail-Modals</div>
        </div>

        {* Animation *}
        <div class="bbf-form-group">
            <label class="bbf-form-label">Animation</label>
            <select name="setting_modal_animation" class="bbf-form-control">
                <option value="fade" {if ($allSettings.modal_animation|default:'fade') === 'fade'}selected{/if}>Einblenden (Fade)</option>
                <option value="slide" {if ($allSettings.modal_animation|default:'fade') === 'slide'}selected{/if}>Hereingleiten (Slide)</option>
                <option value="none" {if ($allSettings.modal_animation|default:'fade') === 'none'}selected{/if}>Keine Animation</option>
            </select>
            <div class="bbf-form-hint">Animation beim &Ouml;ffnen und Schlie&szlig;en des Modals</div>
        </div>

        {* Overlay-Farbe *}
        <div class="bbf-form-group">
            <label class="bbf-form-label">Overlay-Farbe</label>
            <div class="bbf-colorpicker">
                <input type="color" value="{$allSettings.modal_overlay_color|default:'#000000'}" onchange="this.nextElementSibling.value=this.value">
                <input type="text" name="setting_modal_overlay_color" class="bbf-form-control" value="{$allSettings.modal_overlay_color|default:'#000000'}" style="width:100px" onchange="this.previousElementSibling.value=this.value">
            </div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Overlay-Transparenz</label>
            <div class="bbf-range-group">
                <input type="range" name="setting_modal_overlay_opacity" min="0" max="100" step="5" value="{$allSettings.modal_overlay_opacity|default:'50'}">
                <span class="bbf-range-value">{$allSettings.modal_overlay_opacity|default:'50'}%</span>
            </div>
            <div class="bbf-form-hint">Deckkraft des Overlay-Hintergrunds (0% = transparent, 100% = deckend)</div>
        </div>
    </div>

    {* ===== Card 2: Galerie & Medien ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">Galerie &amp; Medien</div>

        {* Max. Bilder pro Filiale *}
        <div class="bbf-form-group">
            <label class="bbf-form-label">Max. Bilder pro Filiale</label>
            <input type="number" name="setting_modal_max_images" class="bbf-form-control" value="{$allSettings.modal_max_images|default:'10'}" min="1" max="50" style="width:120px">
            <div class="bbf-form-hint">Maximale Anzahl der Bilder in der Galerie</div>
        </div>

        {* Bild-Qualität *}
        <div class="bbf-form-group">
            <label class="bbf-form-label">Bild-Qualit&auml;t</label>
            <select name="setting_modal_image_quality" class="bbf-form-control">
                <option value="original" {if ($allSettings.modal_image_quality|default:'high') === 'original'}selected{/if}>Original</option>
                <option value="high" {if ($allSettings.modal_image_quality|default:'high') === 'high'}selected{/if}>Hoch</option>
                <option value="medium" {if ($allSettings.modal_image_quality|default:'high') === 'medium'}selected{/if}>Mittel</option>
                <option value="low" {if ($allSettings.modal_image_quality|default:'high') === 'low'}selected{/if}>Niedrig</option>
            </select>
            <div class="bbf-form-hint">Qualit&auml;tsstufe der Galeriebilder (niedriger = schnellere Ladezeit)</div>
        </div>

        {* Lightbox aktivieren *}
        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Lightbox aktivieren</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_modal_lightbox" value="1" {if $allSettings.modal_lightbox|default:'1' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
            <div class="bbf-form-hint">Bilder in einer Lightbox vergr&ouml;&szlig;ert anzeigen</div>
        </div>

        {* YouTube Datenschutz-Modus *}
        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">YouTube Datenschutz-Modus</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_modal_youtube_privacy" value="1" {if $allSettings.modal_youtube_privacy|default:'1' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
            <div class="bbf-form-hint">Verwendet youtube-nocookie.com f&uuml;r DSGVO-Konformit&auml;t</div>
        </div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-modal-settings-form', 'modal_settings')">Einstellungen speichern</button>

</form>
