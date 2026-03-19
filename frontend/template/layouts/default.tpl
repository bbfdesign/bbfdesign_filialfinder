{* BBF Filialfinder – Layout: Karte & Liste (default) *}
<div class="bbf-filialfinder-layout bbf-filialfinder-layout--default">
    {* Left column: branch list *}
    <div class="bbf-filialfinder-list-col">
        <div class="bbf-filialfinder-list" data-ff-list>
            {if $bbfBranches && count($bbfBranches) > 0}
                {foreach $bbfBranches as $branch}
                    {include file="partials/branch-card.tpl" branch=$branch}
                {/foreach}
            {/if}
        </div>
    </div>

    {* Right column: map *}
    {if $ffShowMap == 'true'}
        <div class="bbf-filialfinder-map-col">
            {include file="partials/map-container.tpl"}
        </div>
    {/if}
</div>
