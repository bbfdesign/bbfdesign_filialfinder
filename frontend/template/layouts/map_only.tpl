{* BBF Filialfinder – Layout: Nur Karte *}
<div class="bbf-filialfinder-layout bbf-filialfinder-layout--map-only">
    {* Full-width map *}
    {include file="partials/map-container.tpl"}

    {* Slide-in detail panel (hidden by default, shown on marker click via JS) *}
    <div class="bbf-filialfinder-slidein" data-ff-slidein aria-hidden="true">
        <button type="button" class="bbf-filialfinder-slidein-close" data-ff-slidein-close aria-label="Schliessen">
            &times;
        </button>
        <div class="bbf-filialfinder-slidein-content" data-ff-slidein-content>
            {* Content injected dynamically via JS on marker click *}
        </div>
    </div>

    {* Hidden branch data for JS to populate the slide-in panel *}
    {if $bbfBranches && count($bbfBranches) > 0}
        {foreach $bbfBranches as $branch}
            <template data-ff-branch-template="{$branch.id|intval}">
                {include file="partials/branch-card.tpl" branch=$branch cardModifier='compact'}
            </template>
        {/foreach}
    {/if}
</div>
