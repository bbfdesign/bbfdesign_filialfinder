{* BBF Filialfinder – Layout: Accordion *}
<div class="bbf-filialfinder-layout bbf-filialfinder-layout--accordion">
    {if $bbfBranches && count($bbfBranches) > 0}
        <div class="bbf-filialfinder-accordion" data-ff-accordion>
            {foreach $bbfBranches as $branch}
                {assign var="ffAccId" value="bbf-acc-{$bbfInstanceId|default:'1'}-{$branch.id|intval}"}
                <div class="bbf-filialfinder-accordion-item {$branch.css_class|default:''}"
                     data-branch-id="{$branch.id|intval}">

                    {* Accordion header *}
                    <button type="button"
                            class="bbf-filialfinder-accordion-header"
                            aria-expanded="false"
                            aria-controls="{$ffAccId}"
                            data-ff-accordion-toggle>
                        <span class="bbf-filialfinder-accordion-name">
                            {$branch.name|escape:'html'}
                        </span>
                        {if $branch.status}
                            <span class="bbf-filialfinder-accordion-status {$branch.status.cssClass|escape:'htmlall'}">
                                {$branch.status.text|escape:'html'}
                            </span>
                        {/if}
                        <span class="bbf-filialfinder-accordion-icon" aria-hidden="true">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                        </span>
                    </button>

                    {* Accordion body *}
                    <div class="bbf-filialfinder-accordion-body"
                         id="{$ffAccId}"
                         role="region"
                         aria-hidden="true">
                        <div class="bbf-filialfinder-accordion-content">
                            <div class="bbf-filialfinder-accordion-details">
                                {* Address *}
                                <p class="bbf-filialfinder-card-address">
                                    {$branch.street|escape:'html'}<br>
                                    {$branch.zip|escape:'html'} {$branch.city|escape:'html'}
                                    {if $branch.country}<br>{$branch.country|escape:'html'}{/if}
                                </p>

                                {* Phone *}
                                {if $branch.phone}
                                    <p class="bbf-filialfinder-card-phone">
                                        <a href="tel:{$branch.phone|escape:'url'}">{$branch.phone|escape:'html'}</a>
                                    </p>
                                {/if}

                                {* Email *}
                                {if $branch.email}
                                    <p class="bbf-filialfinder-card-email">
                                        <a href="mailto:{$branch.email|escape:'htmlall'}">{$branch.email|escape:'html'}</a>
                                    </p>
                                {/if}

                                {* Website *}
                                {if $branch.website}
                                    <p class="bbf-filialfinder-card-website">
                                        <a href="{$branch.website|escape:'htmlall'}" target="_blank" rel="noopener noreferrer">
                                            Website besuchen
                                        </a>
                                    </p>
                                {/if}

                                {* Description *}
                                {if $branch.description}
                                    <div class="bbf-filialfinder-card-description">
                                        {$branch.description}
                                    </div>
                                {/if}

                                {* Opening status (full) *}
                                {if $branch.status}
                                    {include file="partials/opening-status.tpl" statusData=$branch.status}
                                {/if}

                                {* Route link *}
                                <div class="bbf-filialfinder-card-actions">
                                    <a href="https://www.google.com/maps/dir/?api=1&destination={$branch.latitude|escape:'url'},{$branch.longitude|escape:'url'}"
                                       class="bbf-filialfinder-btn bbf-filialfinder-btn--route"
                                       target="_blank"
                                       rel="noopener noreferrer">
                                        Route berechnen
                                    </a>
                                </div>
                            </div>

                            {* Mini map *}
                            {if $ffShowMap == 'true'}
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
    {/if}
</div>
