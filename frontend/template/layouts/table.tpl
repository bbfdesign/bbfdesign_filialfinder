{* BBF Filialfinder – Layout: Tabelle *}
<div class="bbf-filialfinder-layout bbf-filialfinder-layout--table">
    {if $ffShowMap == 'true'}
        <div class="bbf-filialfinder-table-map">
            {include file="partials/map-container.tpl"}
        </div>
    {/if}

    {if $bbfBranches && count($bbfBranches) > 0}
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
                    {foreach $bbfBranches as $branch}
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
                                    {include file="partials/opening-status.tpl" statusData=$branch.status}
                                {else}
                                    &ndash;
                                {/if}
                            </td>
                            <td class="bbf-filialfinder-table-td bbf-filialfinder-table-td--distance" data-label="Entfernung">
                                <span data-ff-distance="{$branch.id|intval}">
                                    {if $branch.distance}
                                        {$branch.distance|escape:'html'} km
                                    {else}
                                        &ndash;
                                    {/if}
                                </span>
                            </td>
                            <td class="bbf-filialfinder-table-td bbf-filialfinder-table-td--actions">
                                <a href="https://www.google.com/maps/dir/?api=1&destination={$branch.latitude|escape:'url'},{$branch.longitude|escape:'url'}"
                                   class="bbf-filialfinder-btn bbf-filialfinder-btn--route bbf-filialfinder-btn--sm"
                                   target="_blank"
                                   rel="noopener noreferrer"
                                   title="Route berechnen">
                                    Route
                                </a>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    {/if}
</div>
