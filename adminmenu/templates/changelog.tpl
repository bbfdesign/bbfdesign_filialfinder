<div class="bbf-card">
    <div class="bbf-card-title">Changelog</div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.2.3 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> Marker-Farbe nutzt jetzt globale Einstellung statt Branch-Default (#e74c3c)</li>
            <li><strong>Behoben:</strong> Card-Farben: Inaktive Cards wei&szlig;, aktive/selektierte Cards olive/gold</li>
            <li><strong>Behoben:</strong> Stamen Toner/Watercolor Tile-Server entfernt (401 Error nach Stadia &Uuml;bernahme)</li>
            <li><strong>Neu:</strong> Moderner Medien-Tab mit Tabs, Dropzone, Upload-Queue und Clipboard-Paste</li>
            <li><strong>Neu:</strong> Speichern-Button sticky am unteren Rand (immer sichtbar)</li>
            <li><strong>Neu:</strong> Erste Filiale wird automatisch aktiv/selektiert mit ge&ouml;ffnetem Popup</li>
            <li><strong>Verbessert:</strong> &Ouml;ffnungszeiten-Spalte mit Mindestbreite (kein h&auml;sslicher Umbruch)</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.2.1 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> &Ouml;ffnungszeiten werden beim Bearbeiten aus DB geladen (nicht mehr Template-Defaults)</li>
            <li><strong>Behoben:</strong> Sondertage werden beim Bearbeiten korrekt geladen</li>
            <li><strong>Neu:</strong> Galerie Drag &amp; Drop Upload</li>
            <li><strong>Neu:</strong> Video-Thumbnail-Pfade auf mediafiles/ migriert</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.9 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> Bilder-Upload auf /mediafiles/ umgestellt (persistiert bei Plugin-Updates)</li>
            <li><strong>Neu:</strong> 2-Spalten Card-Layout (Kontakt links, &Ouml;ffnungszeiten rechts)</li>
            <li><strong>Neu:</strong> Automatische Migration bestehender Bilder beim Plugin-Update</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.8 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> Alle 12+ Backend-Toggles (Adresse, Telefon, E-Mail, Status, Route-Button etc.) werden jetzt im Template gepr&uuml;ft</li>
            <li><strong>Behoben:</strong> Telefon-Farbe lesbar auf Gold-Hintergrund (color: #000)</li>
            <li><strong>Behoben:</strong> Adresse einzeilig (Stra&szlig;e, PLZ Stadt)</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.7 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> Wrapper max-width auf none gesetzt (beide CSS-Dateien)</li>
            <li><strong>Verbessert:</strong> CSS referenz-genau an OPC-Section angepasst (25px Name, #cccc66 Cards, 33%/67% Spalten)</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.6 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> Doppelte Consent-Abfrage &ndash; eigene Consent-Box deaktiviert, JTL Consent Manager &uuml;bernimmt</li>
            <li><strong>Behoben:</strong> Mobile &quot;Karte wird geladen&quot; bleibt nicht mehr stehen</li>
            <li><strong>Neu:</strong> Filialname im Edit-Header mit Live-Update</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.5 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Neu:</strong> &Ouml;ffnungszeiten in Filial-Cards als Smart-Zusammenfassung (Mo-Fr gruppiert)</li>
            <li><strong>Neu:</strong> Telefon mit &quot;Telefon:&quot; Label</li>
            <li><strong>Verbessert:</strong> CSS referenz-genau an OPC-Section angepasst</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.4 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> &Ouml;ffnungszeiten-Speicher-Bug &ndash; PHP liest jetzt korrekte POST-Feldnamen</li>
            <li><strong>Behoben:</strong> Land &quot;DE&quot; wird nur angezeigt wenn card_show_country aktiviert</li>
            <li><strong>Behoben:</strong> evaluateTimeRange() mit Zeitformat-Normalisierung und strtotime-Guard</li>
            <li><strong>Neu:</strong> Barrierefreiheit: aria-label, role=&quot;status&quot;, focus-visible</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.3 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> Leaflet Marker-Icon 404 &ndash; Standard-PNGs hinzugef&uuml;gt + SVG-DivIcon als Default</li>
            <li><strong>Behoben:</strong> &Ouml;ffnungsstatus zeigt &quot;unknown&quot; statt &quot;Geschlossen&quot; wenn keine Zeiten konfiguriert</li>
            <li><strong>Neu:</strong> Marker-Icon Admin (SVG/Default/Custom mit Farbw&auml;hler)</li>
            <li><strong>Verbessert:</strong> Zoom bei einzelnem Marker auf konfigurierten Wert statt fitBounds</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.2 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> OPC-sichere Karten-Initialisierung &ndash; Branch-Daten als data-branches Attribut</li>
            <li><strong>Behoben:</strong> JTL Consent Manager Integration (kein eigener Consent-Dialog mehr)</li>
            <li><strong>Behoben:</strong> Custom CSS Auto-Import aus docs/ bei Plugin-Update</li>
            <li><strong>Neu:</strong> JS-Dateien (core, leaflet, geo) werden &uuml;ber Bootstrap.php geladen</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.1 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-20</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Behoben:</strong> JSON-Escaping in data-settings/data-status Attributen</li>
            <li><strong>Neu:</strong> MapTiler API-Key Feld im Admin + {ldelim}apikey{rdelim} Platzhalter-Ersetzung</li>
            <li><strong>Neu:</strong> Karten-Fallback bei fehlenden Koordinaten mit OSM/Google Maps Links</li>
            <li><strong>Neu:</strong> Selektives Asset-Loading via isFilialfinderPage()</li>
        </ul>
    </div>

    <div style="margin-bottom:24px;">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.1.0 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-19</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li><strong>Neu:</strong> Auto-Geocoding beim Speichern einer Filiale</li>
            <li><strong>Neu:</strong> Feiertags-Kalender mit iCal-Import</li>
            <li><strong>Neu:</strong> Detail-Modal (Galerie, Videos, Beschreibung)</li>
            <li><strong>Neu:</strong> Import/Export (CSV, JSON, XML)</li>
            <li><strong>Neu:</strong> Tags und Frontend-Filter</li>
            <li><strong>Neu:</strong> OpenFreeMap und MapTiler als Tile-Provider</li>
            <li><strong>Neu:</strong> JTL Consent Manager Integration via info.xml</li>
        </ul>
    </div>

    <div class="bbf-changelog-entry">
        <h4 style="margin:0 0 12px;color:var(--bbf-primary);">Version 1.0.0 <span style="font-weight:400;font-size:0.85em;color:#999;">&ndash; 2026-03-18</span></h4>
        <ul style="margin:0;padding-left:20px;line-height:1.8;">
            <li>Filialen anlegen, bearbeiten, l&ouml;schen mit voller CRUD-Funktionalit&auml;t</li>
            <li>&Ouml;ffnungszeiten-Management mit Sondertagen und Feiertagen</li>
            <li>Automatische &Ouml;ffnungsstatus-Berechnung</li>
            <li>Google Maps und OpenStreetMap Integration</li>
            <li>5 Frontend-Darstellungsvorlagen (Karte &amp; Liste, Nur Karte, Grid, Akkordeon, Tabelle)</li>
            <li>OPC-Portlet und Smarty-Variable</li>
            <li>Consent Manager Integration (DSGVO-konform)</li>
            <li>CSS-Editor, Geolokation, Umkreissuche</li>
            <li>Responsive Design, Marker-Clustering, Routenplanung</li>
        </ul>
    </div>
</div>
