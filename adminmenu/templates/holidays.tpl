{* ── Main Tabs ── *}
<div class="bbf-tabs" id="bbf-holidays-tabs">
  <a href="#" class="bbf-tab-link active" data-tab="tab-holidays" onclick="bbfSwitchMainTab(event, 'tab-holidays')">Feiertage</a>
  <a href="#" class="bbf-tab-link" data-tab="tab-holiday-settings" onclick="bbfSwitchMainTab(event, 'tab-holiday-settings')">Einstellungen</a>
</div>

{* ══════════════════════════════════════════════════════════
   Tab 1: Feiertage
   ══════════════════════════════════════════════════════════ *}
<div class="bbf-tab-content active" data-tab-content="tab-holidays" id="tab-holidays">

  {* ── Section A: Kalender-Abonnements ── *}
  <div class="bbf-card">
    <div class="bbf-flex-between">
      <div class="bbf-card-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
        Kalender-Abonnements
      </div>
      <button type="button" class="bbf-btn bbf-btn-primary bbf-btn-sm" onclick="bbfShowCalendarForm()">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        Neuen Kalender hinzuf&uuml;gen
      </button>
    </div>

    {* ── Calendar Add Form (inline, hidden by default) ── *}
    <div id="bbf-calendar-form" style="display:none;margin-bottom:20px;padding:16px;background:var(--bbf-bg-secondary);border:1px solid var(--bbf-border);border-radius:var(--bbf-radius);">
      <div class="bbf-form-group">
        <label class="bbf-form-label">Name</label>
        <input type="text" class="bbf-form-control" id="bbf-calendar-name" placeholder="z.B. Deutsche Feiertage">
      </div>
      <div class="bbf-form-group">
        <label class="bbf-form-label">iCal-URL</label>
        <input type="text" class="bbf-form-control" id="bbf-calendar-url" placeholder="https://www.feiertage-deutschland.de/kalender-download/">
        <p class="bbf-form-hint">Geben Sie die URL eines iCal-Kalenders (.ics) ein. Feiertage werden automatisch importiert.</p>
      </div>
      <div style="display:flex;gap:8px;">
        <button type="button" class="bbf-btn bbf-btn-primary bbf-btn-sm" onclick="bbfSaveCalendar()">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
          Speichern
        </button>
        <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfHideCalendarForm()">Abbrechen</button>
      </div>
    </div>

    {* ── Calendars Table ── *}
    <table class="bbf-table" id="bbf-calendars-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>URL</th>
          <th style="width:80px;">Status</th>
          <th>Letzte Synchronisation</th>
          <th style="width:140px;">Aktionen</th>
        </tr>
      </thead>
      <tbody>
        {if !empty($calendars)}
          {foreach $calendars as $calendar}
            <tr data-calendar-id="{$calendar->id}">
              <td>{$calendar->name|escape:'html'}</td>
              <td>
                <span class="bbf-text-sm bbf-text-muted" title="{$calendar->url|escape:'html'}">
                  {$calendar->url|truncate:50:'...'|escape:'html'}
                </span>
              </td>
              <td>
                <label class="bbf-toggle">
                  <input type="checkbox" {if $calendar->is_active}checked{/if} onchange="bbfToggleCalendarStatus({$calendar->id}, this)">
                  <span class="bbf-toggle-slider"></span>
                </label>
              </td>
              <td>
                {if $calendar->last_sync}
                  <span class="bbf-text-sm">{$calendar->last_sync|escape:'html'}</span>
                {else}
                  <span class="bbf-text-sm bbf-text-muted">Noch nicht synchronisiert</span>
                {/if}
              </td>
              <td>
                <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm" title="Jetzt synchronisieren" onclick="bbfSyncCalendar({$calendar->id})">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
                </button>
                <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm bbf-btn-danger" title="L&ouml;schen" onclick="bbfDeleteCalendar({$calendar->id})">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                </button>
              </td>
            </tr>
          {/foreach}
        {else}
          <tr id="bbf-no-calendars-row">
            <td colspan="5" style="text-align:center;padding:30px 0;">
              <p class="bbf-text-muted">Noch keine Kalender-Abonnements vorhanden.</p>
            </td>
          </tr>
        {/if}
      </tbody>
    </table>
  </div>

  {* ── Section B: Alle Feiertage ── *}
  <div class="bbf-card">
    <div class="bbf-flex-between">
      <div class="bbf-card-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
        Alle Feiertage
      </div>
      <button type="button" class="bbf-btn bbf-btn-primary bbf-btn-sm" onclick="bbfShowHolidayForm()">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        Feiertag hinzuf&uuml;gen
      </button>
    </div>

    {* ── Holiday Add Form (inline, hidden by default) ── *}
    <div id="bbf-holiday-form" style="display:none;margin-bottom:20px;padding:16px;background:var(--bbf-bg-secondary);border:1px solid var(--bbf-border);border-radius:var(--bbf-radius);">
      <input type="hidden" id="bbf-holiday-id" value="0">

      <div class="bbf-form-row">
        <div class="bbf-form-group">
          <label class="bbf-form-label">Datum</label>
          <input type="date" class="bbf-form-control" id="bbf-holiday-date">
        </div>
        <div class="bbf-form-group">
          <label class="bbf-form-label">Name</label>
          <input type="text" class="bbf-form-control" id="bbf-holiday-name" placeholder="z.B. Weihnachten">
        </div>
      </div>

      <div class="bbf-form-row">
        <div class="bbf-form-group">
          <label class="bbf-form-label">Typ</label>
          <select class="bbf-form-control" id="bbf-holiday-type">
            <option value="holiday">Feiertag</option>
            <option value="open_sunday">Verkaufsoffener Sonntag</option>
            <option value="custom">Benutzerdefiniert</option>
          </select>
        </div>
        <div class="bbf-form-group">
          <label class="bbf-form-label">J&auml;hrlich wiederkehrend</label>
          <label class="bbf-toggle">
            <input type="checkbox" id="bbf-holiday-recurring" value="1">
            <span class="bbf-toggle-slider"></span>
          </label>
        </div>
      </div>

      <div class="bbf-form-group">
        <label class="bbf-form-label">Gilt f&uuml;r</label>
        <div style="display:flex;gap:16px;margin-bottom:8px;">
          <label style="display:flex;align-items:center;gap:6px;cursor:pointer;">
            <input type="radio" name="holiday_scope" value="all" checked onchange="bbfToggleBranchSelect()"> Alle Filialen
          </label>
          <label style="display:flex;align-items:center;gap:6px;cursor:pointer;">
            <input type="radio" name="holiday_scope" value="specific" onchange="bbfToggleBranchSelect()"> Bestimmte Filialen
          </label>
        </div>
        <div id="bbf-holiday-branches" style="display:none;padding:8px;border:1px solid var(--bbf-border);border-radius:var(--bbf-radius);max-height:200px;overflow-y:auto;">
          {if !empty($branches)}
            {foreach $branches as $branch}
              <label style="display:flex;align-items:center;gap:8px;padding:4px 0;cursor:pointer;">
                <label class="bbf-toggle">
                  <input type="checkbox" class="bbf-holiday-branch-cb" value="{$branch->id}">
                  <span class="bbf-toggle-slider"></span>
                </label>
                {$branch->name|escape:'html'}
              </label>
            {/foreach}
          {else}
            <p class="bbf-text-muted bbf-text-sm">Keine Filialen vorhanden.</p>
          {/if}
        </div>
      </div>

      <div class="bbf-form-group">
        <label class="bbf-form-label">Standard geschlossen</label>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-holiday-closed" value="1" checked>
          <span class="bbf-toggle-slider"></span>
        </label>
      </div>

      <div class="bbf-form-group">
        <label class="bbf-form-label">Trotz Feiertag ge&ouml;ffnet</label>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-holiday-open-override" value="1" onchange="bbfToggleOpenOverride()">
          <span class="bbf-toggle-slider"></span>
        </label>
        <div id="bbf-holiday-open-times" style="display:none;margin-top:8px;">
          <div class="bbf-form-row">
            <div class="bbf-form-group">
              <label class="bbf-form-label">Von</label>
              <input type="time" class="bbf-form-control" id="bbf-holiday-open-from" value="10:00" style="width:150px;">
            </div>
            <div class="bbf-form-group">
              <label class="bbf-form-label">Bis</label>
              <input type="time" class="bbf-form-control" id="bbf-holiday-open-to" value="18:00" style="width:150px;">
            </div>
          </div>
        </div>
      </div>

      <div class="bbf-form-group">
        <label class="bbf-form-label">Hervorheben im Frontend</label>
        <label class="bbf-toggle">
          <input type="checkbox" id="bbf-holiday-highlight" value="1" onchange="bbfToggleHighlight()">
          <span class="bbf-toggle-slider"></span>
        </label>
        <div id="bbf-holiday-highlight-text" style="display:none;margin-top:8px;">
          <input type="text" class="bbf-form-control" id="bbf-holiday-highlight-value" placeholder="z.B. Verkaufsoffener Sonntag! Besuchen Sie uns von 13-18 Uhr">
        </div>
      </div>

      <div class="bbf-form-group">
        <label class="bbf-form-label">Hinweis</label>
        <textarea class="bbf-form-control" id="bbf-holiday-note" rows="3" placeholder="Optionaler Hinweis..."></textarea>
      </div>

      <div style="display:flex;gap:8px;">
        <button type="button" class="bbf-btn bbf-btn-primary bbf-btn-sm" onclick="bbfSaveHoliday()">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
          Speichern
        </button>
        <button type="button" class="bbf-btn bbf-btn-secondary bbf-btn-sm" onclick="bbfHideHolidayForm()">Abbrechen</button>
      </div>
    </div>

    {* ── Holiday Sub-Tabs ── *}
    <div class="bbf-tabs" id="bbf-holiday-sub-tabs">
      <a href="#" class="bbf-tab-link active" data-tab="subtab-upcoming" onclick="bbfSwitchHolidayTab(event, 'subtab-upcoming')">Kommende</a>
      <a href="#" class="bbf-tab-link" data-tab="subtab-past" onclick="bbfSwitchHolidayTab(event, 'subtab-past')">Vergangene</a>
      <a href="#" class="bbf-tab-link" data-tab="subtab-open-sundays" onclick="bbfSwitchHolidayTab(event, 'subtab-open-sundays')">Verkaufsoffene Sonntage</a>
    </div>

    {* ── Sub-Tab: Kommende ── *}
    <div class="bbf-tab-content active" data-tab-content="subtab-upcoming" id="subtab-upcoming">
      <table class="bbf-table">
        <thead>
          <tr>
            <th>Datum</th>
            <th>Name</th>
            <th>Typ</th>
            <th>Gilt f&uuml;r</th>
            <th>Standard</th>
            <th style="width:120px;">Aktionen</th>
          </tr>
        </thead>
        <tbody>
          {if !empty($upcomingHolidays)}
            {foreach $upcomingHolidays as $holiday}
              <tr data-holiday-id="{$holiday->id}">
                <td>{$holiday->date|escape:'html'}</td>
                <td>{$holiday->name|escape:'html'}</td>
                <td>
                  {if $holiday->type eq 'holiday'}
                    <span class="bbf-badge bbf-badge-danger">Feiertag</span>
                  {elseif $holiday->type eq 'open_sunday'}
                    <span class="bbf-badge bbf-badge-success">Verkaufsoffener Sonntag</span>
                  {else}
                    <span class="bbf-badge bbf-badge-warning">Benutzerdefiniert</span>
                  {/if}
                </td>
                <td>
                  {if $holiday->scope eq 'all'}
                    <span class="bbf-text-sm">Alle Filialen</span>
                  {else}
                    <span class="bbf-text-sm bbf-text-muted">{$holiday->branch_count|default:0} Filialen</span>
                  {/if}
                </td>
                <td>
                  {if $holiday->is_closed}
                    <span class="bbf-badge bbf-badge-danger">Geschlossen</span>
                  {else}
                    <span class="bbf-badge bbf-badge-success">Ge&ouml;ffnet</span>
                  {/if}
                </td>
                <td>
                  <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm" title="Bearbeiten" onclick="bbfEditHoliday({$holiday->id})">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                  </button>
                  <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm bbf-btn-danger" title="L&ouml;schen" onclick="bbfDeleteHoliday({$holiday->id})">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                  </button>
                </td>
              </tr>
            {/foreach}
          {else}
            <tr>
              <td colspan="6" style="text-align:center;padding:30px 0;">
                <p class="bbf-text-muted">Keine kommenden Feiertage vorhanden.</p>
              </td>
            </tr>
          {/if}
        </tbody>
      </table>
    </div>

    {* ── Sub-Tab: Vergangene ── *}
    <div class="bbf-tab-content" data-tab-content="subtab-past" id="subtab-past">
      <table class="bbf-table">
        <thead>
          <tr>
            <th>Datum</th>
            <th>Name</th>
            <th>Typ</th>
            <th>Gilt f&uuml;r</th>
            <th>Standard</th>
            <th style="width:120px;">Aktionen</th>
          </tr>
        </thead>
        <tbody>
          {if !empty($holidays)}
            {assign var="hasPast" value=false}
            {foreach $holidays as $holiday}
              {if $holiday->is_past}
                {assign var="hasPast" value=true}
                <tr data-holiday-id="{$holiday->id}">
                  <td>{$holiday->date|escape:'html'}</td>
                  <td>{$holiday->name|escape:'html'}</td>
                  <td>
                    {if $holiday->type eq 'holiday'}
                      <span class="bbf-badge bbf-badge-danger">Feiertag</span>
                    {elseif $holiday->type eq 'open_sunday'}
                      <span class="bbf-badge bbf-badge-success">Verkaufsoffener Sonntag</span>
                    {else}
                      <span class="bbf-badge bbf-badge-warning">Benutzerdefiniert</span>
                    {/if}
                  </td>
                  <td>
                    {if $holiday->scope eq 'all'}
                      <span class="bbf-text-sm">Alle Filialen</span>
                    {else}
                      <span class="bbf-text-sm bbf-text-muted">{$holiday->branch_count|default:0} Filialen</span>
                    {/if}
                  </td>
                  <td>
                    {if $holiday->is_closed}
                      <span class="bbf-badge bbf-badge-danger">Geschlossen</span>
                    {else}
                      <span class="bbf-badge bbf-badge-success">Ge&ouml;ffnet</span>
                    {/if}
                  </td>
                  <td>
                    <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm bbf-btn-danger" title="L&ouml;schen" onclick="bbfDeleteHoliday({$holiday->id})">
                      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                    </button>
                  </td>
                </tr>
              {/if}
            {/foreach}
            {if !$hasPast}
              <tr>
                <td colspan="6" style="text-align:center;padding:30px 0;">
                  <p class="bbf-text-muted">Keine vergangenen Feiertage vorhanden.</p>
                </td>
              </tr>
            {/if}
          {else}
            <tr>
              <td colspan="6" style="text-align:center;padding:30px 0;">
                <p class="bbf-text-muted">Keine vergangenen Feiertage vorhanden.</p>
              </td>
            </tr>
          {/if}
        </tbody>
      </table>
    </div>

    {* ── Sub-Tab: Verkaufsoffene Sonntage ── *}
    <div class="bbf-tab-content" data-tab-content="subtab-open-sundays" id="subtab-open-sundays">
      <table class="bbf-table">
        <thead>
          <tr>
            <th>Datum</th>
            <th>Name</th>
            <th>Typ</th>
            <th>Gilt f&uuml;r</th>
            <th>Standard</th>
            <th style="width:120px;">Aktionen</th>
          </tr>
        </thead>
        <tbody>
          {if !empty($openSundays)}
            {foreach $openSundays as $holiday}
              <tr data-holiday-id="{$holiday->id}">
                <td>{$holiday->date|escape:'html'}</td>
                <td>{$holiday->name|escape:'html'}</td>
                <td>
                  <span class="bbf-badge bbf-badge-success">Verkaufsoffener Sonntag</span>
                </td>
                <td>
                  {if $holiday->scope eq 'all'}
                    <span class="bbf-text-sm">Alle Filialen</span>
                  {else}
                    <span class="bbf-text-sm bbf-text-muted">{$holiday->branch_count|default:0} Filialen</span>
                  {/if}
                </td>
                <td>
                  {if $holiday->is_closed}
                    <span class="bbf-badge bbf-badge-danger">Geschlossen</span>
                  {else}
                    <span class="bbf-badge bbf-badge-success">Ge&ouml;ffnet</span>
                  {/if}
                </td>
                <td>
                  <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm" title="Bearbeiten" onclick="bbfEditHoliday({$holiday->id})">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                  </button>
                  <button type="button" class="bbf-btn bbf-btn-icon bbf-btn-sm bbf-btn-danger" title="L&ouml;schen" onclick="bbfDeleteHoliday({$holiday->id})">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                  </button>
                </td>
              </tr>
            {/foreach}
          {else}
            <tr>
              <td colspan="6" style="text-align:center;padding:30px 0;">
                <p class="bbf-text-muted">Keine verkaufsoffenen Sonntage vorhanden.</p>
              </td>
            </tr>
          {/if}
        </tbody>
      </table>
    </div>
  </div>
