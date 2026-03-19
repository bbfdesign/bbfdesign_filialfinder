{* BBF Filialfinder – Layout: Grid *}
{assign var="ffGridCols" value=$bbfSettings.grid_columns|default:'3'}

<div class="bbf-filialfinder-layout bbf-filialfinder-layout--grid bbf-filialfinder-grid--cols-{$ffGridCols}">
    {if $bbfBranches && count($bbfBranches) > 0}
        {foreach $bbfBranches as $branch}
            <div class="bbf-filialfinder-grid-item">
                <div class="bbf-filialfinder-card bbf-filialfinder-card--grid {$branch.css_class|default:''}"
                     data-branch-id="{$branch.id|intval}"
                     data-lat="{$branch.latitude|escape:'htmlall'}"
                     data-lng="{$branch.longitude|escape:'htmlall'}">

                    {* Branch image *}
                    {if $branch.image_path}
                        <div class="bbf-filialfinder-card-image">
                            <img src="{$branch.image_path|escape:'htmlall'}"
                                 alt="{$branch.name|escape:'htmlall'}"
                                 loading="lazy">
                        </div>
                    {/if}

                    <div class="bbf-filialfinder-card-body">
                        {* Name *}
                        <h3 class="bbf-filialfinder-card-name">
                            {$branch.name|escape:'html'}
                        </h3>

                        {* Address *}
                        <p class="bbf-filialfinder-card-address">
                            {$branch.street|escape:'html'}<br>
                            {$branch.zip|escape:'html'} {$branch.city|escape:'html'}
                        </p>

                        {* Opening status *}
                        {if $branch.status}
                            {include file="partials/opening-status.tpl" statusData=$branch.status}
                        {/if}

                        {* Distance *}
                        {if $branch.distance}
                            <span class="bbf-filialfinder-card-distance" data-ff-distance="{$branch.id|intval}">
                                {$branch.distance|escape:'html'} km
                            </span>
                        {/if}

                        {* More info button *}
                        <div class="bbf-filialfinder-card-actions">
                            <button type="button"
                                    class="bbf-filialfinder-btn bbf-filialfinder-btn--info"
                                    data-ff-detail-btn="{$branch.id|intval}">
                                Mehr Info
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        {/foreach}
    {/if}
</div>

{* Optional map below the grid *}
{if $ffShowMap == 'true'}
    <div class="bbf-filialfinder-grid-map">
        {include file="partials/map-container.tpl"}
    </div>
{/if}
