{* BBF Filialfinder – Partial: Map Container *}
{* Provides the div that JS initializes as the interactive map *}

<div class="bbf-filialfinder-map"
     data-ff-map
     data-provider="{$bbfMapProvider|escape:'htmlall'}"
     data-zoom="{$bbfSettings.map_default_zoom|default:'12'|escape:'htmlall'}"
     data-center-lat="{$bbfSettings.map_center_lat|default:'51.1657'|escape:'htmlall'}"
     data-center-lng="{$bbfSettings.map_center_lng|default:'10.4515'|escape:'htmlall'}"
     data-cluster="{$bbfSettings.map_marker_cluster|default:'1'|escape:'htmlall'}"
     data-style="{$bbfSettings.map_style|default:''|escape:'htmlall'}"
     style="height:{$ffMapHeight|escape:'htmlall'}px; width:100%;"
     role="application"
     aria-label="Filialstandorte Karte">

    {* Map loading placeholder *}
    <div class="bbf-filialfinder-map-loading" data-ff-map-loading>
        <span class="bbf-filialfinder-spinner" aria-hidden="true"></span>
        <span>Karte wird geladen&hellip;</span>
    </div>
</div>

{* Branch marker data for JS (hidden, read by frontend script) *}
{if $bbfBranches && count($bbfBranches) > 0}
    <script type="application/json" data-ff-markers>
    [
        {foreach $bbfBranches as $branch name=markers}
        {ldelim}
            "id": {$branch.id|intval},
            "name": {$branch.name|json_encode},
            "street": {$branch.street|json_encode},
            "zip": {$branch.zip|json_encode},
            "city": {$branch.city|json_encode},
            "lat": {$branch.latitude|escape:'htmlall'},
            "lng": {$branch.longitude|escape:'htmlall'},
            "phone": {$branch.phone|default:''|json_encode},
            "markerColor": {$branch.marker_color|default:''|json_encode}
        {rdelim}{if !$smarty.foreach.markers.last},{/if}
        {/foreach}
    ]
    </script>
{/if}
