<form id="bbf-card-display-form">

    {* ===== Card: Filial-Karten Darstellung ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="3" y1="9" x2="21" y2="9"/></svg>
            Filial-Karten Darstellung
        </div>
        <p class="bbf-form-hint" style="margin-bottom:16px;">W&auml;hle welche Informationen in den Filial-Karten (Liste, Grid, Akkordeon) angezeigt werden sollen.</p>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Adresse anzeigen</label><div class="bbf-form-hint">Stra&szlig;e, PLZ, Ort</div></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_address" value="1" {if $allSettings.card_show_address|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Telefon anzeigen</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_phone" value="1" {if $allSettings.card_show_phone|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">E-Mail anzeigen</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_email" value="1" {if $allSettings.card_show_email|default:'0' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Website anzeigen</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_website" value="1" {if $allSettings.card_show_website|default:'0' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">&Ouml;ffnungsstatus anzeigen</label><div class="bbf-form-hint">Ge&ouml;ffnet / Geschlossen Badge</div></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_status" value="1" {if $allSettings.card_show_status|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">&Ouml;ffnungszeiten anzeigen</label><div class="bbf-form-hint">Heutige &Ouml;ffnungszeiten unter dem Status</div></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_hours" value="1" {if $allSettings.card_show_hours|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Entfernung anzeigen</label><div class="bbf-form-hint">Nur wenn Geolokation aktiviert</div></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_distance" value="1" {if $allSettings.card_show_distance|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Bild anzeigen</label><div class="bbf-form-hint">Filialbild in Grid- und Akkordeon-Ansicht</div></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_image" value="1" {if $allSettings.card_show_image|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Land anzeigen</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_country" value="1" {if $allSettings.card_show_country|default:'0' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Beschreibung anzeigen</label><div class="bbf-form-hint">Kurztext in der Karte</div></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_description" value="1" {if $allSettings.card_show_description|default:'0' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">&quot;Route berechnen&quot; Button</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_route_btn" value="1" {if $allSettings.card_show_route_btn|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">&quot;Details&quot; Button</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_card_show_detail_btn" value="1" {if $allSettings.card_show_detail_btn|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-row">
            <div class="bbf-form-group">
                <label class="bbf-form-label">Route-Button Text</label>
                <input type="text" name="setting_card_route_btn_text" class="bbf-form-control" value="{$allSettings.card_route_btn_text|default:'Route berechnen'|escape:'html'}">
            </div>
            <div class="bbf-form-group">
                <label class="bbf-form-label">Detail-Button Text</label>
                <input type="text" name="setting_card_detail_btn_text" class="bbf-form-control" value="{$allSettings.card_detail_btn_text|default:'Details anzeigen'|escape:'html'}">
            </div>
        </div>
    </div>

    {* ===== Card: Karten-Popup Darstellung ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            Karten-Popup Darstellung
        </div>
        <p class="bbf-form-hint" style="margin-bottom:16px;">Welche Informationen im Popup erscheinen, wenn ein Marker auf der Karte angeklickt wird.</p>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Adresse</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_popup_show_address" value="1" {if $allSettings.popup_show_address|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Telefon</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_popup_show_phone" value="1" {if $allSettings.popup_show_phone|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">E-Mail</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_popup_show_email" value="1" {if $allSettings.popup_show_email|default:'0' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">&Ouml;ffnungsstatus</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_popup_show_status" value="1" {if $allSettings.popup_show_status|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">&Ouml;ffnungszeiten</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_popup_show_hours" value="1" {if $allSettings.popup_show_hours|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>

        <div class="bbf-form-group"><div class="bbf-flex-between"><div><label class="bbf-form-label">Route-Button</label></div><label class="bbf-toggle"><input type="checkbox" name="setting_popup_show_route_btn" value="1" {if $allSettings.popup_show_route_btn|default:'1' == '1'}checked{/if}><span class="bbf-toggle-slider"></span></label></div></div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-card-display-form', 'card_display')">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
        Einstellungen speichern
    </button>

</form>