</div>

{* ══════════════════════════════════════════════════════════
   Tab 2: Einstellungen
   ══════════════════════════════════════════════════════════ *}
<div class="bbf-tab-content" data-tab-content="tab-holiday-settings" id="tab-holiday-settings">
  <form id="bbf-holidays-settings-form">
    <div class="bbf-card">
      <div class="bbf-card-title">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
        Feiertag-Einstellungen
      </div>

      {* Feiertage berücksichtigen *}
      <div class="bbf-form-group">
        <div class="bbf-flex-between">
          <label class="bbf-form-label">Feiertage ber&uuml;cksichtigen</label>
          <label class="bbf-toggle">
            <input type="checkbox" name="setting_holidays_enabled" value="1"{if $allSettings.holidays_enabled|default:'0' eq '1'} checked{/if}>
            <span class="bbf-toggle-slider"></span>
          </label>
        </div>
        <p class="bbf-form-hint">Feiertage bei der Berechnung der &Ouml;ffnungszeiten ber&uuml;cksichtigen.</p>
      </div>

      {* Feiertage in Öffnungszeiten anzeigen *}
      <div class="bbf-form-group">
        <div class="bbf-flex-between">
          <label class="bbf-form-label">Feiertage in &Ouml;ffnungszeiten anzeigen</label>
          <label class="bbf-toggle">
            <input type="checkbox" name="setting_holidays_show_in_hours" value="1"{if $allSettings.holidays_show_in_hours|default:'0' eq '1'} checked{/if}>
            <span class="bbf-toggle-slider"></span>
          </label>
        </div>
        <p class="bbf-form-hint">Feiertage in der &Ouml;ffnungszeiten-Anzeige im Frontend sichtbar machen.</p>
      </div>

      {* Verkaufsoffene Sonntage hervorheben *}
      <div class="bbf-form-group">
        <div class="bbf-flex-between">
          <label class="bbf-form-label">Verkaufsoffene Sonntage hervorheben</label>
          <label class="bbf-toggle">
            <input type="checkbox" name="setting_holidays_highlight_open_sundays" value="1"{if $allSettings.holidays_highlight_open_sundays|default:'0' eq '1'} checked{/if}>
            <span class="bbf-toggle-slider"></span>
          </label>
        </div>
        <p class="bbf-form-hint">Verkaufsoffene Sonntage im Frontend farblich hervorheben.</p>
      </div>

      {* Highlight-Farbe *}
      <div class="bbf-form-group">
        <label class="bbf-form-label">Highlight-Farbe</label>
        <div style="display:flex;align-items:center;gap:12px;">
          <input type="color" id="bbf-holidays-highlight-color" name="setting_holidays_highlight_color" value="{$allSettings.holidays_highlight_color|default:'#e8420a'}" style="width:48px;height:36px;border:1px solid var(--bbf-border);border-radius:var(--bbf-radius);cursor:pointer;padding:2px;" oninput="document.getElementById('bbf-holidays-highlight-color-hex').value=this.value;">
          <input type="text" class="bbf-form-control" id="bbf-holidays-highlight-color-hex" value="{$allSettings.holidays_highlight_color|default:'#e8420a'}" style="width:120px;" oninput="if(/^#[0-9a-fA-F]{ldelim}6{rdelim}$/.test(this.value))document.getElementById('bbf-holidays-highlight-color').value=this.value;">
        </div>
        <p class="bbf-form-hint">Farbe f&uuml;r die Hervorhebung von verkaufsoffenen Sonntagen und besonderen Feiertagen.</p>
      </div>

      {* Automatische Synchronisation *}
      <div class="bbf-form-group">
        <div class="bbf-flex-between">
          <label class="bbf-form-label">Automatische Synchronisation</label>
          <label class="bbf-toggle">
            <input type="checkbox" name="setting_holidays_auto_sync" value="1"{if $allSettings.holidays_auto_sync|default:'0' eq '1'} checked{/if}>
            <span class="bbf-toggle-slider"></span>
          </label>
        </div>
        <p class="bbf-form-hint">iCal-Kalender automatisch synchronisieren.</p>
      </div>

      {* Sync-Intervall *}
      <div class="bbf-form-group">
        <label class="bbf-form-label">Sync-Intervall</label>
        <select name="setting_holidays_sync_interval" class="bbf-form-control" style="max-width:250px;">
          <option value="daily"{if $allSettings.holidays_sync_interval|default:'weekly' eq 'daily'} selected{/if}>T&auml;glich</option>
          <option value="weekly"{if $allSettings.holidays_sync_interval|default:'weekly' eq 'weekly'} selected{/if}>W&ouml;chentlich</option>
          <option value="monthly"{if $allSettings.holidays_sync_interval|default:'weekly' eq 'monthly'} selected{/if}>Monatlich</option>
        </select>
        <p class="bbf-form-hint">Wie oft sollen die Kalender-Abonnements automatisch synchronisiert werden?</p>
      </div>
    </div>

    {* ── Save Button ── *}
    <div class="bbf-flex bbf-gap-8" style="justify-content: flex-end;">
      <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-holidays-settings-form', 'holidays')">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
        Einstellungen speichern
      </button>
    </div>
  </form>
