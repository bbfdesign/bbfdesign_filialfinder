<form id="bbf-geolocation-form">

    {* ===== Card: Geolokation & Umkreissuche ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">Geolokation &amp; Umkreissuche</div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Benutzer-Standort ermitteln</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_geo_user_location" value="1" {if $allSettings.geo_user_location|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Umkreissuche</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_geo_radius_search" value="1" {if $allSettings.geo_radius_search|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Suchfeld anzeigen</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_geo_search_field" value="1" {if $allSettings.geo_search_field|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Entfernung anzeigen</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_geo_show_distance" value="1" {if $allSettings.geo_show_distance|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Einheit</label>
            <div class="bbf-form-row">
                <label>
                    <input type="radio" name="setting_geo_unit" value="km" {if ($allSettings.geo_unit|default:'km') === 'km'}checked{/if}> Kilometer (km)
                </label>
                <label>
                    <input type="radio" name="setting_geo_unit" value="miles" {if ($allSettings.geo_unit|default:'km') === 'miles'}checked{/if}> Meilen (miles)
                </label>
            </div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Standard-Suchradius (km)</label>
            <input type="number" name="setting_geo_default_radius" class="bbf-form-control" value="{$allSettings.geo_default_radius|default:'50'}" min="1" max="500">
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">N&auml;chste Filiale hervorheben</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_geo_highlight_nearest" value="1" {if $allSettings.geo_highlight_nearest|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
        </div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-geolocation-form', 'geolocation')">Einstellungen speichern</button>

</form>
