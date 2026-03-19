<form id="bbf-consent-form">

    {* ===== Card: Consent Manager / Datenschutz ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">Consent Manager / Datenschutz</div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Consent-Abfrage aktiviert</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_consent_enabled" value="1" {if $allSettings.consent_enabled|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Platzhalter-Text</label>
            <textarea name="setting_consent_placeholder_text" class="bbf-form-control" rows="4">{$allSettings.consent_placeholder_text|default:''}</textarea>
            <div class="bbf-form-hint">Text der angezeigt wird wenn kein Consent gegeben wurde</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Statisches Kartenbild</label>
            <input type="text" name="setting_consent_static_image" class="bbf-form-control" value="{$allSettings.consent_static_image|default:''}">
            <div class="bbf-form-hint">Optional: URL eines statischen Bildes als Kartenersatz</div>
        </div>

        <div class="bbf-info-box">
            <div class="bbf-info-box-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                DSGVO-Integration mit JTL Consent Manager
            </div>
            <p>
                Der BBF Filialfinder l&auml;sst sich nahtlos in den JTL Consent Manager integrieren. Wenn die Consent-Abfrage aktiviert ist,
                werden externe Kartenressourcen (Google Maps oder OpenStreetMap Tiles) erst geladen, nachdem der Benutzer seine Einwilligung gegeben hat.
            </p>
            <p>
                Solange kein Consent vorliegt, wird anstelle der interaktiven Karte ein Platzhalter angezeigt. Dieser kann einen erkl&auml;renden
                Text sowie optional ein statisches Kartenbild enthalten. Der Benutzer erh&auml;lt einen Button, um die Einwilligung direkt zu erteilen.
            </p>
            <p>
                Die Consent-Kategorie wird automatisch anhand des gew&auml;hlten Kartenanbieters zugeordnet. F&uuml;r Google Maps wird die Kategorie
                &quot;Google Maps&quot; verwendet, f&uuml;r OpenStreetMap die Kategorie &quot;OpenStreetMap&quot;. Stellen Sie sicher, dass die
                entsprechenden Consent-Kategorien in Ihrem JTL-Shop unter &quot;Datenschutz &gt; Consent Manager&quot; korrekt konfiguriert sind.
            </p>
            <p>
                Durch die Integration werden alle datenschutzrechtlichen Anforderungen gem&auml;&szlig; DSGVO erf&uuml;llt.
                Externe Skripte, Stylesheets und Kartendaten werden erst nach expliziter Zustimmung des Nutzers nachgeladen.
            </p>
        </div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-consent-form', 'consent')">Einstellungen speichern</button>

</form>
