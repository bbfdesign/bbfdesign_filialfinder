<form id="bbf-performance-form">

    {* ===== Card: Performance-Optimierung ===== *}
    <div class="bbf-card">
        <div class="bbf-card-title">Performance-Optimierung</div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Lazy Loading der Karte</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_performance_lazy_load" value="1" {if $allSettings.performance_lazy_load|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
            <div class="bbf-form-hint">Karte erst laden wenn im sichtbaren Bereich</div>
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">JS/CSS nur auf Plugin-Seiten</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_performance_selective_loading" value="1" {if $allSettings.performance_selective_loading|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
            <div class="bbf-form-hint">Assets nur laden wenn der Filialfinder auf der Seite eingebunden ist</div>
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Karten-Skripte im Footer</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_performance_footer_scripts" value="1" {if $allSettings.performance_footer_scripts|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
            <div class="bbf-form-hint">Verbessert die Ladezeit der Seite</div>
        </div>

        <div class="bbf-form-group">
            <div class="bbf-flex-between">
                <label class="bbf-form-label">Bildoptimierung</label>
                <label class="bbf-toggle">
                    <input type="checkbox" name="setting_performance_image_optimization" value="1" {if $allSettings.performance_image_optimization|default:'0' == '1'}checked{/if}>
                    <span class="bbf-toggle-slider"></span>
                </label>
            </div>
            <div class="bbf-form-hint">Filialbilder automatisch komprimieren</div>
        </div>
    </div>

    <button type="button" class="bbf-btn bbf-btn-primary" onclick="bbfSaveSettings('bbf-performance-form', 'performance')">Einstellungen speichern</button>

</form>
