<link rel="stylesheet" href="{$adminUrl}css/admin-base.css">
<link rel="stylesheet" href="{$adminUrl}css/admin.css">

{* Hide JTL default plugin header *}
<style>
#plugin-listing, .plugin-header, .content-header {ldelim} display: none !important; {rdelim}
</style>

<div class="bbf-plugin-page">
  {$jtl_token}

  {* ── Sidebar ── *}
  <div class="bbf-sidebar" id="bbf-sidebar">
    <div class="bbf-sidebar-header">
      <div>
        <img src="{$adminUrl}images/Logo_bbfdesign_dark_2024.png" alt="bbf.design" class="bbf-sidebar-logo-img">
      </div>
      <button type="button" class="bbf-sidebar-toggle" id="bbf-sidebar-toggle">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
      </button>
    </div>

    <div class="bbf-sidebar-content">

      <div class="bbf-nav-section">Filialen</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" data-page="branches">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
          <span>Standorte</span>
        </a></li>
        <li><a href="#" data-page="holidays">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/></svg>
          <span>Feiertage</span>
        </a></li>
      </ul>

      <div class="bbf-nav-section">Darstellung</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" data-page="layouts">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="9" y1="21" x2="9" y2="9"/></svg>
          <span>Vorlagen</span>
        </a></li>
        <li><a href="#" data-page="styling">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="13.5" cy="6.5" r="2.5"/><circle cx="19" cy="13" r="2.5"/><circle cx="16" cy="20" r="2.5"/><circle cx="7.5" cy="20" r="2.5"/><circle cx="5" cy="13" r="2.5"/><circle cx="12" cy="13" r="3"/></svg>
          <span>Farben &amp; Styling</span>
        </a></li>
        <li><a href="#" data-page="css_editor">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
          <span>CSS-Editor</span>
        </a></li>
        <li><a href="#" data-page="modal_settings">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
          <span>Detail-Modal</span>
        </a></li>
      </ul>

      <div class="bbf-nav-section">Konfiguration</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" data-page="map_provider">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/><line x1="8" y1="2" x2="8" y2="18"/><line x1="16" y1="6" x2="16" y2="22"/></svg>
          <span>Kartenanbieter</span>
        </a></li>
        <li><a href="#" data-page="opening_status">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          <span>Öffnungsstatus</span>
        </a></li>
        <li><a href="#" data-page="consent">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          <span>Consent Manager</span>
        </a></li>
        <li><a href="#" data-page="geolocation">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="22" y1="12" x2="18" y2="12"/><line x1="6" y1="12" x2="2" y2="12"/><line x1="12" y1="6" x2="12" y2="2"/><line x1="12" y1="22" x2="12" y2="18"/></svg>
          <span>Geolokation</span>
        </a></li>
        <li><a href="#" data-page="performance">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
          <span>Performance</span>
        </a></li>
      </ul>

      <div class="bbf-nav-section">Daten</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" data-page="import_export">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
          <span>Import / Export</span>
        </a></li>
      </ul>

      <div class="bbf-nav-section">Info</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" data-page="documentation">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
          <span>Dokumentation</span>
        </a></li>
        <li><a href="#" data-page="changelog">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
          <span>Changelog</span>
        </a></li>
      </ul>
    </div>

    <div class="bbf-sidebar-footer">
      <span class="bbf-version">v{$pluginVersion|escape:'html'}</span>
    </div>
  </div>

  {* ── Main Content ── *}
  <div class="bbf-main">
    <div class="bbf-header">
      <div class="bbf-header-inner">
        <div>
          <h3 class="bbf-header-title">BBF Filialfinder</h3>
          <p class="bbf-header-subtitle">Filialen &amp; Standorte verwalten</p>
        </div>
      </div>
    </div>

    <div class="bbf-content">
      <div id="bbf-page-content">
        <div style="text-align:center; padding:60px 0;">
          <div class="bbf-spinner bbf-spinner-lg"></div>
          <p style="margin-top:16px; color:#999; font-size:14px;">Seite wird geladen...</p>
        </div>
      </div>
    </div>
  </div>
</div>

{* ── Global JS Variables (OUTSIDE {literal}) ── *}
<script>
  var postURL = "{$postURL|escape:'javascript'}";
  var adminUrl = "{$adminUrl|escape:'javascript'}";
  var jtlToken = (document.querySelector('[name="jtl_token"]') || {ldelim}{rdelim}).value || '';
</script>

{* ── Admin JS (jQuery-based navigation, loaded synchronously) ── *}
<script src="{$adminUrl}js/admin.js"></script>
