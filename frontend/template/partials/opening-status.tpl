{* BBF Filialfinder – Partial: Opening Status Badge *}
{* Variables: $statusData (array with keys: status, text, cssClass, nextOpening) *}

<span class="bbf-filialfinder-status {$statusData.cssClass|escape:'htmlall'}"
      data-ff-status>
    {* Animated dot (if enabled in settings) *}
    {if $bbfSettings.status_animated_dot == '1'}
        <span class="bbf-filialfinder-status-dot" aria-hidden="true"></span>
    {/if}

    {* Status text *}
    <span class="bbf-filialfinder-status-text">
        {$statusData.text|escape:'html'}
    </span>

    {* Next opening hint *}
    {if $statusData.status == 'closed' && $statusData.nextOpening && $bbfSettings.status_show_next_opening == '1'}
        <span class="bbf-filialfinder-status-next">
            &middot; {$statusData.nextOpening|escape:'html'}
        </span>
    {/if}
</span>
