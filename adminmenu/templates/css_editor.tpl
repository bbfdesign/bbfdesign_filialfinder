{* ===== Card 1: Benutzerdefiniertes CSS ===== *}
<div class="bbf-card">
    <div class="bbf-card-title">Benutzerdefiniertes CSS</div>

    <div class="bbf-form-group">
        <div class="bbf-codemirror-wrap">
            <textarea id="bbf-css-textarea" name="custom_css">{$customCss|default:''}</textarea>
        </div>
        <div class="bbf-form-hint">Eigenes CSS wird nach den Standard-Styles geladen und &uuml;berschreibt diese bei Bedarf.</div>
    </div>

    <div class="bbf-flex-between">
        <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveCss()">CSS speichern</button>
        <button type="button" class="bbf-btn bbf-btn-danger" onclick="bbfResetCss()">CSS zur&uuml;cksetzen</button>
    </div>
</div>

{* ===== Card 2: Verfügbare CSS-Klassen ===== *}
<div class="bbf-card">
    <div class="bbf-card-title">Verf&uuml;gbare CSS-Klassen</div>

    <table class="bbf-css-ref-table">
        <thead>
            <tr>
                <th>Klasse</th>
                <th>Beschreibung</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><code>.bbf-filialfinder-wrapper</code></td>
                <td>Hauptcontainer</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-list</code></td>
                <td>Listen-Container</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-card</code></td>
                <td>Einzelne Filial-Karte</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-card-active</code></td>
                <td>Aktive/Ausgew&auml;hlte Filiale</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-map</code></td>
                <td>Karten-Container</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-title</code></td>
                <td>&Uuml;berschrift</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-status</code></td>
                <td>&Ouml;ffnungsstatus Badge</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-status--open</code></td>
                <td>Ge&ouml;ffnet</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-status--closed</code></td>
                <td>Geschlossen</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-status--closing</code></td>
                <td>Schlie&szlig;t bald</td>
            </tr>
            <tr>
                <td><code>.bbf-filialfinder-status--opening</code></td>
                <td>&Ouml;ffnet bald</td>
            </tr>
        </tbody>
    </table>
</div>
