{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
    package = pkgs.firefox;

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
        "browser.ml.enable" = false;             
        "browser.ml.chat.enabled" = false;       
        "browser.ml.linkPreview.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false; 
        "extensions.getAddons.showPane" = false; 
        "browser.discovery.enabled" = false;     
        
        # --- UX TWEAKS ---
        "browser.aboutConfig.showWarning" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.shell.checkDefaultBrowser" = false;
      };
    };
  };
}