</div>

{* ══════════════════════════════════════════════════════════
   Inline Script
   ══════════════════════════════════════════════════════════ *}
<script>
/* ── Main Tab Switching ── */
function bbfSwitchMainTab(e, tabId) {
  e.preventDefault();
  document.querySelectorAll('#bbf-holidays-tabs .bbf-tab-link').forEach(function(el) { el.classList.remove('active'); });
  document.querySelectorAll('#bbf-page-content > .bbf-tab-content').forEach(function(el) { el.classList.remove('active'); });
  e.currentTarget.classList.add('active');
  document.getElementById(tabId).classList.add('active');
}

/* ── Holiday Sub-Tab Switching ── */
function bbfSwitchHolidayTab(e, tabId) {
  e.preventDefault();
  document.querySelectorAll('#bbf-holiday-sub-tabs .bbf-tab-link').forEach(function(el) { el.classList.remove('active'); });
  document.querySelectorAll('#bbf-holiday-sub-tabs ~ .bbf-tab-content').forEach(function(el) { el.classList.remove('active'); });
  e.currentTarget.classList.add('active');
  document.getElementById(tabId).classList.add('active');
}

/* ── Calendar Form ── */
function bbfShowCalendarForm() {
  document.getElementById('bbf-calendar-form').style.display = '';
  document.getElementById('bbf-calendar-name').value = '';
  document.getElementById('bbf-calendar-url').value = '';
  document.getElementById('bbf-calendar-name').focus();
}

