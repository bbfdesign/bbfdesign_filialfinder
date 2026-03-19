{* BBF Filialfinder – Frontend Wrapper *}
{assign var="ffLayout" value=$bbfParams.layout|default:$bbfSettings.layout_template|default:'default'}
{assign var="ffShowTitle" value=$bbfParams.show_title|default:'true'}
{assign var="ffTitle" value=$bbfParams.title|default:$bbfSettings.styling_title|default:''}
{assign var="ffShowMap" value=$bbfParams.show_map|default:'true'}
{assign var="ffMapHeight" value=$bbfParams.map_height|default:$bbfSettings.map_height|default:'450'}
{assign var="ffClass" value=$bbfParams.class|default:''}

<div class="bbf-filialfinder-wrapper{if $ffClass} {$ffClass}{/if}"
     data-filialfinder
     data-provider="{$bbfMapProvider|escape:'htmlall'}"
     data-status='{$bbfStatusData}'
     data-settings='{$bbfSettings|json_encode}'
     id="bbf-filialfinder-{$bbfInstanceId|default:'1'}">

    {* Title block *}
    {if $ffShowTitle == 'true' && $ffTitle}
        {assign var="ffTitleTag" value=$bbfSettings.styling_title_tag|default:'h2'}
        {assign var="ffTitleAlign" value=$bbfSettings.styling_title_align|default:'center'}
        <{$ffTitleTag} class="bbf-filialfinder-title" style="text-align:{$ffTitleAlign}">
            {$ffTitle|escape:'html'}
        </{$ffTitleTag}>
        {if $bbfSettings.styling_subtitle}
            <p class="bbf-filialfinder-subtitle" style="text-align:{$ffTitleAlign}">
                {$bbfSettings.styling_subtitle|escape:'html'}
            </p>
        {/if}
        {if $bbfSettings.styling_divider == '1'}
            {assign var="ffDividerColor" value=$bbfSettings.styling_divider_color|default:'#c8a96e'}
            {assign var="ffDividerWidth" value=$bbfSettings.styling_divider_width|default:'80'}
            <div class="bbf-filialfinder-divider" style="width:{$ffDividerWidth}px; height:3px; background:{$ffDividerColor}; margin:10px auto 20px;"></div>
        {/if}
    {/if}

    {* Search field *}
    {if $bbfSettings.geo_search_field == '1'}
        <div class="bbf-filialfinder-search">
            <input type="text"
                   class="bbf-filialfinder-search-input"
                   placeholder="{$bbfSettings.geo_search_placeholder|default:'PLZ oder Ort eingeben...'|escape:'htmlall'}"
                   data-ff-search
                   autocomplete="off">
            <button type="button" class="bbf-filialfinder-search-btn" data-ff-search-btn>
                {$bbfSettings.geo_search_button_text|default:'Suchen'}
            </button>
            {if $bbfSettings.geo_locate_button == '1'}
                <button type="button" class="bbf-filialfinder-locate-btn" data-ff-locate-btn title="Meinen Standort verwenden">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="4"/><line x1="1.05" y1="12" x2="7" y2="12"/><line x1="17.01" y1="12" x2="22.96" y2="12"/><line x1="12" y1="1.05" x2="12" y2="7"/><line x1="12" y1="17.01" x2="12" y2="22.96"/></svg>
                </button>
            {/if}
        </div>
    {/if}

    {* Include selected layout *}
    {if $ffLayout == 'map_only'}
        {include file="layouts/map_only.tpl"}
    {elseif $ffLayout == 'grid'}
        {include file="layouts/grid.tpl"}
    {elseif $ffLayout == 'accordion'}
        {include file="layouts/accordion.tpl"}
    {elseif $ffLayout == 'table'}
        {include file="layouts/table.tpl"}
    {else}
        {include file="layouts/default.tpl"}
    {/if}

    {* No results message *}
    {if !$bbfBranches || count($bbfBranches) == 0}
        <div class="bbf-filialfinder-no-results">
            {$bbfSettings.styling_no_results_text|default:'Keine Filialen gefunden.'|escape:'html'}
        </div>
    {/if}
</div>

{* Consent placeholder (rendered outside main wrapper, toggled by JS) *}
{if $bbfConsentRequired}
    {include file="consent/placeholder.tpl"}
{/if}
