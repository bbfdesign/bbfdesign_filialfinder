<form id="bbf-consent-form">

    {* ===== Card: Consent Manager / Datenschutz ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            Consent Manager / Datenschutz
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <div>
                    <label class="bbf-form-label">Consent-Abfrage aktiviert</label>
                    <div class="bbf-form-hint">Karte erst nach Zustimmung des Nutzers laden</div>
                </div>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_consent_enabled" value="1" {if $allSettings.consent_enabled|default:'1' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Platzhalter-Text</label>
            <textarea name="setting_consent_placeholder_text" class="bbf-form-control" rows="3" placeholder="Zur Anzeige der Karte wird ein externer Dienst geladen. Mit dem Laden stimmen Sie der Datenschutzerkl&auml;rung zu.">{$allSettings.consent_placeholder_text|default:''}</textarea>
            <div class="bbf-form-hint">Text der angezeigt wird bevor der Nutzer zustimmt. Leer = Standard-Text.</div>
        </div>

        <div class="bbf-form-group">
            <label class="bbf-form-label">Statisches Kartenbild (optional)</label>
            <input type="text" name="setting_consent_static_image" class="bbf-form-control" value="{$allSettings.consent_static_image|default:''}" placeholder="https://example.com/static-map.jpg">
            <div class="bbf-form-hint">URL eines statischen Bildes das anstelle der Karte angezeigt wird, bevor Consent erteilt wurde.</div>
        </div>
    </div>

    {* ===== Info-Box: JTL Consent Manager ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
            JTL Consent Manager Integration
        </div>

        <p>Dieses Plugin registriert sich <strong>automatisch</strong> im JTL Consent Manager. Bei der Installation werden zwei Consent-Eintr&auml;ge angelegt:</p>

        <table class="bbf-table" style="margin:16px 0;">
            <thead>
                <tr>
                    <th>Anbieter</th>
                    <th>Unternehmen</th>
                    <th>Zweck</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>OpenStreetMap</strong></td>
                    <td>OpenStreetMap Foundation</td>
                    <td>Kartenanzeige</td>
                </tr>
                <tr>
                    <td><strong>Google Maps</strong></td>
                    <td>Google LLC</td>
                    <td>Kartenanzeige</td>
                </tr>
            </tbody>
        </table>

        <p>Die Eintr&auml;ge erscheinen unter <strong>Datenschutz &gt; Consent Manager</strong> im JTL-Admin. Dort k&ouml;nnen Sie:</p>
        <ul style="margin:8px 0 8px 20px;list-style:disc;">
            <li>Die Consent-Texte anpassen</li>
            <li>Den jeweiligen Dienst aktivieren/deaktivieren</li>
            <li>Die Datenschutzerkl&auml;rungs-Links &auml;ndern</li>
        </ul>

        <p style="margin-top:12px;padding:10px;background:var(--bbf-primary-light);border-radius:var(--bbf-card-radius);font-size:13px;">
            <strong>Hinweis:</strong> Nach der ersten Installation des Plugins m&uuml;ssen Sie das Plugin einmal <strong>deinstallieren und neu installieren</strong>, damit die Consent-Eintr&auml;ge angelegt werden. Die Eintr&auml;ge werden &uuml;ber die <code>info.xml</code> (<code>&lt;ServicesRequiringConsent&gt;</code>) registriert.
        </p>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-consent-form', 'consent')">Einstellungen speichern</button>

</form>
