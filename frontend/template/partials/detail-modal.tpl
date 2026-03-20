{* BBF Filialfinder – Partial: Branch Detail Modal *}
{* Variables: $branch (branch data object/array), $bbfSettings (global plugin settings) *}

<div class="bbf-filialfinder-modal-overlay" id="bbf-ff-modal-{$branch.id|intval}" data-ff-modal="{$branch.id|intval}" style="display:none;"
     role="dialog" aria-modal="true" aria-labelledby="bbf-ff-modal-title-{$branch.id|intval}">
    <div class="bbf-filialfinder-modal bbf-filialfinder-modal--{$bbfSettings.modal_width|default:'medium'}"
         data-ff-modal-animation="{$bbfSettings.modal_animation|default:'fade'}">

        {* Close Button *}
        <button class="bbf-filialfinder-modal__close" data-ff-modal-close aria-label="Modal schlie&szlig;en">&times;</button>

        {* ===== Header ===== *}
        <div class="bbf-filialfinder-modal__header">
            <h2 class="bbf-filialfinder-modal__title" id="bbf-ff-modal-title-{$branch.id|intval}">
                {$branch.name|escape:'html'}
            </h2>
            {* Opening status badge *}
            {if $branch.status}
                <span class="bbf-filialfinder-status {$branch.status.cssClass|escape:'htmlall'}">
                    {if $bbfSettings.status_animated_dot == '1'}
                        <span class="bbf-filialfinder-status-dot" aria-hidden="true"></span>
                    {/if}
                    <span class="bbf-filialfinder-status-text">{$branch.status.text|escape:'html'}</span>
                </span>
            {/if}
        </div>

        {* ===== Body ===== *}
        <div class="bbf-filialfinder-modal__body">

            {* ---------- Image Gallery ---------- *}
            {if $bbfSettings.modal_show_gallery|default:'1' == '1'}
                {if !empty($branch.gallery)}
                    <div class="bbf-filialfinder-gallery" data-ff-gallery>
                        <div class="bbf-filialfinder-gallery__main">
                            <img src="{$branch.gallery[0].image_path|escape:'htmlall'}"
                                 alt="{$branch.gallery[0].alt_text|default:$branch.name|escape:'html'}"
                                 class="bbf-filialfinder-gallery__image"
                                 data-ff-gallery-main
                                 {if $bbfSettings.modal_lightbox|default:'1' == '1'}data-ff-lightbox{/if}>
                        </div>
                        {if count($branch.gallery) > 1}
                            <div class="bbf-filialfinder-gallery__thumbs">
                                {foreach $branch.gallery as $img}
                                    {if $img@iteration <= ($bbfSettings.modal_max_images|default:10)}
                                        <img src="{$img.image_path|escape:'htmlall'}"
                                             alt="{$img.alt_text|default:''|escape:'html'}"
                                             class="bbf-filialfinder-gallery__thumb{if $img@first} active{/if}"
                                             data-ff-gallery-thumb
                                             onclick="bbfGallerySelect(this, '{$img.image_path|escape:'javascript'}')">
                                    {/if}
                                {/foreach}
                            </div>
                        {/if}
                    </div>
                {elseif !empty($branch.image_path)}
                    <div class="bbf-filialfinder-gallery">
                        <img src="{$branch.image_path|escape:'htmlall'}"
                             alt="{$branch.name|escape:'html'}"
                             class="bbf-filialfinder-gallery__image"
                             {if $bbfSettings.modal_lightbox|default:'1' == '1'}data-ff-lightbox{/if}>
                    </div>
                {/if}
            {/if}

            {* ---------- Videos ---------- *}
            {if $bbfSettings.modal_show_videos|default:'1' == '1' && !empty($branch.videos)}
                <div class="bbf-filialfinder-videos">
                    <h3 class="bbf-filialfinder-videos__title">Videos</h3>
                    <div class="bbf-filialfinder-videos__grid">
                        {foreach $branch.videos as $video}
                            <div class="bbf-filialfinder-video" data-ff-video
                                 data-type="{$video.video_type|escape:'htmlall'}"
                                 data-url="{$video.video_url|escape:'htmlall'}">
                                {* Determine embed URL based on video type *}
                                {if $video.video_type === 'youtube'}
                                    {* Extract YouTube video ID *}
                                    {assign var="ytId" value=$video.video_id|default:''}
                                    {if $bbfSettings.modal_youtube_privacy|default:'1' == '1'}
                                        {assign var="ytDomain" value='www.youtube-nocookie.com'}
                                    {else}
                                        {assign var="ytDomain" value='www.youtube.com'}
                                    {/if}
                                    <div class="bbf-filialfinder-video__wrapper" data-ff-video-container>
                                        <div class="bbf-filialfinder-video__thumbnail" data-ff-video-thumb>
                                            <img src="https://img.youtube.com/vi/{$ytId|escape:'url'}/hqdefault.jpg"
                                                 alt="Video: {$branch.name|escape:'html'}"
                                                 class="bbf-filialfinder-video__poster"
                                                 loading="lazy">
                                            <button class="bbf-filialfinder-video__play" aria-label="Video abspielen"
                                                    onclick="bbfLoadVideo(this, 'https://{$ytDomain}/embed/{$ytId|escape:'url'}?autoplay=1&rel=0')">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                                            </button>
                                        </div>
                                    </div>
                                {elseif $video.video_type === 'vimeo'}
                                    {assign var="vimeoId" value=$video.video_id|default:''}
                                    <div class="bbf-filialfinder-video__wrapper" data-ff-video-container>
                                        <div class="bbf-filialfinder-video__thumbnail" data-ff-video-thumb>
                                            {if !empty($video.thumbnail_url)}
                                                <img src="{$video.thumbnail_url|escape:'htmlall'}"
                                                     alt="Video: {$branch.name|escape:'html'}"
                                                     class="bbf-filialfinder-video__poster"
                                                     loading="lazy">
                                            {/if}
                                            <button class="bbf-filialfinder-video__play" aria-label="Video abspielen"
                                                    onclick="bbfLoadVideo(this, 'https://player.vimeo.com/video/{$vimeoId|escape:'url'}?autoplay=1')">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                                            </button>
                                        </div>
                                    </div>
                                {else}
                                    {* Generic / self-hosted video *}
                                    <div class="bbf-filialfinder-video__wrapper" data-ff-video-container>
                                        <video class="bbf-filialfinder-video__player" controls preload="metadata">
                                            <source src="{$video.video_url|escape:'htmlall'}" type="video/mp4">
                                            Ihr Browser unterst&uuml;tzt dieses Video-Format nicht.
                                        </video>
                                    </div>
                                {/if}
                            </div>
                        {/foreach}
                    </div>
                </div>
            {/if}

            {* ---------- Description ---------- *}
            {if $bbfSettings.modal_show_description|default:'1' == '1'}
                {if !empty($branch.description_html)}
                    <div class="bbf-filialfinder-modal__description">
                        {$branch.description_html}
                    </div>
                {elseif !empty($branch.description)}
                    <div class="bbf-filialfinder-modal__description">
                        {$branch.description|escape:'html'|nl2br}
                    </div>
                {/if}
            {/if}

            {* ---------- Contact Info ---------- *}
            <div class="bbf-filialfinder-modal__contact">
                {* Address *}
                {if $branch.street || $branch.city}
                    <div class="bbf-filialfinder-modal__contact-item">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                        <address class="bbf-filialfinder-modal__address">
                            {if $branch.street}{$branch.street|escape:'html'}<br>{/if}
                            {if $branch.zip || $branch.city}{$branch.zip|escape:'html'} {$branch.city|escape:'html'}<br>{/if}
                            {if $bbfSettings.card_show_country == '1' && $branch.country}{$branch.country|escape:'html'}{/if}
                        </address>
                    </div>
                {/if}

                {* Phone *}
                {if $branch.phone}
                    <div class="bbf-filialfinder-modal__contact-item">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6A19.79 19.79 0 0 1 2.12 4.18 2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                        <a href="tel:{$branch.phone|escape:'url'}" class="bbf-filialfinder-modal__link">
                            {$branch.phone|escape:'html'}
                        </a>
                    </div>
                {/if}

                {* Email *}
                {if $branch.email}
                    <div class="bbf-filialfinder-modal__contact-item">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                        <a href="mailto:{$branch.email|escape:'htmlall'}" class="bbf-filialfinder-modal__link">
                            {$branch.email|escape:'html'}
                        </a>
                    </div>
                {/if}

                {* Website *}
                {if $branch.website}
                    <div class="bbf-filialfinder-modal__contact-item">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
                        <a href="{$branch.website|escape:'htmlall'}" target="_blank" rel="noopener noreferrer" class="bbf-filialfinder-modal__link">
                            {$branch.website|escape:'html'}
                        </a>
                    </div>
                {/if}
            </div>

            {* ---------- Opening Hours Table ---------- *}
            {if $bbfSettings.modal_show_hours|default:'1' == '1' && !empty($branch.opening_hours)}
                <div class="bbf-filialfinder-modal__hours">
                    <h3 class="bbf-filialfinder-modal__section-title">&Ouml;ffnungszeiten</h3>
                    <table class="bbf-filialfinder-hours-table">
                        <tbody>
                            {* Monday *}
                            <tr class="bbf-filialfinder-hours-table__row{if $branch.current_day === 'monday'} bbf-filialfinder-hours-table__row--today{/if}">
                                <td class="bbf-filialfinder-hours-table__day">Montag</td>
                                <td class="bbf-filialfinder-hours-table__time">
                                    {if !empty($branch.opening_hours.monday.open) && !empty($branch.opening_hours.monday.close)}
                                        {$branch.opening_hours.monday.open|escape:'html'} &ndash; {$branch.opening_hours.monday.close|escape:'html'}
                                        {if !empty($branch.opening_hours.monday.open2) && !empty($branch.opening_hours.monday.close2)}
                                            <br>{$branch.opening_hours.monday.open2|escape:'html'} &ndash; {$branch.opening_hours.monday.close2|escape:'html'}
                                        {/if}
                                    {else}
                                        <span class="bbf-filialfinder-hours-table__closed">Geschlossen</span>
                                    {/if}
                                </td>
                            </tr>
                            {* Tuesday *}
                            <tr class="bbf-filialfinder-hours-table__row{if $branch.current_day === 'tuesday'} bbf-filialfinder-hours-table__row--today{/if}">
                                <td class="bbf-filialfinder-hours-table__day">Dienstag</td>
                                <td class="bbf-filialfinder-hours-table__time">
                                    {if !empty($branch.opening_hours.tuesday.open) && !empty($branch.opening_hours.tuesday.close)}
                                        {$branch.opening_hours.tuesday.open|escape:'html'} &ndash; {$branch.opening_hours.tuesday.close|escape:'html'}
                                        {if !empty($branch.opening_hours.tuesday.open2) && !empty($branch.opening_hours.tuesday.close2)}
                                            <br>{$branch.opening_hours.tuesday.open2|escape:'html'} &ndash; {$branch.opening_hours.tuesday.close2|escape:'html'}
                                        {/if}
                                    {else}
                                        <span class="bbf-filialfinder-hours-table__closed">Geschlossen</span>
                                    {/if}
                                </td>
                            </tr>
                            {* Wednesday *}
                            <tr class="bbf-filialfinder-hours-table__row{if $branch.current_day === 'wednesday'} bbf-filialfinder-hours-table__row--today{/if}">
                                <td class="bbf-filialfinder-hours-table__day">Mittwoch</td>
                                <td class="bbf-filialfinder-hours-table__time">
                                    {if !empty($branch.opening_hours.wednesday.open) && !empty($branch.opening_hours.wednesday.close)}
                                        {$branch.opening_hours.wednesday.open|escape:'html'} &ndash; {$branch.opening_hours.wednesday.close|escape:'html'}
                                        {if !empty($branch.opening_hours.wednesday.open2) && !empty($branch.opening_hours.wednesday.close2)}
                                            <br>{$branch.opening_hours.wednesday.open2|escape:'html'} &ndash; {$branch.opening_hours.wednesday.close2|escape:'html'}
                                        {/if}
                                    {else}
                                        <span class="bbf-filialfinder-hours-table__closed">Geschlossen</span>
                                    {/if}
                                </td>
                            </tr>
                            {* Thursday *}
                            <tr class="bbf-filialfinder-hours-table__row{if $branch.current_day === 'thursday'} bbf-filialfinder-hours-table__row--today{/if}">
                                <td class="bbf-filialfinder-hours-table__day">Donnerstag</td>
                                <td class="bbf-filialfinder-hours-table__time">
                                    {if !empty($branch.opening_hours.thursday.open) && !empty($branch.opening_hours.thursday.close)}
                                        {$branch.opening_hours.thursday.open|escape:'html'} &ndash; {$branch.opening_hours.thursday.close|escape:'html'}
                                        {if !empty($branch.opening_hours.thursday.open2) && !empty($branch.opening_hours.thursday.close2)}
                                            <br>{$branch.opening_hours.thursday.open2|escape:'html'} &ndash; {$branch.opening_hours.thursday.close2|escape:'html'}
                                        {/if}
                                    {else}
                                        <span class="bbf-filialfinder-hours-table__closed">Geschlossen</span>
                                    {/if}
                                </td>
                            </tr>
                            {* Friday *}
                            <tr class="bbf-filialfinder-hours-table__row{if $branch.current_day === 'friday'} bbf-filialfinder-hours-table__row--today{/if}">
                                <td class="bbf-filialfinder-hours-table__day">Freitag</td>
                                <td class="bbf-filialfinder-hours-table__time">
                                    {if !empty($branch.opening_hours.friday.open) && !empty($branch.opening_hours.friday.close)}
                                        {$branch.opening_hours.friday.open|escape:'html'} &ndash; {$branch.opening_hours.friday.close|escape:'html'}
                                        {if !empty($branch.opening_hours.friday.open2) && !empty($branch.opening_hours.friday.close2)}
                                            <br>{$branch.opening_hours.friday.open2|escape:'html'} &ndash; {$branch.opening_hours.friday.close2|escape:'html'}
                                        {/if}
                                    {else}
                                        <span class="bbf-filialfinder-hours-table__closed">Geschlossen</span>
                                    {/if}
                                </td>
                            </tr>
                            {* Saturday *}
                            <tr class="bbf-filialfinder-hours-table__row{if $branch.current_day === 'saturday'} bbf-filialfinder-hours-table__row--today{/if}">
                                <td class="bbf-filialfinder-hours-table__day">Samstag</td>
                                <td class="bbf-filialfinder-hours-table__time">
                                    {if !empty($branch.opening_hours.saturday.open) && !empty($branch.opening_hours.saturday.close)}
                                        {$branch.opening_hours.saturday.open|escape:'html'} &ndash; {$branch.opening_hours.saturday.close|escape:'html'}
                                        {if !empty($branch.opening_hours.saturday.open2) && !empty($branch.opening_hours.saturday.close2)}
                                            <br>{$branch.opening_hours.saturday.open2|escape:'html'} &ndash; {$branch.opening_hours.saturday.close2|escape:'html'}
                                        {/if}
                                    {else}
                                        <span class="bbf-filialfinder-hours-table__closed">Geschlossen</span>
                                    {/if}
                                </td>
                            </tr>
                            {* Sunday *}
                            <tr class="bbf-filialfinder-hours-table__row{if $branch.current_day === 'sunday'} bbf-filialfinder-hours-table__row--today{/if}">
                                <td class="bbf-filialfinder-hours-table__day">Sonntag</td>
                                <td class="bbf-filialfinder-hours-table__time">
                                    {if !empty($branch.opening_hours.sunday.open) && !empty($branch.opening_hours.sunday.close)}
                                        {$branch.opening_hours.sunday.open|escape:'html'} &ndash; {$branch.opening_hours.sunday.close|escape:'html'}
                                        {if !empty($branch.opening_hours.sunday.open2) && !empty($branch.opening_hours.sunday.close2)}
                                            <br>{$branch.opening_hours.sunday.open2|escape:'html'} &ndash; {$branch.opening_hours.sunday.close2|escape:'html'}
                                        {/if}
                                    {else}
                                        <span class="bbf-filialfinder-hours-table__closed">Geschlossen</span>
                                    {/if}
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    {* Special days / holiday notices *}
                    {if !empty($branch.special_hours)}
                        <div class="bbf-filialfinder-hours-special">
                            <h4 class="bbf-filialfinder-hours-special__title">Besondere &Ouml;ffnungszeiten</h4>
                            {foreach $branch.special_hours as $special}
                                <div class="bbf-filialfinder-hours-special__item">
                                    <span class="bbf-filialfinder-hours-special__date">{$special.date|escape:'html'}</span>
                                    <span class="bbf-filialfinder-hours-special__label">{$special.label|escape:'html'}</span>
                                    <span class="bbf-filialfinder-hours-special__time">
                                        {if $special.closed}
                                            Geschlossen
                                        {else}
                                            {$special.open|escape:'html'} &ndash; {$special.close|escape:'html'}
                                        {/if}
                                    </span>
                                </div>
                            {/foreach}
                        </div>
                    {/if}
                </div>
            {/if}

            {* ---------- Mini Map ---------- *}
            {if $bbfSettings.modal_show_map|default:'1' == '1' && $branch.latitude && $branch.longitude}
                <div class="bbf-filialfinder-modal__map" data-ff-modal-map
                     data-lat="{$branch.latitude|escape:'htmlall'}"
                     data-lng="{$branch.longitude|escape:'htmlall'}">
                </div>
            {/if}

            {* ---------- Action Buttons ---------- *}
            <div class="bbf-filialfinder-modal__actions">
                {if $bbfSettings.modal_show_directions|default:'1' == '1' && $branch.latitude && $branch.longitude}
                    <a href="https://www.google.com/maps/dir/?api=1&destination={$branch.latitude|escape:'url'},{$branch.longitude|escape:'url'}"
                       target="_blank" rel="noopener noreferrer"
                       class="bbf-filialfinder-btn bbf-filialfinder-btn--primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="3 11 22 2 13 21 11 13 3 11"/></svg>
                        Route berechnen
                    </a>
                {/if}
                {if $branch.website}
                    <a href="{$branch.website|escape:'htmlall'}" target="_blank" rel="noopener noreferrer"
                       class="bbf-filialfinder-btn bbf-filialfinder-btn--secondary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>
                        Website besuchen
                    </a>
                {/if}
            </div>

            {* ---------- Holiday Highlight ---------- *}
            {if !empty($branch.holiday_highlight)}
                <div class="bbf-filialfinder-highlight">
                    <span class="bbf-filialfinder-highlight__icon" aria-hidden="true">&#127881;</span>
                    <span class="bbf-filialfinder-highlight__text">{$branch.holiday_highlight.text|escape:'html'}</span>
                </div>
            {/if}

        </div>{* /modal__body *}
    </div>{* /modal *}
</div>{* /modal-overlay *}