function bbfHideCalendarForm() {
  document.getElementById('bbf-calendar-form').style.display = 'none';
}

function bbfSaveCalendar() {
  var name = document.getElementById('bbf-calendar-name').value.trim();
  var url = document.getElementById('bbf-calendar-url').value.trim();

  if (!name) { bbfToast('Bitte einen Namen eingeben.', 'error'); return; }
  if (!url) { bbfToast('Bitte eine iCal-URL eingeben.', 'error'); return; }

  bbfAjax('saveCalendar', { calendar_name: name, calendar_url: url }, function(r) {
    if (r && r.success) {
      bbfToast(r.message || 'Kalender gespeichert', 'success');
      bbfHideCalendarForm();
      if (typeof getPage === 'function') getPage('holidays');
    } else {
      bbfToast((r && r.message) || 'Fehler beim Speichern', 'error');
    }
  });
}

function bbfDeleteCalendar(id) {
  if (!confirm('Kalender-Abonnement wirklich l\u00f6schen? Alle importierten Feiertage dieses Kalenders werden ebenfalls entfernt.')) return;

  bbfAjax('deleteCalendar', { calendar_id: id }, function(r) {
    if (r && r.success) {
      bbfToast(r.message || 'Kalender gel\u00f6scht', 'success');
      if (typeof getPage === 'function') getPage('holidays');
    } else {
      bbfToast((r && r.message) || 'Fehler beim L\u00f6schen', 'error');
    }
  });
}

