<link rel="stylesheet" href="{$adminUrl}css/admin-base.css">
<link rel="stylesheet" href="{$adminUrl}css/admin.css">

<div class="bbf-plugin-page" x-data="bbfFilialfinder()" x-init="init()">
  {$jtl_token}

  {* ── Sidebar ── *}
  <div class="bbf-sidebar" id="bbf-sidebar" :class="{ldelim} 'open': sidebarOpen {rdelim}">
    <div class="bbf-sidebar-header">
      <img src="{$adminUrl}images/Logo_bbfdesign_dark_2024.png" alt="bbf.design" class="bbf-sidebar-logo-img">
      <button type="button" class="bbf-sidebar-toggle" @click="sidebarOpen = !sidebarOpen">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
      </button>
    </div>

    <div class="bbf-sidebar-content">

      {* ── FILIALEN ── *}
      <div class="bbf-nav-section">Filialen</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'branches' {rdelim}" @click.prevent="loadPage('branches')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
          <span>Standorte</span>
        </a></li>
      </ul>

      {* ── DARSTELLUNG ── *}
      <div class="bbf-nav-section">Darstellung</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'layouts' {rdelim}" @click.prevent="loadPage('layouts')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="9" y1="21" x2="9" y2="9"/></svg>
          <span>Vorlagen</span>
        </a></li>
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'styling' {rdelim}" @click.prevent="loadPage('styling')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="13.5" cy="6.5" r="2.5"/><circle cx="19" cy="13" r="2.5"/><circle cx="16" cy="20" r="2.5"/><circle cx="7.5" cy="20" r="2.5"/><circle cx="5" cy="13" r="2.5"/><circle cx="12" cy="13" r="3"/></svg>
          <span>Farben &amp; Styling</span>
        </a></li>
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'css_editor' {rdelim}" @click.prevent="loadPage('css_editor')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
          <span>CSS-Editor</span>
        </a></li>
      </ul>

      {* ── KONFIGURATION ── *}
      <div class="bbf-nav-section">Konfiguration</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'map_provider' {rdelim}" @click.prevent="loadPage('map_provider')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/><line x1="8" y1="2" x2="8" y2="18"/><line x1="16" y1="6" x2="16" y2="22"/></svg>
          <span>Kartenanbieter</span>
        </a></li>
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'opening_status' {rdelim}" @click.prevent="loadPage('opening_status')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          <span>Öffnungsstatus</span>
        </a></li>
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'consent' {rdelim}" @click.prevent="loadPage('consent')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          <span>Consent Manager</span>
        </a></li>
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'geolocation' {rdelim}" @click.prevent="loadPage('geolocation')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="22" y1="12" x2="18" y2="12"/><line x1="6" y1="12" x2="2" y2="12"/><line x1="12" y1="6" x2="12" y2="2"/><line x1="12" y1="22" x2="12" y2="18"/></svg>
          <span>Geolokation</span>
        </a></li>
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'performance' {rdelim}" @click.prevent="loadPage('performance')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
          <span>Performance</span>
        </a></li>
      </ul>

      {* ── INFO ── *}
      <div class="bbf-nav-section">Info</div>
      <ul class="bbf-sidebar-nav">
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'documentation' {rdelim}" @click.prevent="loadPage('documentation')">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
          <span>Dokumentation</span>
        </a></li>
        <li><a href="#" :class="{ldelim} 'bbf-nav-active': page === 'changelog' {rdelim}" @click.prevent="loadPage('changelog')">
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
        <div class="bbf-flex bbf-gap-12">
          <button class="bbf-hamburger" @click="sidebarOpen = !sidebarOpen">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
          </button>
          <div>
            <h3 class="bbf-header-title">BBF Filialfinder</h3>
            <p class="bbf-header-subtitle">Filialen &amp; Standorte verwalten</p>
          </div>
        </div>
      </div>
    </div>

    <div class="bbf-content">
      <div id="bbf-page-content">
        <div class="bbf-text-center" style="padding: 60px 0;">
          <div class="bbf-spinner bbf-spinner-lg"></div>
          <p class="bbf-mt-16 bbf-text-muted">Seite wird geladen...</p>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  var postURL = "{$postURL|escape:'javascript'}";
  var adminUrl = "{$adminUrl|escape:'javascript'}";
  var jtlToken = document.querySelector('[name="jtl_token"]') ? document.querySelector('[name="jtl_token"]').value : '';
</script>
<script src="{$adminUrl}js/vendor/alpine.min.js" defer></script>
<script src="{$adminUrl}js/admin.js" defer></script>
