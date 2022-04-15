{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles."sarvesh" = {
      isDefault = true;
      extraConfig = builtins.readFile
        (builtins.fetchurl "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js") + ''
        user_perf("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[\"canvasblocker_kkapsner_de-browser-action\",\"skipredirect_sblask-browser-action\",\"smart-referer_meh_paranoid_pk-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_3579f63b-d8ee-424f-bbb6-6d0ce3285e6a_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"urlbar-container\",\"save-to-pocket-button\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"canvasblocker_kkapsner_de-browser-action\",\"skipredirect_sblask-browser-action\",\"smart-referer_meh_paranoid_pk-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_3579f63b-d8ee-424f-bbb6-6d0ce3285e6a_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"TabsToolbar\",\"toolbar-menubar\",\"widget-overflow-fixed-list\"],\"currentVersion\":17,\"newElementCount\":4}");
        user_perf("gfx.webrender.all", true);
        user_perf("layers.acceleration.force-enabled", true);
        user_pref("browser.newtab.preload", true);
        user_pref("browser.quitShortcut.disabled", true);
        user_pref("browser.startup.homepage", "moz-extension://f12c07e0-800d-4c28-9a40-e96208403d1e/index.html");
        user_pref("browser.startup.page", 1);
        user_pref("browser.tabs.closeWindowWithLastTab", false);
        user_pref("extensions.pocket.enabled", false);
        user_pref("extensions.screenshots.disabled", false);
        user_pref("keyword.enabled", true);
        user_pref("network.cookie.lifetimePolicy", 0);
        user_pref("privacy.resistFingerprinting.letterboxing", false);
        user_pref("reader.parse-on-load.enabled", false);
        user_pref("ui.key.menuAccessKey", 0);
        user_pref("ui.prefersReducedMotion", 1);
        user_pref("ui.systemUsesDarkTheme", 1);
      '';
    };
  };
}