function bbfSyncCalendar(id) {
  bbfToast('Synchronisation gestartet...', 'success');
  bbfAjax('syncCalendar', { calendar_id: id }, function(r) {
    if (r && r.success) {
      bbfToast(r.message || 'Synchronisation abgeschlossen', 'success');
      if (typeof getPage === 'function') getPage('holidays');
    } else {
      bbfToast((r && r.message) || 'Synchronisation fehlgeschlagen', 'error');
    }
  });
}

function bbfToggleCalendarStatus(id, el) {
  bbfAjax('toggleCalendarStatus', { calendar_id: id, is_active: el.checked ? 1 : 0 }, function(r) {
    if (!r || !r.success) {
      el.checked = !el.checked;
      bbfToast('Status konnte nicht ge\u00e4ndert werden', 'error');
    }
  });
}

/* ── Holiday Form ── */
function bbfShowHolidayForm() {
  var form = document.getElementById('bbf-holiday-form');
  form.style.display = '';
  document.getElementById('bbf-holiday-id').value = '0';
  document.getElementById('bbf-holiday-date').value = '';
  document.getElementById('bbf-holiday-name').value = '';
  document.getElementById('bbf-holiday-type').value = 'holiday';
  document.getElementById('bbf-holiday-recurring').checked = false;
  document.querySelector('input[name="holiday_scope"][value="all"]').checked = true;
  document.getElementById('bbf-holiday-branches').style.display = 'none';
  document.querySelectorAll('.bbf-holiday-branch-cb').forEach(function(cb) { cb.checked = false; });
  document.getElementById('bbf-holiday-closed').checked = true;
  document.getElementById('bbf-holiday-open-override').checked = false;
  document.getElementById('bbf-holiday-open-times').style.display = 'none';
  document.getElementById('bbf-holiday-open-from').value = '10:00';
  document.getElementById('bbf-holiday-open-to').value = '18:00';
  document.getElementById('bbf-holiday-highlight').checked = false;
  document.getElementById('bbf-holiday-highlight-text').style.display = 'none';
  document.getElementById('bbf-holiday-highlight-value').value = '';
  document.getElementById('bbf-holiday-note').value = '';
  document.getElementById('bbf-holiday-date').focus();
}

