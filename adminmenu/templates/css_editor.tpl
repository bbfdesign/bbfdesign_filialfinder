{* ===== Card 1: Benutzerdefiniertes CSS ===== *}
<div class="bbf-card">
    <div class="bbf-card-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
        Benutzerdefiniertes CSS
    </div>

    <div class="bbf-form-group">
        <textarea id="bbf-css-textarea" name="custom_css" rows="18"
                  style="width:100%;min-height:400px;font-family:'Consolas','Monaco','Courier New',monospace;font-size:13px;line-height:1.6;padding:16px;border:1px solid var(--bbf-border);border-radius:var(--bbf-card-radius);background:#1e1e2e;color:#cdd6f4;resize:vertical;tab-size:2;"
                  spellcheck="false">{$customCss|default:''}</textarea>
        <div class="bbf-form-hint" style="margin-top:8px;">Eigenes CSS wird nach den Standard-Styles geladen und &uuml;berschreibt diese bei Bedarf.</div>
    </div>

    <div class="bbf-flex-between" style="margin-top:16px;">
        <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveCss()">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
            CSS speichern
        </button>
        <button type="button" class="bbf-btn bbf-btn-danger" onclick="bbfResetCss()">CSS zur&uuml;cksetzen</button>
    </div>
</div>

{* ===== Card 2: Verfügbare CSS-Klassen ===== *}
<div class="bbf-card">
    <div class="bbf-card-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
        Verf&uuml;gbare CSS-Klassen
    </div>

    <table class="bbf-table">
        <thead>
            <tr>
                <th style="width:300px;">Klasse</th>
                <th>Beschreibung</th>
            </tr>
        </thead>
        <tbody>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-wrapper</code></td><td>Hauptcontainer</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-layout--default</code></td><td>Standard-Layout (Liste + Karte nebeneinander)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-list</code></td><td>Listen-Container</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card</code></td><td>Einzelne Filial-Karte</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card--active</code></td><td>Aktive/Ausgew&auml;hlte Filiale</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-name</code></td><td>Filialname (h3)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-address</code></td><td>Adresse</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-phone</code></td><td>Telefonnummer</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-card-actions</code></td><td>Aktionsbereich (Buttons)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-map</code></td><td>Karten-Container</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-title</code></td><td>&Uuml;berschrift</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-status</code></td><td>&Ouml;ffnungsstatus Badge</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-status--open</code></td><td>Ge&ouml;ffnet (gr&uuml;n)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-status--closed</code></td><td>Geschlossen (rot)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-status--closing</code></td><td>Schlie&szlig;t bald (orange)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-status--opening</code></td><td>&Ouml;ffnet bald (blau)</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-btn</code></td><td>Button Basis-Klasse</td></tr>
            <tr><td><code style="background:var(--bbf-primary-light);padding:2px 8px;border-radius:4px;font-size:12px;color:var(--bbf-primary-dark, #9b1b6a);">.bbf-filialfinder-btn--route</code></td><td>Route-berechnen Button</td></tr>
        </tbody>
    </table>
</div>
