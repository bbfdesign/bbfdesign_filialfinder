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
                DSGVO-Integration (JavaScript-basiert)
            </div>
            <p>
                Wenn die <strong>Consent-Abfrage aktiviert</strong> ist, wird anstelle der interaktiven Karte zun&auml;chst ein Platzhalter angezeigt.
                Dieser zeigt den Namen des Kartenanbieters (Google Maps oder OpenStreetMap) sowie einen &quot;Aktivieren&quot;-Button.
            </p>
            <p>
                Die Consent-Pr&uuml;fung erfolgt vollst&auml;ndig im Frontend per JavaScript:
            </p>
            <ul style="margin: 0.5em 0 0.5em 1.5em; list-style: disc;">
                <li>Falls JTLs <code>window.ConsentManager</code> JS-API verf&uuml;gbar ist, wird diese automatisch verwendet.</li>
                <li>Andernfalls wird ein einfacher <code>localStorage</code>-Fallback genutzt, um die Zustimmung des Nutzers zu speichern.</li>
            </ul>
            <p>
                Es ist <strong>keine manuelle Konfiguration</strong> im JTL Consent Manager n&ouml;tig &mdash; das Plugin funktioniert automatisch.
                Externe Kartenressourcen werden erst nach expliziter Zustimmung des Nutzers geladen, womit die datenschutzrechtlichen Anforderungen
                gem&auml;&szlig; DSGVO erf&uuml;llt werden.
            </p>
        </div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-consent-form', 'consent')">Einstellungen speichern</button>

</form>