function bbfHideHolidayForm() {
  document.getElementById('bbf-holiday-form').style.display = 'none';
}

function bbfSaveHoliday() {
  var date = document.getElementById('bbf-holiday-date').value;
  var name = document.getElementById('bbf-holiday-name').value.trim();

  if (!date) { bbfToast('Bitte ein Datum eingeben.', 'error'); return; }
  if (!name) { bbfToast('Bitte einen Namen eingeben.', 'error'); return; }

  var scope = document.querySelector('input[name="holiday_scope"]:checked').value;
  var branchIds = [];
  if (scope === 'specific') {
    document.querySelectorAll('.bbf-holiday-branch-cb:checked').forEach(function(cb) {
      branchIds.push(cb.value);
    });
    if (!branchIds.length) { bbfToast('Bitte mindestens eine Filiale ausw\u00e4hlen.', 'error'); return; }
  }

  var data = {
    holiday_id: document.getElementById('bbf-holiday-id').value,
    holiday_date: date,
    holiday_name: name,
    holiday_type: document.getElementById('bbf-holiday-type').value,
    holiday_recurring: document.getElementById('bbf-holiday-recurring').checked ? 1 : 0,
    holiday_scope: scope,
    holiday_branches: JSON.stringify(branchIds),
    holiday_closed: document.getElementById('bbf-holiday-closed').checked ? 1 : 0,
    holiday_open_override: document.getElementById('bbf-holiday-open-override').checked ? 1 : 0,
    holiday_open_from: document.getElementById('bbf-holiday-open-from').value,
    holiday_open_to: document.getElementById('bbf-holiday-open-to').value,
    holiday_highlight: document.getElementById('bbf-holiday-highlight').checked ? 1 : 0,
    holiday_highlight_text: document.getElementById('bbf-holiday-highlight-value').value,
    holiday_note: document.getElementById('bbf-holiday-note').value
  };

  bbfAjax('saveHoliday', data, function(r) {
    if (r && r.success) {
      bbfToast(r.message || 'Feiertag gespeichert', 'success');
      bbfHideHolidayForm();
      if (typeof getPage === 'function') getPage('holidays');
    } else {
      bbfToast((r && r.message) || 'Fehler beim Speichern', 'error');
    }
  });
}

