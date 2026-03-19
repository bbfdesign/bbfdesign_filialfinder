<div class="bbf-card">
    <div class="bbf-card-title">Dokumentation</div>
    <p class="bbf-text-muted">Umfassende Anleitung zur Konfiguration und Nutzung des BBF Filialfinders.</p>
</div>

<div class="bbf-accordion">

    {* ===== 1. Erste Schritte / Schnellstart ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Erste Schritte / Schnellstart
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Willkommen beim BBF Filialfinder! Nach der Installation des Plugins in Ihrem JTL-Shop stehen Ihnen
                sofort alle Funktionen zur Verf&uuml;gung. Dieser Schnellstart-Leitfaden f&uuml;hrt Sie in wenigen
                Schritten zur ersten funktionierenden Filialanzeige.
            </p>
            <p>
                <strong>Schritt 1 &ndash; Plugin installieren:</strong> Laden Sie das Plugin &uuml;ber den JTL-Plugin-Manager
                hoch und aktivieren Sie es. Nach der Aktivierung erscheint der Men&uuml;punkt &quot;BBF Filialfinder&quot;
                in Ihrer Admin-Seitenleiste.
            </p>
            <p>
                <strong>Schritt 2 &ndash; Erste Filiale anlegen:</strong> Navigieren Sie zu &quot;Standorte&quot; und klicken
                Sie auf &quot;Neue Filiale&quot;. Geben Sie mindestens den Namen, die Adresse und die &Ouml;ffnungszeiten ein.
                Die Koordinaten k&ouml;nnen automatisch per Geocoding aus der Adresse ermittelt werden.
            </p>
            <p>
                <strong>Schritt 3 &ndash; Kartenanbieter konfigurieren:</strong> W&auml;hlen Sie unter &quot;Kartenanbieter&quot;
                zwischen Google Maps (API-Key erforderlich) oder OpenStreetMap (kostenlos, kein API-Key n&ouml;tig). F&uuml;r
                OpenStreetMap stehen verschiedene Tile-Server zur Auswahl.
            </p>
            <p>
                <strong>Schritt 4 &ndash; Einbindung im Frontend:</strong> Nutzen Sie entweder das OPC-Portlet per Drag &amp; Drop
                oder die Smarty-Variable <code>{literal}{bbf_filialfinder}{/literal}</code> in Ihren Templates. W&auml;hlen Sie
                unter &quot;Vorlagen&quot; das gew&uuml;nschte Layout aus &ndash; fertig!
            </p>
        </div>
    </div>

    {* ===== 2. Filialen verwalten ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Filialen verwalten
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Die Filialverwaltung ist das Herzst&uuml;ck des Plugins. Unter &quot;Standorte&quot; finden Sie eine
                &uuml;bersichtliche Liste aller angelegten Filialen mit Schnellzugriff auf die wichtigsten Aktionen:
                Bearbeiten, Duplizieren und L&ouml;schen.
            </p>
            <p>
                <strong>&Ouml;ffnungszeiten:</strong> F&uuml;r jede Filiale k&ouml;nnen individuelle &Ouml;ffnungszeiten
                pro Wochentag hinterlegt werden. Unterst&uuml;tzt werden auch Mittagspausen (zwei Zeitfenster pro Tag)
                sowie komplett geschlossene Tage. Die &Ouml;ffnungszeiten bilden die Grundlage f&uuml;r die automatische
                Statusberechnung im Frontend.
            </p>
            <p>
                <strong>Sondertage und Feiertage:</strong> Neben den regul&auml;ren &Ouml;ffnungszeiten k&ouml;nnen Sie
                Sondertage definieren, an denen abweichende Zeiten gelten oder die Filiale komplett geschlossen ist.
                Dies eignet sich ideal f&uuml;r Feiertage, Betriebsferien oder besondere Veranstaltungen.
            </p>
            <p>
                <strong>Geocoding:</strong> Geben Sie die Adresse einer Filiale ein und lassen Sie die Koordinaten
                automatisch ermitteln. Das Geocoding funktioniert sowohl mit Google Maps als auch mit dem
                kostenlosen Nominatim-Dienst von OpenStreetMap. Die Koordinaten werden f&uuml;r die Kartenanzeige
                und die Umkreissuche ben&ouml;tigt.
            </p>
            <p>
                <strong>Filialbilder:</strong> Jeder Filiale k&ouml;nnen ein oder mehrere Bilder zugeordnet werden.
                Diese werden je nach gew&auml;hltem Layout in der Filialliste, der Detailansicht oder im Karten-Popup
                angezeigt. Die Bilder k&ouml;nnen optional automatisch komprimiert werden (siehe Performance-Einstellungen).
            </p>
        </div>
    </div>

    {* ===== 3. Kartenintegration ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Kartenintegration
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Der BBF Filialfinder unterst&uuml;tzt zwei Kartenanbieter: Google Maps und OpenStreetMap. Beide
                Anbieter bieten eine vollwertige interaktive Kartenanzeige mit Markern, Popups und optionalem Clustering.
            </p>
            <p>
                <strong>Google Maps:</strong> F&uuml;r die Nutzung von Google Maps ben&ouml;tigen Sie einen g&uuml;ltigen
                API-Key von der Google Cloud Console. Aktivieren Sie dort die APIs &quot;Maps JavaScript API&quot; und
                &quot;Geocoding API&quot;. Der API-Key wird unter &quot;Kartenanbieter&quot; hinterlegt. Google Maps bietet
                zus&auml;tzliche Funktionen wie Stra&szlig;enansicht und erweiterte Kartenstile.
            </p>
            <p>
                <strong>OpenStreetMap:</strong> OpenStreetMap ist kostenlos und ben&ouml;tigt keinen API-Key. Es stehen
                7 verschiedene Tile-Server zur Verf&uuml;gung, darunter die Standard-OSM-Kacheln, CartoDB (hell und dunkel),
                Stamen-Karten und weitere Varianten. Die Darstellung basiert auf der Leaflet-Bibliothek.
            </p>
            <p>
                <strong>Marker-Anpassung:</strong> Die Kartenmarker k&ouml;nnen farblich angepasst werden (siehe Farben &amp; Styling).
                Bei vielen Standorten wird automatisch Marker-Clustering aktiviert, um die &Uuml;bersichtlichkeit zu gew&auml;hrleisten.
                Beim Klick auf einen Cluster wird in die entsprechende Region gezoomt.
            </p>
            <p>
                <strong>Kartenstile:</strong> Beide Anbieter erlauben die Anpassung des Kartenstils. Bei Google Maps k&ouml;nnen
                Sie einen JSON-Stil hinterlegen, bei OpenStreetMap w&auml;hlen Sie den gew&uuml;nschten Tile-Server aus.
                Die Kartenh&ouml;he und der initiale Zoom-Level sind ebenfalls konfigurierbar.
            </p>
        </div>
    </div>

    {* ===== 4. Darstellung & Design ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Darstellung &amp; Design
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Der Filialfinder bietet f&uuml;nf verschiedene Frontend-Vorlagen, die sich nahtlos in jedes Shop-Design
                einf&uuml;gen lassen: &quot;Karte &amp; Liste&quot; (Standard), &quot;Nur Karte&quot;, &quot;Grid&quot;,
                &quot;Akkordeon&quot; und &quot;Tabelle&quot;. Jede Vorlage ist vollst&auml;ndig responsiv.
            </p>
            <p>
                <strong>Farben und Styling:</strong> Unter &quot;Farben &amp; Styling&quot; k&ouml;nnen Sie alle
                relevanten Farben anpassen: Prim&auml;rfarbe, Sekund&auml;rfarbe, Hintergrund, Text, Marker sowie
                die Akzentfarben f&uuml;r den Ge&ouml;ffnet/Geschlossen-Status. &Auml;nderungen werden in der
                Live-Vorschau sofort sichtbar.
            </p>
            <p>
                <strong>CSS-Editor:</strong> F&uuml;r erweiterte Anpassungen steht ein integrierter CSS-Editor mit
                Syntax-Highlighting zur Verf&uuml;gung. Hier k&ouml;nnen Sie eigene CSS-Regeln hinterlegen, die
                zus&auml;tzlich zu den Plugin-Styles geladen werden. Der Editor unterst&uuml;tzt Auto-Vervollst&auml;ndigung
                und zeigt eine Vorschau der &Auml;nderungen.
            </p>
            <p>
                <strong>CSS-Klassen-Referenz:</strong> Alle Plugin-Elemente verwenden einheitliche CSS-Klassen mit dem
                Pr&auml;fix <code>bbf-filialfinder-</code>. Die wichtigsten Klassen sind:
                <code>.bbf-filialfinder-wrapper</code> (Hauptcontainer),
                <code>.bbf-filialfinder-layout--default</code> (Standard-Layout),
                <code>.bbf-filialfinder-list</code> (Filialliste),
                <code>.bbf-filialfinder-card</code> (Einzelne Filial-Karte),
                <code>.bbf-filialfinder-card--active</code> (Aktive/ausgew&auml;hlte Karte),
                <code>.bbf-filialfinder-card-name</code> (Filialname),
                <code>.bbf-filialfinder-card-address</code> (Adresse),
                <code>.bbf-filialfinder-card-phone</code> (Telefon),
                <code>.bbf-filialfinder-map</code> (Karten-Container),
                <code>.bbf-filialfinder-status</code> (&Ouml;ffnungsstatus Badge),
                <code>.bbf-filialfinder-status--open</code> (Ge&ouml;ffnet),
                <code>.bbf-filialfinder-status--closed</code> (Geschlossen),
                <code>.bbf-filialfinder-btn</code> (Button Basis) und
                <code>.bbf-filialfinder-btn--route</code> (Route-Button).
            </p>
            <p>
                <strong>Template-Overrides:</strong> Fortgeschrittene Benutzer k&ouml;nnen die Frontend-Templates
                direkt &uuml;berschreiben. Kopieren Sie dazu die gew&uuml;nschte Template-Datei aus dem Plugin-Verzeichnis
                in Ihr Theme-Verzeichnis unter <code>templates/plugins/bbfdesign_filialfinder/</code>. &Auml;nderungen dort
                bleiben bei Plugin-Updates erhalten.
            </p>
        </div>
    </div>

    {* ===== 5. OPC-Portlet ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            OPC-Portlet
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Der einfachste Weg, den Filialfinder in Ihren Shop einzubinden, ist das OPC-Portlet. &Ouml;ffnen Sie
                den JTL-OPC-Editor f&uuml;r die gew&uuml;nschte Seite und ziehen Sie das &quot;BBF Filialfinder&quot;-Portlet
                per Drag &amp; Drop an die gew&uuml;nschte Stelle.
            </p>
            <p>
                <strong>Portlet-Einstellungen:</strong> Im Portlet-Dialog k&ouml;nnen Sie das Layout, die anzuzeigenden
                Filialen und weitere Optionen konfigurieren. W&auml;hlen Sie zwischen allen f&uuml;nf verf&uuml;gbaren
                Vorlagen und legen Sie fest, ob alle oder nur bestimmte Filialen angezeigt werden sollen.
            </p>
            <p>
                <strong>Mehrere Portlets:</strong> Sie k&ouml;nnen mehrere Filialfinder-Portlets auf einer Seite platzieren,
                beispielsweise eine Kartenansicht oben und eine Tabellenansicht weiter unten. Jedes Portlet kann unabh&auml;ngig
                konfiguriert werden.
            </p>
            <p>
                Das OPC-Portlet erbt automatisch alle globalen Einstellungen (Farben, Kartenanbieter, Consent-Einstellungen).
                Portlet-spezifische Einstellungen wie Layout und Filialauswahl &uuml;berschreiben die globalen Standardwerte.
            </p>
        </div>
    </div>

    {* ===== 6. Smarty-Integration ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Smarty-Integration
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                F&uuml;r die direkte Einbindung in Smarty-Templates steht die Smarty-Variable
                <code>{literal}{bbf_filialfinder}{/literal}</code> zur Verf&uuml;gung. Diese kann in jedem
                Template Ihres JTL-Shops verwendet werden und bietet maximale Flexibilit&auml;t bei der Positionierung.
            </p>
            <p>
                <strong>Parameter-Referenz:</strong> Die Smarty-Variable akzeptiert mehrere optionale Parameter:
                <code>layout</code> (Vorlage: default, map_only, grid, accordion, table),
                <code>branches</code> (Filial-IDs: &quot;all&quot; oder kommaseparierte IDs),
                <code>limit</code> (maximale Anzahl anzuzeigender Filialen).
            </p>
            <p>
                <strong>Beispiele:</strong>
            </p>
            <pre><code>{literal}{bbf_filialfinder layout="default" branches="all"}{/literal}</code></pre>
            <pre><code>{literal}{bbf_filialfinder layout="map_only" branches="1,3,5"}{/literal}</code></pre>
            <pre><code>{literal}{bbf_filialfinder layout="grid" limit="4"}{/literal}</code></pre>
            <p>
                Ohne Angabe von Parametern wird das in den Plugin-Einstellungen hinterlegte Standard-Layout mit allen
                aktiven Filialen verwendet. Die Smarty-Variable kann auch in CMS-Seiten, Boxen und E-Mail-Templates
                eingesetzt werden, sofern der Smarty-Parser dort aktiv ist.
            </p>
        </div>
    </div>

    {* ===== 7. Consent Manager / Datenschutz ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Consent Manager / Datenschutz
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Die DSGVO-konforme Einbindung von Kartendiensten ist ein zentrales Feature des BBF Filialfinders.
                Wenn die Consent-Abfrage aktiviert ist, werden keine externen Ressourcen geladen, bevor der Benutzer
                seine Einwilligung erteilt hat.
            </p>
            <p>
                <strong>Funktionsweise:</strong> Anstelle der interaktiven Karte wird ein Platzhalter angezeigt. Dieser
                enth&auml;lt den konfigurierbaren Platzhalter-Text und optional ein statisches Kartenbild. Ein
                Button erm&ouml;glicht es dem Benutzer, die Einwilligung direkt zu erteilen, woraufhin die Karte
                nachgeladen wird.
            </p>
            <p>
                <strong>JTL Consent Manager:</strong> Das Plugin integriert sich nahtlos in den JTL Consent Manager.
                Die Consent-Kategorie wird automatisch anhand des gew&auml;hlten Kartenanbieters zugeordnet. Stellen
                Sie sicher, dass die entsprechende Kategorie (Google Maps oder OpenStreetMap) im Consent Manager
                Ihres Shops korrekt angelegt ist.
            </p>
            <p>
                Bei aktivierter Consent-Abfrage werden s&auml;mtliche externen Skripte, Stylesheets und Kartendaten
                erst nach expliziter Zustimmung geladen. Dies umfasst die Karten-API, Tile-Server-Anfragen und
                eventuelle Geocoding-Aufrufe. Damit erf&uuml;llt der Filialfinder alle Anforderungen der DSGVO.
            </p>
        </div>
    </div>

    {* ===== 8. Öffnungsstatus-Logik ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            &Ouml;ffnungsstatus-Logik
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Der Filialfinder berechnet den aktuellen &Ouml;ffnungsstatus jeder Filiale automatisch anhand der
                hinterlegten &Ouml;ffnungszeiten und Sondertage. Es werden vier Status-Varianten unterschieden:
                &quot;Jetzt ge&ouml;ffnet&quot;, &quot;Geschlossen&quot;, &quot;&Ouml;ffnet bald&quot; und &quot;Schlie&szlig;t bald&quot;.
            </p>
            <p>
                <strong>Algorithmus:</strong> Zun&auml;chst wird gepr&uuml;ft, ob f&uuml;r das aktuelle Datum ein Sondertag
                definiert ist. Falls ja, gelten dessen Zeiten. Andernfalls werden die regul&auml;ren &Ouml;ffnungszeiten
                des aktuellen Wochentags herangezogen. Die Berechnung ber&uuml;cksichtigt die konfigurierte Zeitzone
                des Shops.
            </p>
            <p>
                <strong>&quot;&Ouml;ffnet bald&quot; / &quot;Schlie&szlig;t bald&quot;:</strong> Diese &Uuml;bergangszeiten
                werden angezeigt, wenn die &Ouml;ffnung oder Schlie&szlig;ung innerhalb eines konfigurierbaren Zeitfensters
                liegt (Standard: 30 Minuten). So erhalten Kunden eine genauere Information &uuml;ber den aktuellen Status.
            </p>
            <p>
                <strong>Mittagspausen:</strong> Wenn f&uuml;r einen Tag zwei Zeitfenster definiert sind, wird die Zeit
                zwischen den beiden Fenstern als Mittagspause interpretiert. W&auml;hrend der Mittagspause zeigt der
                Status &quot;Geschlossen&quot; an, mit einem Hinweis auf die Wiederer&ouml;ffnung am selben Tag.
            </p>
            <p>
                Die Statusanzeige wird im Frontend farblich hervorgehoben. Die Farben f&uuml;r &quot;Ge&ouml;ffnet&quot;
                und &quot;Geschlossen&quot; sind unter &quot;Farben &amp; Styling&quot; konfigurierbar. Die Berechnung
                erfolgt serverseitig und wird f&uuml;r eine konfigurierbare Dauer gecacht.
            </p>
        </div>
    </div>

    {* ===== 9. Geolokation & Umkreissuche ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Geolokation &amp; Umkreissuche
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Die Geolokation erm&ouml;glicht es, den Standort des Benutzers automatisch zu ermitteln und die
                n&auml;chstgelegenen Filialen hervorzuheben. Diese Funktion nutzt die HTML5 Geolocation API des Browsers
                und erfordert die Zustimmung des Benutzers.
            </p>
            <p>
                <strong>Umkreissuche:</strong> Wenn aktiviert, k&ouml;nnen Benutzer nach Filialen in einem bestimmten
                Umkreis suchen. Der Standard-Suchradius ist konfigurierbar (Standardwert: 50 km). Die Suche kann
                sowohl nach dem aktuellen Standort als auch nach einer manuell eingegebenen Adresse oder Postleitzahl erfolgen.
            </p>
            <p>
                <strong>Entfernungsanzeige:</strong> Optional kann die Entfernung zu jeder Filiale angezeigt werden.
                Die Berechnung erfolgt &uuml;ber die Haversine-Formel und ber&uuml;cksichtigt die Erdkr&uuml;mmung.
                Die Einheit (Kilometer oder Meilen) ist einstellbar.
            </p>
            <p>
                <strong>Suchfeld:</strong> Das optionale Suchfeld erlaubt es Benutzern, einen Ort, eine Postleitzahl
                oder eine Adresse einzugeben. Die Eingabe wird per Geocoding in Koordinaten umgewandelt und als
                Mittelpunkt f&uuml;r die Umkreissuche verwendet. Autocomplete-Vorschl&auml;ge werden bei Nutzung
                von Google Maps automatisch angeboten.
            </p>
            <p>
                Wenn die Option &quot;N&auml;chste Filiale hervorheben&quot; aktiviert ist, wird die Filiale mit der
                geringsten Entfernung zum Benutzer visuell hervorgehoben &ndash; sowohl in der Filialliste als auch
                auf der Karte durch einen speziellen Marker.
            </p>
        </div>
    </div>

    {* ===== 10. Performance & Optimierung ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Performance &amp; Optimierung
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                Der BBF Filialfinder bietet mehrere Performance-Optionen, um die Ladezeit Ihres Shops nicht
                unn&ouml;tig zu belasten. Alle Optimierungen k&ouml;nnen unabh&auml;ngig voneinander aktiviert werden.
            </p>
            <p>
                <strong>Lazy Loading:</strong> Wenn aktiviert, wird die Karte erst geladen, wenn sie in den sichtbaren
                Bereich des Browsers scrollt. Dies ist besonders n&uuml;tzlich, wenn der Filialfinder weiter unten
                auf der Seite platziert ist. Die Erkennung erfolgt &uuml;ber die IntersectionObserver API.
            </p>
            <p>
                <strong>Selektives Asset-Loading:</strong> Standardm&auml;&szlig;ig werden die JavaScript- und CSS-Dateien
                des Plugins auf allen Seiten geladen. Mit dieser Option werden die Assets nur auf Seiten eingebunden,
                auf denen der Filialfinder tats&auml;chlich verwendet wird. Dies reduziert die Gesamtladezeit des Shops.
            </p>
            <p>
                <strong>Footer-Scripts:</strong> Verschiebt die Karten-Skripte in den Footer-Bereich der Seite.
                Dadurch wird das Rendering der Seite nicht durch das Laden der Karten-API blockiert.
                Diese Option wird f&uuml;r die meisten Shops empfohlen.
            </p>
            <p>
                <strong>Bildoptimierung:</strong> Filialbilder k&ouml;nnen automatisch komprimiert werden, um die
                Dateigr&ouml;&szlig;e zu reduzieren. Die Komprimierung erfolgt verlustfrei und beh&auml;lt die
                Originalqualit&auml;t bei. Zus&auml;tzlich werden responsive Bildvarianten f&uuml;r verschiedene
                Bildschirmgr&ouml;&szlig;en erzeugt.
            </p>
        </div>
    </div>

    {* ===== 11. Template-Overrides & Anpassungen ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            Template-Overrides &amp; Anpassungen
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                F&uuml;r fortgeschrittene Anpassungen k&ouml;nnen Sie die Frontend-Templates des Plugins &uuml;berschreiben,
                ohne den Plugin-Code direkt zu &auml;ndern. So bleiben Ihre Anpassungen auch nach Plugin-Updates erhalten.
            </p>
            <p>
                <strong>Override-Verzeichnis:</strong> Kopieren Sie die gew&uuml;nschte Template-Datei aus dem
                Plugin-Ordner <code>frontend/template/</code> in das Verzeichnis
                <code>templates/{ldelim}ihr-template{rdelim}/plugins/bbfdesign_filialfinder/</code> Ihres aktiven
                JTL-Templates. Der Filialfinder verwendet automatisch die Override-Datei, wenn sie vorhanden ist.
            </p>
            <p>
                <strong>Verf&uuml;gbare Template-Variablen:</strong> In den Frontend-Templates stehen Ihnen alle
                Filialdaten als Smarty-Variablen zur Verf&uuml;gung, darunter <code>$branches</code> (Array aller Filialen),
                <code>$settings</code> (Plugin-Einstellungen) und <code>$mapProvider</code> (aktiver Kartenanbieter).
            </p>
            <p>
                <strong>Eigene CSS-Klassen:</strong> Alle Plugin-Elemente nutzen das Pr&auml;fix <code>bbf-</code>.
                Sie k&ouml;nnen &uuml;ber den integrierten CSS-Editor zus&auml;tzliche Styles definieren oder eigene
                CSS-Dateien in Ihr Theme einbinden. Die Plugin-Styles haben eine moderate Spezifit&auml;t, sodass
                sie leicht &uuml;berschrieben werden k&ouml;nnen.
            </p>
            <p>
                <strong>Hinweis:</strong> Wenn Sie ein Template &uuml;berschreiben, pr&uuml;fen Sie nach jedem
                Plugin-Update, ob sich die Struktur der Original-Templates ge&auml;ndert hat. Im Changelog werden
                Template-&Auml;nderungen stets dokumentiert, damit Sie Ihre Overrides entsprechend aktualisieren k&ouml;nnen.
            </p>
        </div>
    </div>

    {* ===== 12. FAQ / Fehlerbehebung ===== *}
    <div class="bbf-accordion-item">
        <div class="bbf-accordion-header">
            FAQ / Fehlerbehebung
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="bbf-accordion-body">
            <p>
                <strong>Die Karte wird nicht angezeigt:</strong> Pr&uuml;fen Sie zun&auml;chst, ob der Consent Manager
                aktiv ist und die Karte m&ouml;glicherweise blockiert wird. &Ouml;ffnen Sie die Browser-Konsole (F12) und
                suchen Sie nach JavaScript-Fehlern. Bei Google Maps stellen Sie sicher, dass der API-Key g&uuml;ltig ist
                und die ben&ouml;tigten APIs aktiviert sind.
            </p>
            <p>
                <strong>Geocoding funktioniert nicht:</strong> F&uuml;r Google Maps muss die &quot;Geocoding API&quot;
                in der Google Cloud Console aktiviert sein. Bei OpenStreetMap wird der Nominatim-Dienst verwendet, der
                ein Rate-Limit von einer Anfrage pro Sekunde hat. Warten Sie bei vielen Filialen zwischen den
                Geocoding-Anfragen.
            </p>
            <p>
                <strong>Falsche &Ouml;ffnungszeiten:</strong> Pr&uuml;fen Sie die Zeitzone Ihres Servers und Shops.
                Der Filialfinder verwendet die konfigurierte Shop-Zeitzone f&uuml;r alle Berechnungen. Stellen Sie
                zudem sicher, dass keine Sondertage die regul&auml;ren &Ouml;ffnungszeiten &uuml;berschreiben.
            </p>
            <p>
                <strong>Styling-&Auml;nderungen sind nicht sichtbar:</strong> Leeren Sie den Template-Cache Ihres
                JTL-Shops unter &quot;System &gt; Cache&quot;. Pr&uuml;fen Sie auch den Browser-Cache. Wenn Sie
                Template-Overrides verwenden, stellen Sie sicher, dass die Dateien im richtigen Verzeichnis liegen
                und die Dateinamen exakt &uuml;bereinstimmen.
            </p>
            <p>
                <strong>Performance-Probleme:</strong> Aktivieren Sie Lazy Loading und selektives Asset-Loading.
                Bei sehr vielen Filialen (mehr als 100) empfiehlt sich zus&auml;tzlich die Aktivierung von
                Marker-Clustering und die Begrenzung der initial angezeigten Filialen &uuml;ber den
                <code>limit</code>-Parameter.
            </p>
        </div>
    </div>

</div>
