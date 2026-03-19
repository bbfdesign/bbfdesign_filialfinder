{if $isPreview}
<div class="alert alert-info py-2">
    <i class="fa fa-map-marker-alt"></i> BBF Filialfinder
    <small class="d-block text-muted">Layout: {$instance->getProperty('layout')|default:'default'}</small>
</div>
{else}
{assign var=ffData value=$portlet->getFilialfinderData($instance)}
{assign var=ffLayout value=$instance->getProperty('layout')|default:'default'}
{assign var=ffShowTitle value=$instance->getProperty('show_title')}
{assign var=ffTitle value=$instance->getProperty('title')}
{assign var=ffShowMap value=$instance->getProperty('show_map')}
{assign var=ffMapHeight value=$instance->getProperty('map_height')|default:450}

<div class="bbf-filialfinder-wrapper {$instance->getStyleClasses()}"
     style="{$instance->getStyleString()}"
     data-filialfinder
     data-layout="{$ffLayout|escape:'html'}">

    {if $ffShowTitle && $ffTitle}
        <h2 class="bbf-filialfinder-title" style="text-align:center;">
            {$ffTitle|escape:'html'}
        </h2>
    {/if}

    {if !empty($ffData.branches)}
        {if $ffLayout === 'default'}
            <div class="bbf-filialfinder-layout bbf-filialfinder-layout--default">
                <div class="bbf-filialfinder-list-col">
                    <div class="bbf-filialfinder-list">
                        {foreach $ffData.branches as $branch}
                            <div class="bbf-filialfinder-card" data-branch-id="{$branch.id}">
                                <div class="bbf-filialfinder-card__name">{$branch.name|escape:'html'}</div>
                                <div class="bbf-filialfinder-card__address">
                                    {if $branch.street}{$branch.street|escape:'html'}, {/if}
                                    {if $branch.zip}{$branch.zip|escape:'html'} {/if}
                                    {if $branch.city}{$branch.city|escape:'html'}{/if}
                                </div>
                                {if $branch.phone}
                                    <div class="bbf-filialfinder-card__phone">
                                        <a href="tel:{$branch.phone|escape:'url'}">{$branch.phone|escape:'html'}</a>
                                    </div>
                                {/if}
                                {if !empty($branch.status)}
                                    <span class="bbf-filialfinder-status {$branch.status.cssClass}">
                                        {$branch.status.text|escape:'html'}
                                    </span>
                                {/if}
                            </div>
                        {/foreach}
                    </div>
                </div>
                {if $ffShowMap}
                    <div class="bbf-filialfinder-map-col">
                        <div class="bbf-filialfinder-map" data-ff-map style="height:{$ffMapHeight}px;"></div>
                    </div>
                {/if}
            </div>

        {elseif $ffLayout === 'grid'}
            <div class="bbf-filialfinder-grid">
                {foreach $ffData.branches as $branch}
                    <div class="bbf-filialfinder-grid__card">
                        {if $branch.image_path}
                            <img src="{$branch.image_path|escape:'html'}" alt="{$branch.name|escape:'html'}" class="bbf-filialfinder-grid__image">
                        {/if}
                        <div class="bbf-filialfinder-grid__body">
                            <div class="bbf-filialfinder-card__name">{$branch.name|escape:'html'}</div>
                            <div class="bbf-filialfinder-card__address">
                                {$branch.zip|escape:'html'} {$branch.city|escape:'html'}
                            </div>
                            {if !empty($branch.status)}
                                <span class="bbf-filialfinder-status {$branch.status.cssClass}">
                                    {$branch.status.text|escape:'html'}
                                </span>
                            {/if}
                        </div>
                    </div>
                {/foreach}
            </div>

        {elseif $ffLayout === 'map_only'}
            <div class="bbf-filialfinder-map" data-ff-map style="height:{$ffMapHeight}px;"></div>

        {elseif $ffLayout === 'accordion'}
            <div class="bbf-filialfinder-accordion">
                {foreach $ffData.branches as $branch}
                    <div class="bbf-filialfinder-accordion__item">
                        <div class="bbf-filialfinder-accordion__header" onclick="this.classList.toggle('active');this.nextElementSibling.classList.toggle('active');">
                            <span>{$branch.name|escape:'html'}</span>
                            {if !empty($branch.status)}
                                <span class="bbf-filialfinder-status {$branch.status.cssClass}">{$branch.status.text|escape:'html'}</span>
                            {/if}
                        </div>
                        <div class="bbf-filialfinder-accordion__body">
                            <p>{$branch.street|escape:'html'}, {$branch.zip|escape:'html'} {$branch.city|escape:'html'}</p>
                            {if $branch.phone}<p>Tel: <a href="tel:{$branch.phone|escape:'url'}">{$branch.phone|escape:'html'}</a></p>{/if}
                        </div>
                    </div>
                {/foreach}
            </div>

        {elseif $ffLayout === 'table'}
            <table class="bbf-filialfinder-table">
                <thead><tr><th>Name</th><th>Adresse</th><th>Telefon</th><th>Status</th></tr></thead>
                <tbody>
                {foreach $ffData.branches as $branch}
                    <tr>
                        <td>{$branch.name|escape:'html'}</td>
                        <td>{$branch.street|escape:'html'}, {$branch.zip|escape:'html'} {$branch.city|escape:'html'}</td>
                        <td>{if $branch.phone}<a href="tel:{$branch.phone|escape:'url'}">{$branch.phone|escape:'html'}</a>{/if}</td>
                        <td>{if !empty($branch.status)}<span class="bbf-filialfinder-status {$branch.status.cssClass}">{$branch.status.text|escape:'html'}</span>{/if}</td>
                    </tr>
                {/foreach}
                </tbody>
            </table>
        {/if}
    {else}
        <p class="bbf-filialfinder-no-results">Keine Filialen gefunden.</p>
    {/if}
</div>
{/if}
