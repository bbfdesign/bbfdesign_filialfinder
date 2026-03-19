{if $isPreview}
    {* OPC Editor preview *}
    <div style="padding:24px;background:#f8f9fa;border:2px dashed #db2e87;border-radius:10px;text-align:center;">
        <div style="font-size:32px;margin-bottom:8px;">&#x1F4CD;</div>
        <strong>BBF Filialfinder</strong><br>
        <small style="color:#666;">Layout: {$instance->getProperty('layout')|default:'default'} | Vorschau im OPC-Editor</small>
    </div>
{else}
    {assign var=ffData value=$portlet->getFilialfinderData($instance)}
    {assign var=ffLayout value=$ffData.layout|default:'default'}
    {assign var=ffShowTitle value=$instance->getProperty('show_title')}
    {assign var=ffTitle value=$instance->getProperty('title')}
    {assign var=ffShowMap value=$instance->getProperty('show_map')}
    {assign var=ffMapHeight value=$instance->getProperty('map_height')|default:450}
    {assign var=ffProvider value=$ffData.settings.map_provider|default:'osm'}
    {assign var=ffZoom value=$ffData.settings.map_default_zoom|default:14}
    {assign var=ffPluginUrl value=$ffData.pluginFrontendUrl|default:''}
    {assign var=ffBaseUrl value=$ffData.pluginBaseUrl|default:''}
    {assign var=ffInstanceId value=$instance->getId()|default:($smarty.now|md5|truncate:8:'')}

    {* ===== Frontend CSS ===== *}
    <!-- bbf-debug: ffPluginUrl={$ffPluginUrl|escape:'html'} ffBaseUrl={$ffBaseUrl|escape:'html'} -->
    {if $ffPluginUrl}
        <link rel="stylesheet" href="{$ffPluginUrl}css/filialfinder.css">
    {else}
        {* Hardcoded fallback if plugin URL resolution failed *}
        <link rel="stylesheet" href="/plugins/bbfdesign_filialfinder/frontend/css/filialfinder.css">
    {/if}
    {if $ffProvider === 'osm'}
        {if $ffBaseUrl}
            <link rel="stylesheet" href="{$ffBaseUrl}vendor/leaflet/leaflet.css">
        {else}
            <link rel="stylesheet" href="/plugins/bbfdesign_filialfinder/vendor/leaflet/leaflet.css">
        {/if}
    {/if}

    {* ===== Dynamic CSS variables from plugin settings ===== *}
    <style>
        .bbf-filialfinder-wrapper--{$ffInstanceId} {
            --bbf-ff-primary: {$ffData.settings.styling_primary_color|default:'#C8B831'};
            --bbf-ff-secondary: {$ffData.settings.styling_secondary_color|default:'#1f2937'};
            --bbf-ff-bg: {$ffData.settings.styling_bg_color|default:'#ffffff'};
            --bbf-ff-text: {$ffData.settings.styling_text_color|default:'#1f2937'};
            --bbf-ff-open: {$ffData.settings.styling_open_color|default:'#28a745'};
            --bbf-ff-closed: {$ffData.settings.styling_closed_color|default:'#dc3545'};
            --bbf-ff-marker: {$ffData.settings.styling_marker_color|default:'#C8B831'};
            --bbf-ff-radius: {$ffData.settings.styling_border_radius|default:'8'}px;
            --bbf-ff-shadow: 0 {$ffData.settings.styling_shadow_intensity|default:'2'}px {$ffData.settings.styling_shadow_intensity|default:'2' * 4}px rgba(0,0,0,0.1);
            --bbf-ff-border: {$ffData.settings.styling_border_color|default:'#e5e7eb'};
        }
        {* Custom CSS from CSS-Editor *}
        {if !empty($ffData.settings.custom_css)}
            {$ffData.settings.custom_css}
        {/if}
    </style>

    {* ===== Main wrapper ===== *}
    <div class="bbf-filialfinder-wrapper bbf-filialfinder-wrapper--{$ffInstanceId} {$instance->getStyleClasses()}"
         data-filialfinder
         data-provider="{$ffProvider|escape:'htmlall'}"
         data-settings='{$ffData.settings|json_encode}'
         id="bbf-filialfinder-{$ffInstanceId}"
         style="{$instance->getStyleString()}">

        {* ===== Title block ===== *}
        {if $ffShowTitle && $ffTitle}
            {assign var=ffTitleTag value=$ffData.settings.styling_title_tag|default:'h2'}
            {assign var=ffTitleAlign value=$ffData.settings.styling_title_align|default:'center'}
            <{$ffTitleTag} class="bbf-filialfinder-title" style="text-align:{$ffTitleAlign}">
                {$ffTitle|escape:'html'}
            </{$ffTitleTag}>
            {if $ffData.settings.styling_subtitle}
                <p class="bbf-filialfinder-subtitle" style="text-align:{$ffTitleAlign}">
                    {$ffData.settings.styling_subtitle|escape:'html'}
                </p>
            {/if}
            {if $ffData.settings.styling_divider == '1'}
                {assign var=ffDividerColor value=$ffData.settings.styling_divider_color|default:'#c8a96e'}
                {assign var=ffDividerWidth value=$ffData.settings.styling_divider_width|default:'80'}
                <div class="bbf-filialfinder-divider" style="width:{$ffDividerWidth}px;height:3px;background:{$ffDividerColor};margin:10px auto 20px;"></div>
            {/if}
        {/if}

        {* ===== Branch content ===== *}
        {if !empty($ffData.branches)}

            {* ================================================================
               LAYOUT: default (list + map side by side)
               ================================================================ *}
            {if $ffLayout === 'default'}
                <div class="bbf-filialfinder-layout bbf-filialfinder-layout--default">
                    <div class="bbf-filialfinder-list-col">
                        <div class="bbf-filialfinder-list" data-ff-list>
                            {foreach $ffData.branches as $branch}
                                <div class="bbf-filialfinder-card {$branch.css_class|default:''}"
                                     data-branch-id="{$branch.id|intval}"
                                     data-lat="{$branch.latitude|escape:'htmlall'}"
                                     data-lng="{$branch.longitude|escape:'htmlall'}"
                                     role="button" tabindex="0">
                                    <div class="bbf-filialfinder-card-body">
                                        <h3 class="bbf-filialfinder-card-name">{$branch.name|escape:'html'}</h3>
                                        <p class="bbf-filialfinder-card-address">
                                            {$branch.street|escape:'html'}<br>
                                            {$branch.zip|escape:'html'} {$branch.city|escape:'html'}
                                            {if $branch.country}<br>{$branch.country|escape:'html'}{/if}
                                        </p>
                                        {if $branch.phone}
                                            <p class="bbf-filialfinder-card-phone">
                                                <a href="tel:{$branch.phone|escape:'url'}">{$branch.phone|escape:'html'}</a>
                                            </p>
                                        {/if}
                                        {if $branch.email}
                                            <p class="bbf-filialfinder-card-email">
                                                <a href="mailto:{$branch.email|escape:'htmlall'}">{$branch.email|escape:'html'}</a>
                                            </p>
                                        {/if}
                                        {if $branch.status}
                                            <span class="bbf-filialfinder-status {$branch.status.cssClass|escape:'htmlall'}" data-ff-status>
                                                {if $ffData.settings.status_animated_dot == '1'}
                                                    <span class="bbf-filialfinder-status-dot" aria-hidden="true"></span>
                                                {/if}
                                                <span class="bbf-filialfinder-status-text">{$branch.status.text|escape:'html'}</span>
                                                {if $branch.status.status == 'closed' && $branch.status.nextOpening && $ffData.settings.status_show_next_opening == '1'}
                                                    <span class="bbf-filialfinder-status-next">&middot; {$branch.status.nextOpening|escape:'html'}</span>
                                                {/if}
                                            </span>
                                        {/if}
                                        <span class="bbf-filialfinder-card-distance" data-ff-distance="{$branch.id|intval}"></span>
                                        <div class="bbf-filialfinder-card-actions">
                                            <a href="https://www.google.com/maps/dir/?api=1&destination={$branch.latitude|escape:'url'},{$branch.longitude|escape:'url'}"
                                               class="bbf-filialfinder-btn bbf-filialfinder-btn--route" target="_blank" rel="noopener noreferrer">
                                                Route berechnen
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    </div>
                    {if $ffShowMap}
                        <div class="bbf-filialfinder-map-col">
                            <div class="bbf-filialfinder-map" data-ff-map
                                 data-provider="{$ffProvider|escape:'htmlall'}"
                                 data-zoom="{$ffZoom}"
                                 data-center-lat="{$ffData.settings.map_center_lat|default:'51.1657'|escape:'htmlall'}"
                                 data-center-lng="{$ffData.settings.map_center_lng|default:'10.4515'|escape:'htmlall'}"
                                 data-cluster="{$ffData.settings.map_marker_cluster|default:'1'|escape:'htmlall'}"
                                 id="bbf-ff-map-{$ffInstanceId}"
                                 style="height:{$ffMapHeight}px;width:100%;"
                                 role="application" aria-label="Filialstandorte Karte">
                                <div class="bbf-filialfinder-map-loading" data-ff-map-loading>
                                    <span class="bbf-filialfinder-spinner" aria-hidden="true"></span>
                                    <span>Karte wird geladen&hellip;</span>
                                </div>
                            </div>
                        </div>
                    {/if}
                </div>

            {* ================================================================
               LAYOUT: grid
               ================================================================ *}
            {elseif $ffLayout === 'grid'}
                {assign var=ffGridCols value=$ffData.settings.grid_columns|default:'3'}
                <div class="bbf-filialfinder-layout bbf-filialfinder-layout--grid bbf-filialfinder-grid--cols-{$ffGridCols}">
                    {foreach $ffData.branches as $branch}
                        <div class="bbf-filialfinder-grid-item">
                            <div class="bbf-filialfinder-card bbf-filialfinder-card--grid {$branch.css_class|default:''}"
                                 data-branch-id="{$branch.id|intval}"
                                 data-lat="{$branch.latitude|escape:'htmlall'}"
                                 data-lng="{$branch.longitude|escape:'htmlall'}">
                                {if $branch.image_path}
                                    <div class="bbf-filialfinder-card-image">
                                        <img src="{$branch.image_path|escape:'htmlall'}" alt="{$branch.name|escape:'htmlall'}" loading="lazy">
                                    </div>
                                {/if}
                                <div class="bbf-filialfinder-card-body">
                                    <h3 class="bbf-filialfinder-card-name">{$branch.name|escape:'html'}</h3>
                                    <p class="bbf-filialfinder-card-address">
                                        {$branch.street|escape:'html'}<br>
                                        {$branch.zip|escape:'html'} {$branch.city|escape:'html'}
                                    </p>
                                    {if $branch.status}
                                        <span class="bbf-filialfinder-status {$branch.status.cssClass|escape:'htmlall'}" data-ff-status>
                                            {if $ffData.settings.status_animated_dot == '1'}
                                                <span class="bbf-filialfinder-status-dot" aria-hidden="true"></span>
                                            {/if}
                                            <span class="bbf-filialfinder-status-text">{$branch.status.text|escape:'html'}</span>
                                        </span>
                                    {/if}
                                    <span class="bbf-filialfinder-card-distance" data-ff-distance="{$branch.id|intval}"></span>
                                    <div class="bbf-filialfinder-card-actions">
                                        <button type="button" class="bbf-filialfinder-btn bbf-filialfinder-btn--info" data-ff-detail-btn="{$branch.id|intval}">
                                            Mehr Info
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
                {if $ffShowMap}
                    <div class="bbf-filialfinder-grid-map">
                        <div class="bbf-filialfinder-map" data-ff-map
                             data-provider="{$ffProvider|escape:'htmlall'}"
                             data-zoom="{$ffZoom}"
                             data-center-lat="{$ffData.settings.map_center_lat|default:'51.1657'|escape:'htmlall'}"
                             data-center-lng="{$ffData.settings.map_center_lng|default:'10.4515'|escape:'htmlall'}"
                             data-cluster="{$ffData.settings.map_marker_cluster|default:'1'|escape:'htmlall'}"
                             id="bbf-ff-map-{$ffInstanceId}"
                             style="height:{$ffMapHeight}px;width:100%;"
                             role="application" aria-label="Filialstandorte Karte">
                            <div class="bbf-filialfinder-map-loading" data-ff-map-loading>
                                <span class="bbf-filialfinder-spinner" aria-hidden="true"></span>
                                <span>Karte wird geladen&hellip;</span>
                            </div>
                        </div>
                    </div>
                {/if}

            {* ================================================================
               LAYOUT: map_only
               ================================================================ *}
            {elseif $ffLayout === 'map_only'}
                <div class="bbf-filialfinder-layout bbf-filialfinder-layout--map-only">
                    <div class="bbf-filialfinder-map" data-ff-map
                         data-provider="{$ffProvider|escape:'htmlall'}"
                         data-zoom="{$ffZoom}"
                         data-center-lat="{$ffData.settings.map_center_lat|default:'51.1657'|escape:'htmlall'}"
                         data-center-lng="{$ffData.settings.map_center_lng|default:'10.4515'|escape:'htmlall'}"
                         data-cluster="{$ffData.settings.map_marker_cluster|default:'1'|escape:'htmlall'}"
                         id="bbf-ff-map-{$ffInstanceId}"
                         style="height:{$ffMapHeight}px;width:100%;"
                         role="application" aria-label="Filialstandorte Karte">
                        <div class="bbf-filialfinder-map-loading" data-ff-map-loading>
                            <span class="bbf-filialfinder-spinner" aria-hidden="true"></span>
                            <span>Karte wird geladen&hellip;</span>
                        </div>
                    </div>
                    {* Slide-in detail panel *}
                    <div class="bbf-filialfinder-slidein" data-ff-slidein aria-hidden="true">
                        <button type="button" class="bbf-filialfinder-slidein-close" data-ff-slidein-close aria-label="Schliessen">&times;</button>
                        <div class="bbf-filialfinder-slidein-content" data-ff-slidein-content></div>
                    </div>
                    {* Hidden branch templates for JS slide-in *}
                    {foreach $ffData.branches as $branch}
                        <template data-ff-branch-template="{$branch.id|intval}">
                            <div class="bbf-filialfinder-card bbf-filialfinder-card--compact">
                                <div class="bbf-filialfinder-card-body">
                                    <h3 class="bbf-filialfinder-card-name">{$branch.name|escape:'html'}</h3>
                                    <p class="bbf-filialfinder-card-address">
                                        {$branch.street|escape:'html'}<br>
                                        {$branch.zip|escape:'html'} {$branch.city|escape:'html'}
                                    </p>
                                    {if $branch.phone}
                                        <p class="bbf-filialfinder-card-phone">
                                            <a href="tel:{$branch.phone|escape:'url'}">{$branch.phone|escape:'html'}</a>
                                        </p>
                                    {/if}
                                    {if $branch.status}
                                        <span class="bbf-filialfinder-status {$branch.status.cssClass|escape:'htmlall'}" data-ff-status>
                                            <span class="bbf-filialfinder-status-text">{$branch.status.text|escape:'html'}</span>
                                        </span>
                                    {/if}
                                    <div class="bbf-filialfinder-card-actions">
                                        <a href="https://www.google.com/maps/dir/?api=1&destination={$branch.latitude|escape:'url'},{$branch.longitude|escape:'url'}"
                                           class="bbf-filialfinder-btn bbf-filialfinder-btn--route" target="_blank" rel="noopener noreferrer">
                                            Route berechnen
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </template>
                    {/foreach}
                </div>

            {* ================================================================
               LAYOUT: accordion
               ================================================================ *}
            {elseif $ffLayout === 'accordion'}
                <div class="bbf-filialfinder-layout bbf-filialfinder-layout--accordion">
                    <div class="bbf-filialfinder-accordion" data-ff-accordion>
                        {foreach $ffData.branches as $branch}
                            {assign var=ffAccId value="bbf-acc-`$ffInstanceId`-`$branch.id`"}
                            <div class="bbf-filialfinder-accordion-item {$branch.css_class|default:''}"
                                 data-branch-id="{$branch.id|intval}">
                                <button type="button"
                                        class="bbf-filialfinder-accordion-header"
                                        aria-expanded="false"
                                        aria-controls="{$ffAccId}"
                                        data-ff-accordion-toggle>
                                    <span class="bbf-filialfinder-accordion-name">{$branch.name|escape:'html'}</span>
                                    {if $branch.status}
                                        <span class="bbf-filialfinder-accordion-status {$branch.status.cssClass|escape:'htmlall'}">
                                            {$branch.status.text|escape:'html'}
                                        </span>
                                    {/if}
                                    <span class="bbf-filialfinder-accordion-icon" aria-hidden="true">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                                    </span>
                                </button>
                                <div class="bbf-filialfinder-accordion-body" id="{$ffAccId}" role="region" aria-hidden="true">
                                    <div class="bbf-filialfinder-accordion-content">
                                        <div class="bbf-filialfinder-accordion-details">
                                            <p class="bbf-filialfinder-card-address">
                                                {$branch.street|escape:'html'}<br>
                                                {$branch.zip|escape:'html'} {$branch.city|escape:'html'}
                                                {if $branch.country}<br>{$branch.country|escape:'html'}{/if}
                                            </p>
                                            {if $branch.phone}
                                                <p class="bbf-filialfinder-card-phone">
                                                    <a href="tel:{$branch.phone|escape:'url'}">{$branch.phone|escape:'html'}</a>
                                                </p>
                                            {/if}
                                            {if $branch.email}
                                                <p class="bbf-filialfinder-card-email">
                                                    <a href="mailto:{$branch.email|escape:'htmlall'}">{$branch.email|escape:'html'}</a>
                                                </p>
                                            {/if}
                                            {if $branch.website}
                                                <p class="bbf-filialfinder-card-website">
                                                    <a href="{$branch.website|escape:'htmlall'}" target="_blank" rel="noopener noreferrer">Website besuchen</a>
                                                </p>
                                            {/if}
                                            {if $branch.description}
                                                <div class="bbf-filialfinder-card-description">{$branch.description}</div>
                                            {/if}
                                            {if $branch.status}
                                                <span class="bbf-filialfinder-status {$branch.status.cssClass|escape:'htmlall'}" data-ff-status>
                                                    {if $ffData.settings.status_animated_dot == '1'}
                                                        <span class="bbf-filialfinder-status-dot" aria-hidden="true"></span>
                                                    {/if}
                                                    <span class="bbf-filialfinder-status-text">{$branch.status.text|escape:'html'}</span>
                                                    {if $branch.status.status == 'closed' && $branch.status.nextOpening && $ffData.settings.status_show_next_opening == '1'}
                                                        <span class="bbf-filialfinder-status-next">&middot; {$branch.status.nextOpening|escape:'html'}</span>
                                                    {/if}
                                                </span>
                                            {/if}
                                            <div class="bbf-filialfinder-card-actions">
                                                <a href="https://www.google.com/maps/dir/?api=1&destination={$branch.latitude|escape:'url'},{$branch.longitude|escape:'url'}"
                                                   class="bbf-filialfinder-btn bbf-filialfinder-btn--route" target="_blank" rel="noopener noreferrer">
                                                    Route berechnen
                                                </a>
                                            </div>
                                        </div>
                                        {if $ffShowMap}
                                            <div class="bbf-filialfinder-accordion-map">
                                                <div class="bbf-filialfinder-minimap"
                                                     data-ff-minimap
                                                     data-lat="{$branch.latitude|escape:'htmlall'}"
                                                     data-lng="{$branch.longitude|escape:'htmlall'}"
                                                     data-name="{$branch.name|escape:'htmlall'}"
                                                     style="height:200px;">
                                                </div>
                                            </div>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    </div>
                </div>

            {* ================================================================
               LAYOUT: table
               ================================================================ *}
            {elseif $ffLayout === 'table'}
                <div class="bbf-filialfinder-layout bbf-filialfinder-layout--table">
                    {if $ffShowMap}
                        <div class="bbf-filialfinder-table-map">
                            <div class="bbf-filialfinder-map" data-ff-map
                                 data-provider="{$ffProvider|escape:'htmlall'}"
                                 data-zoom="{$ffZoom}"
                                 data-center-lat="{$ffData.settings.map_center_lat|default:'51.1657'|escape:'htmlall'}"
                                 data-center-lng="{$ffData.settings.map_center_lng|default:'10.4515'|escape:'htmlall'}"
                                 data-cluster="{$ffData.settings.map_marker_cluster|default:'1'|escape:'htmlall'}"
                                 id="bbf-ff-map-{$ffInstanceId}"
                                 style="height:{$ffMapHeight}px;width:100%;"
                                 role="application" aria-label="Filialstandorte Karte">
                                <div class="bbf-filialfinder-map-loading" data-ff-map-loading>
                                    <span class="bbf-filialfinder-spinner" aria-hidden="true"></span>
                                    <span>Karte wird geladen&hellip;</span>
                                </div>
                            </div>
                        </div>
                    {/if}
                    <div class="bbf-filialfinder-table-wrap">
                        <table class="bbf-filialfinder-table">
                            <thead>
                                <tr>
                                    <th class="bbf-filialfinder-table-th bbf-filialfinder-table-th--name">Name</th>
                                    <th class="bbf-filialfinder-table-th bbf-filialfinder-table-th--address">Adresse</th>
                                    <th class="bbf-filialfinder-table-th bbf-filialfinder-table-th--phone">Telefon</th>
                                    <th class="bbf-filialfinder-table-th bbf-filialfinder-table-th--status">Status</th>
                                    <th class="bbf-filialfinder-table-th bbf-filialfinder-table-th--distance">Entfernung</th>
                                    <th class="bbf-filialfinder-table-th bbf-filialfinder-table-th--actions"></th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $ffData.branches as $branch}
                                    <tr class="bbf-filialfinder-table-row {$branch.css_class|default:''}"
                                        data-branch-id="{$branch.id|intval}"
                                        data-lat="{$branch.latitude|escape:'htmlall'}"
                                        data-lng="{$branch.longitude|escape:'htmlall'}">
                                        <td class="bbf-filialfinder-table-td bbf-filialfinder-table-td--name" data-label="Name">
                                            <strong>{$branch.name|escape:'html'}</strong>
                                        </td>
                                        <td class="bbf-filialfinder-table-td bbf-filialfinder-table-td--address" data-label="Adresse">
                                            {$branch.street|escape:'html'}, {$branch.zip|escape:'html'} {$branch.city|escape:'html'}
                                        </td>
                                        <td class="bbf-filialfinder-table-td bbf-filialfinder-table-td--phone" data-label="Telefon">
                                            {if $branch.phone}
                                                <a href="tel:{$branch.phone|escape:'url'}">{$branch.phone|escape:'html'}</a>
                                            {else}
                                                &ndash;
                                            {/if}
                                        </td>
                                        <td class="bbf-filialfinder-table-td bbf-filialfinder-table-td--status" data-label="Status">
                                            {if $branch.status}
                                                <span class="bbf-filialfinder-status {$branch.status.cssClass|escape:'htmlall'}" data-ff-status>
                                                    {if $ffData.settings.status_animated_dot == '1'}
                                                        <span class="bbf-filialfinder-status-dot" aria-hidden="true"></span>
                                                    {/if}
                                                    <span class="bbf-filialfinder-status-text">{$branch.status.text|escape:'html'}</span>
                                                </span>
                                            {else}
                                                &ndash;
                                            {/if}
                                        </td>
                                        <td class="bbf-filialfinder-table-td bbf-filialfinder-table-td--distance" data-label="Entfernung">
                                            <span data-ff-distance="{$branch.id|intval}">&ndash;</span>
                                        </td>
                                        <td class="bbf-filialfinder-table-td bbf-filialfinder-table-td--actions">
                                            <a href="https://www.google.com/maps/dir/?api=1&destination={$branch.latitude|escape:'url'},{$branch.longitude|escape:'url'}"
                                               class="bbf-filialfinder-btn bbf-filialfinder-btn--route bbf-filialfinder-btn--sm"
                                               target="_blank" rel="noopener noreferrer" title="Route berechnen">
                                                Route
                                            </a>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            {/if}

        {else}
            {* No branches found *}
            <div class="bbf-filialfinder-no-results">
                {$ffData.settings.styling_no_results_text|default:'Keine Filialen gefunden.'|escape:'html'}
            </div>
        {/if}
    </div>

    {* ===== Branch marker data as JSON for JS ===== *}
    {if !empty($ffData.branches)}
        <script type="application/json" data-ff-markers data-ff-instance="{$ffInstanceId}">
        [
            {foreach $ffData.branches as $branch name=markers}
            {ldelim}
                "id": {$branch.id|intval},
                "name": {$branch.name|json_encode},
                "street": {$branch.street|json_encode},
                "zip": {$branch.zip|json_encode},
                "city": {$branch.city|json_encode},
                "lat": {$branch.latitude|default:0},
                "lng": {$branch.longitude|default:0},
                "phone": {$branch.phone|default:''|json_encode},
                "markerColor": {$branch.marker_color|default:''|json_encode}
            {rdelim}{if !$smarty.foreach.markers.last},{/if}
            {/foreach}
        ]
        </script>
    {/if}

    {* ===== Consent placeholder (simple JS-based, not DB-based) ===== *}
    {if $ffData.settings.consent_enabled == '1' && $ffProvider === 'osm'}
        <div class="bbf-filialfinder-consent-placeholder" id="bbf-ff-consent-{$ffInstanceId}" style="display:none;">
            <p>{$ffData.settings.consent_placeholder_text|default:'Zur Anzeige der Karte wird ein externer Dienst (OpenStreetMap) geladen. Mit dem Laden stimmen Sie der Datenschutzerklaerung zu.'|escape:'html'}</p>
            <button type="button" class="bbf-filialfinder-btn bbf-filialfinder-btn--primary" data-ff-consent-accept>Karte laden</button>
        </div>
    {/if}

    {* ===== JS: Leaflet (OSM) ===== *}
    {if $ffProvider === 'osm'}
        {if $ffBaseUrl}
            <script src="{$ffBaseUrl}vendor/leaflet/leaflet.js"></script>
        {else}
            <script src="/plugins/bbfdesign_filialfinder/vendor/leaflet/leaflet.js"></script>
        {/if}
        {* CDN Fallback: if local Leaflet failed to load *}
        <script>
        if (typeof L === 'undefined') {
            document.write('<scr' + 'ipt src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"><\/scr' + 'ipt>');
            if (!document.querySelector('link[href*="leaflet.css"]')) {
                var _c = document.createElement('link'); _c.rel = 'stylesheet';
                _c.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
                document.head.appendChild(_c);
            }
        }
        </script>
    {/if}

    {* ===== Inline map initialization for the OPC portlet context ===== *}
    <script>
    (function() {
        'use strict';

        var wrapper = document.getElementById('bbf-filialfinder-{$ffInstanceId}');
        if (!wrapper) return;

        var mapEl = wrapper.querySelector('[data-ff-map]');
        var provider = '{$ffProvider|escape:"javascript"}';
        var consentEnabled = {if $ffData.settings.consent_enabled == '1'}true{else}false{/if};
        var consentEl = document.getElementById('bbf-ff-consent-{$ffInstanceId}');

        {* Consent check (localStorage based) *}
        function hasConsent() {
            if (!consentEnabled) return true;
            return localStorage.getItem('bbf_maps_consent') === '1';
        }

        function grantConsent() {
            localStorage.setItem('bbf_maps_consent', '1');
            if (consentEl) consentEl.style.display = 'none';
            if (mapEl) {
                mapEl.style.display = '';
                initMap();
            }
        }

        {* Consent placeholder logic *}
        if (consentEnabled && !hasConsent() && mapEl) {
            mapEl.style.display = 'none';
            if (consentEl) {
                consentEl.style.display = '';
                var acceptBtn = consentEl.querySelector('[data-ff-consent-accept]');
                if (acceptBtn) {
                    acceptBtn.addEventListener('click', grantConsent);
                }
            }
        }

        {* Accordion toggle logic *}
        wrapper.querySelectorAll('[data-ff-accordion-toggle]').forEach(function(btn) {
            btn.addEventListener('click', function() {
                var expanded = this.getAttribute('aria-expanded') === 'true';
                var bodyId = this.getAttribute('aria-controls');
                var body = document.getElementById(bodyId);
                this.setAttribute('aria-expanded', !expanded);
                if (body) {
                    body.setAttribute('aria-hidden', expanded);
                    body.style.display = expanded ? 'none' : 'block';
                }
            });
        });

        {* Branch card click -> fly to map marker *}
        wrapper.querySelectorAll('.bbf-filialfinder-card[data-lat][data-lng], .bbf-filialfinder-table-row[data-lat][data-lng]').forEach(function(el) {
            el.addEventListener('click', function() {
                var lat = parseFloat(this.dataset.lat);
                var lng = parseFloat(this.dataset.lng);
                if (!lat || !lng || !mapEl) return;
                {* Highlight active card *}
                wrapper.querySelectorAll('.bbf-filialfinder-card--active, .bbf-filialfinder-table-row--active').forEach(function(c) {
                    c.classList.remove('bbf-filialfinder-card--active');
                    c.classList.remove('bbf-filialfinder-table-row--active');
                });
                this.classList.add(this.classList.contains('bbf-filialfinder-table-row') ? 'bbf-filialfinder-table-row--active' : 'bbf-filialfinder-card--active');
                {* Dispatch custom event for the map JS to handle *}
                mapEl.dispatchEvent(new CustomEvent('bbf-ff-flyto', { detail: { lat: lat, lng: lng } }));
            });
        });

        {* Initialize map if consent given or not required *}
        function initMap() {
            if (!mapEl || !hasConsent()) return;
            {* The filialfinder-leaflet.js / filialfinder-google.js scripts
               auto-initialize maps on [data-ff-map] elements.
               Dispatch a ready event to trigger initialization if scripts already loaded. *}
            if (typeof window.BbfFilialfinderMap !== 'undefined') {
                window.BbfFilialfinderMap.init(wrapper);
            } else {
                {* Fallback: inline Leaflet init for portlet context *}
                if (provider === 'osm' && typeof L !== 'undefined') {
                    initLeafletMap();
                }
            }
        }

        function initLeafletMap() {
            var markersJson = wrapper.querySelector('script[data-ff-markers]');
            if (!markersJson) return;

            var branches;
            try {
                branches = JSON.parse(markersJson.textContent);
            } catch(e) { return; }

            var validBranches = branches.filter(function(b) { return b.lat && b.lng; });

            {* Remove loading placeholder *}
            var loading = mapEl.querySelector('[data-ff-map-loading]');
            if (loading) loading.remove();

            {* Default center: Germany or first valid branch *}
            var centerLat = parseFloat(mapEl.dataset.centerLat) || 51.1657;
            var centerLng = parseFloat(mapEl.dataset.centerLng) || 10.4515;
            var zoom = parseInt(mapEl.dataset.zoom) || {$ffZoom|default:14};

            if (validBranches.length > 0) {
                centerLat = validBranches[0].lat;
                centerLng = validBranches[0].lng;
            } else {
                zoom = 6; {* Zoom out to show all of Germany when no markers *}
            }

            var map = L.map(mapEl, { scrollWheelZoom: false }).setView([centerLat, centerLng], zoom);

            L.tileLayer('https://{ldelim}s{rdelim}.tile.openstreetmap.org/{ldelim}z{rdelim}/{ldelim}x{rdelim}/{ldelim}y{rdelim}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }).addTo(map);

            var markerGroup = [];
            var markerMap = {};
            validBranches.forEach(function(b) {
                var marker = L.marker([b.lat, b.lng]).addTo(map);
                var popupHtml = '<strong>' + b.name + '</strong><br>' +
                    b.street + ', ' + b.zip + ' ' + b.city +
                    (b.phone ? '<br>Tel: <a href="tel:' + encodeURIComponent(b.phone) + '">' + b.phone + '</a>' : '');
                marker.bindPopup(popupHtml);
                markerGroup.push([b.lat, b.lng]);
                markerMap[b.id] = marker;
            });

            if (markerGroup.length > 1) {
                map.fitBounds(markerGroup, { padding: [30, 30] });
            }

            {* Listen for flyto events from card/row clicks *}
            mapEl.addEventListener('bbf-ff-flyto', function(e) {
                if (e.detail && e.detail.lat && e.detail.lng) {
                    map.flyTo([e.detail.lat, e.detail.lng], 16);
                }
            });

            {* Invalidate size after a short delay (OPC may render async) *}
            setTimeout(function() { map.invalidateSize(); }, 300);
        }

        {* Auto-init: wait for Leaflet, then init map *}
        function tryInitMap() {
            if (!hasConsent()) return;
            if (provider === 'osm' && typeof L === 'undefined') {
                if (typeof tryInitMap._retries === 'undefined') tryInitMap._retries = 0;
                if (tryInitMap._retries < 50) {
                    tryInitMap._retries++;
                    setTimeout(tryInitMap, 200);
                } else {
                    if (mapEl) mapEl.innerHTML = '<p style="text-align:center;padding:40px;color:#c00;">Leaflet.js konnte nicht geladen werden. Pr&uuml;fen Sie die Plugin-Konfiguration.</p>';
                }
                return;
            }
            initMap();
        }

        {* Listen for Leaflet CDN fallback load event *}
        document.addEventListener('bbf-leaflet-ready', function() {
            if (mapEl && !mapEl._leaflet_id) tryInitMap();
        });

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', tryInitMap);
        } else {
            setTimeout(tryInitMap, 100);
        }
    })();
    </script>
{/if}
