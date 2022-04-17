{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.sarvesh = {
      extraConfig = ''
        ${builtins.readFile (builtins.fetchurl "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js")}
        user_pref("browser.quitShortcut.disabled", true);
        user_pref("browser.startup.homepage", "moz-extension://b2adf1d5-17ec-4204-9a5a-e37dae27b81e/index.html");
        user_pref("browser.startup.page", 1);
        user_pref("browser.tabs.closeWindowWithLastTab", false);
        user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[\"jid1-zadieub7xozojw_jetpack-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"smart-referer_meh_paranoid_pk-browser-action\",\"skipredirect_sblask-browser-action\",\"_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_3579f63b-d8ee-424f-bbb6-6d0ce3285e6a_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"urlbar-container\",\"save-to-pocket-button\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"jid1-zadieub7xozojw_jetpack-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"smart-referer_meh_paranoid_pk-browser-action\",\"_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action\",\"skipredirect_sblask-browser-action\",\"canvasblocker_kkapsner_de-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_3579f63b-d8ee-424f-bbb6-6d0ce3285e6a_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"widget-overflow-fixed-list\"],\"currentVersion\":17,\"newElementCount\":3}");
        user_pref("extensions.pocket.enabled", false);
        user_pref("extensions.screenshots.disabled", true);
        user_pref("gfx.webrender.all", true);
        user_pref("keyword.enabled", true);
        user_pref("layers.acceleration.force-enabled", true);
        user_pref("network.cookie.lifetimePolicy", 0);
        user_pref("privacy.resistFingerprinting.letterboxing", false);
        user_pref("properties.content.enabled", true);
        user_pref("reader.parse-on-load.enabled", false);
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("ui.key.menuAccessKey", 0);
        user_pref("ui.systemUsesDarkTheme", 1);
      '';
    };
  };
}