function bbfEditHoliday(id) {
  bbfAjax('getHoliday', { holiday_id: id }, function(r) {
    if (r && r.success && r.holiday) {
      var h = r.holiday;
      bbfShowHolidayForm();
      document.getElementById('bbf-holiday-id').value = h.id;
      document.getElementById('bbf-holiday-date').value = h.date || '';
      document.getElementById('bbf-holiday-name').value = h.name || '';
      document.getElementById('bbf-holiday-type').value = h.type || 'holiday';
      document.getElementById('bbf-holiday-recurring').checked = !!h.recurring;

      if (h.scope === 'specific') {
        document.querySelector('input[name="holiday_scope"][value="specific"]').checked = true;
        document.getElementById('bbf-holiday-branches').style.display = '';
        if (h.branch_ids && h.branch_ids.length) {
          h.branch_ids.forEach(function(bid) {
            var cb = document.querySelector('.bbf-holiday-branch-cb[value="' + bid + '"]');
            if (cb) cb.checked = true;
          });
        }
      } else {
        document.querySelector('input[name="holiday_scope"][value="all"]').checked = true;
        document.getElementById('bbf-holiday-branches').style.display = 'none';
      }

      document.getElementById('bbf-holiday-closed').checked = !!h.is_closed;

      if (h.open_override) {
        document.getElementById('bbf-holiday-open-override').checked = true;
        document.getElementById('bbf-holiday-open-times').style.display = '';
        document.getElementById('bbf-holiday-open-from').value = h.open_from || '10:00';
        document.getElementById('bbf-holiday-open-to').value = h.open_to || '18:00';
      }

      if (h.highlight) {
        document.getElementById('bbf-holiday-highlight').checked = true;
        document.getElementById('bbf-holiday-highlight-text').style.display = '';
        document.getElementById('bbf-holiday-highlight-value').value = h.highlight_text || '';
      }

      document.getElementById('bbf-holiday-note').value = h.note || '';
    } else {
      bbfToast('Feiertag konnte nicht geladen werden', 'error');
    }
  });
}

function bbfDeleteHoliday(id) {
  if (!confirm('Feiertag wirklich l\u00f6schen?')) return;

  bbfAjax('deleteHoliday', { holiday_id: id }, function(r) {
    if (r && r.success) {
      bbfToast(r.message || 'Feiertag gel\u00f6scht', 'success');
      if (typeof getPage === 'function') getPage('holidays');
    } else {
      bbfToast((r && r.message) || 'Fehler beim L\u00f6schen', 'error');
    }
  });
}

/* ── UI Toggle Helpers ── */
function bbfToggleBranchSelect() {
  var scope = document.querySelector('input[name="holiday_scope"]:checked').value;
  document.getElementById('bbf-holiday-branches').style.display = scope === 'specific' ? '' : 'none';
}

function bbfToggleOpenOverride() {
  var checked = document.getElementById('bbf-holiday-open-override').checked;
  document.getElementById('bbf-holiday-open-times').style.display = checked ? '' : 'none';
}

function bbfToggleHighlight() {
  var checked = document.getElementById('bbf-holiday-highlight').checked;
  document.getElementById('bbf-holiday-highlight-text').style.display = checked ? '' : 'none';
}
</script>