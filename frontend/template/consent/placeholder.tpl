{* BBF Filialfinder – Consent Placeholder *}
{* Shown instead of the map when consent has not been given *}

<div class="bbf-filialfinder-consent" data-ff-consent aria-live="polite">
    <div class="bbf-filialfinder-consent-inner">
        {* Lock icon *}
        <div class="bbf-filialfinder-consent-icon" aria-hidden="true">
            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
        </div>

        {* Consent text *}
        <p class="bbf-filialfinder-consent-text">
            {if $bbfSettings.consent_text}
                {$bbfSettings.consent_text|escape:'html'}
            {else}
                Zum Anzeigen der Karte ist Ihre Zustimmung zur Nutzung externer Dienste erforderlich.
                {if $bbfMapProvider == 'google'}
                    Es werden Daten an Google Maps übertragen.
                {else}
                    Es werden Daten an OpenStreetMap übertragen.
                {/if}
            {/if}
        </p>

        {* Privacy policy link *}
        {if $bbfSettings.consent_privacy_url}
            <p class="bbf-filialfinder-consent-privacy">
                <a href="{$bbfSettings.consent_privacy_url|escape:'htmlall'}" target="_blank" rel="noopener noreferrer">
                    {$bbfSettings.consent_privacy_link_text|default:'Datenschutzerklärung'|escape:'html'}
                </a>
            </p>
        {/if}

        {* Accept button *}
        <button type="button" class="bbf-filialfinder-btn bbf-filialfinder-consent-btn" data-ff-consent-accept>
            {$bbfSettings.consent_button_text|default:'Karte aktivieren'|escape:'html'}
        </button>

        {* Optional: remember choice checkbox *}
        {if $bbfSettings.consent_remember_choice == '1'}
            <label class="bbf-filialfinder-consent-remember">
                <input type="checkbox" data-ff-consent-remember value="1">
                {$bbfSettings.consent_remember_text|default:'Auswahl merken'|escape:'html'}
            </label>
        {/if}
    </div>
</div>
