
{ pkgs, ... }:

{

  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        # --- PRIVACY & TELEMETRY ---
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        # --- AI & BLOAT OPT-OUT ---
        "browser.ml.enable" = false;             # Disable local ML engine
        "browser.ml.chat.enabled" = false;       # Disable Chatbot sidebar
        "browser.ml.linkPreview.enabled" = false;# Disable AI link previews
        "browser.tabs.groups.smart.enabled" = false; 
        "extensions.getAddons.showPane" = false; # Hide "Recommendations"
        "browser.discovery.enabled" = false;     # Disable "Pocket" discovery
        
        # --- UX TWEAKS ---
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;
      };
    };
  };
}
