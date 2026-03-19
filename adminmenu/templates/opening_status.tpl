<form id="bbf-opening-status-form">

  <div class="bbf-card">
    <div class="bbf-card-title">
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
      Öffnungsstatus-Konfiguration
    </div>

    {* Status anzeigen *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Status anzeigen</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_status_show" value="1"{if $allSettings.status_show|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Öffnungsstatus in der Filialübersicht anzeigen
      </label>
    </div>

    {* "Jetzt geöffnet" Text *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">"Jetzt geöffnet" Text</label>
      <input type="text" name="setting_status_open_text" class="bbf-form-control" value="{$allSettings.status_open_text|default:'Jetzt geöffnet'|escape:'html'}" placeholder="Jetzt geöffnet">
    </div>

    {* "Jetzt geschlossen" Text *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">"Jetzt geschlossen" Text</label>
      <input type="text" name="setting_status_closed_text" class="bbf-form-control" value="{$allSettings.status_closed_text|default:'Geschlossen'|escape:'html'}" placeholder="Geschlossen">
    </div>

    {* "Öffnet bald" Text *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">"Öffnet bald" Text</label>
      <input type="text" name="setting_status_opening_soon_text" class="bbf-form-control" value="{$allSettings.status_opening_soon_text|default:'Öffnet bald'|escape:'html'}" placeholder="Öffnet bald">
    </div>

    {* "Schließt bald" Text *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">"Schließt bald" Text</label>
      <input type="text" name="setting_status_closing_soon_text" class="bbf-form-control" value="{$allSettings.status_closing_soon_text|default:'Schließt bald'|escape:'html'}" placeholder="Schließt bald">
    </div>

    {* "Öffnet bald" Minuten *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">"Öffnet bald" Minuten</label>
      <input type="number" name="setting_status_opening_soon_minutes" class="bbf-form-control" value="{$allSettings.status_opening_soon_minutes|default:30}" min="0" max="120" style="max-width: 200px;">
      <p class="bbf-form-hint">Minuten vor Öffnung, ab denen der Status "Öffnet bald" angezeigt wird.</p>
    </div>

    {* "Schließt bald" Minuten *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">"Schließt bald" Minuten</label>
      <input type="number" name="setting_status_closing_soon_minutes" class="bbf-form-control" value="{$allSettings.status_closing_soon_minutes|default:30}" min="0" max="120" style="max-width: 200px;">
      <p class="bbf-form-hint">Minuten vor Schließung, ab denen der Status "Schließt bald" angezeigt wird.</p>
    </div>

    {* Nächste Öffnung anzeigen *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Nächste Öffnung anzeigen</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_status_show_next_opening" value="1"{if $allSettings.status_show_next_opening|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Bei geschlossenen Filialen die nächste Öffnungszeit anzeigen
      </label>
    </div>

    {* Zeitzone *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Zeitzone</label>
      <select name="setting_status_timezone" class="bbf-form-control" style="max-width: 300px;">
        <option value="Europe/Berlin"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Berlin'} selected{/if}>Europe/Berlin (MEZ/MESZ)</option>
        <option value="Europe/Vienna"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Vienna'} selected{/if}>Europe/Vienna (MEZ/MESZ)</option>
        <option value="Europe/Zurich"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Zurich'} selected{/if}>Europe/Zurich (MEZ/MESZ)</option>
        <option value="Europe/London"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/London'} selected{/if}>Europe/London (GMT/BST)</option>
        <option value="Europe/Paris"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Paris'} selected{/if}>Europe/Paris (MEZ/MESZ)</option>
        <option value="Europe/Amsterdam"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Amsterdam'} selected{/if}>Europe/Amsterdam (MEZ/MESZ)</option>
        <option value="Europe/Brussels"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Brussels'} selected{/if}>Europe/Brussels (MEZ/MESZ)</option>
        <option value="Europe/Madrid"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Madrid'} selected{/if}>Europe/Madrid (MEZ/MESZ)</option>
        <option value="Europe/Rome"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Rome'} selected{/if}>Europe/Rome (MEZ/MESZ)</option>
        <option value="Europe/Warsaw"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Warsaw'} selected{/if}>Europe/Warsaw (MEZ/MESZ)</option>
        <option value="Europe/Prague"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Prague'} selected{/if}>Europe/Prague (MEZ/MESZ)</option>
        <option value="Europe/Istanbul"{if $allSettings.status_timezone|default:'Europe/Berlin' eq 'Europe/Istanbul'} selected{/if}>Europe/Istanbul (TRT)</option>
      </select>
      <p class="bbf-form-hint">Zeitzone für die Berechnung des Öffnungsstatus.</p>
    </div>

    {* Animierter Status-Punkt *}
    <div class="bbf-form-group">
      <label class="bbf-form-label">Animierter Status-Punkt</label>
      <label class="bbf-toggle-label">
        <label class="bbf-toggle">
          <input type="checkbox" name="setting_status_animated_dot" value="1"{if $allSettings.status_animated_dot|default:'0' eq '1'} checked{/if}>
          <span class="bbf-toggle-slider"></span>
        </label>
        Pulsierenden Punkt neben dem Status anzeigen
      </label>
    </div>
  </div>

  {* ── Save Button ── *}
  <div class="bbf-flex bbf-gap-8" style="justify-content: flex-end;">
    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-opening-status-form', 'opening_status')">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
      Einstellungen speichern
    </button>
  </div>

</form>
