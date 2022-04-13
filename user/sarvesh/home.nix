{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  home = {
    username = "sarvesh";
    homeDirectory = "/home/sarvesh";
    stateVersion = "21.11";
    packages = with pkgs; [
      bpytop
      onlyoffice-bin
      pamixer
      xfce.thunar
      nixpkgs-fmt
      # (unstable.tor-browser-bundle-bin.override {
      # useHardenedMalloc = false;
      # })
    ];
    file = {
      ".mozilla/firefox/sarvesh/chrome/userChrome.css".source = ./mozilla/firefox/sarvesh/chrome/userChrome.css;
      ".bin/fetch" = {
        executable = true;
        source = ./bin/fetch;
      };
    };
  };

  xdg.configFile = {
    "sway/scripts/brightness.sh" = {
      executable = true;
      source = ./config/sway/scripts/brightness.sh;
    };
    "sway/scripts/volume.sh" = {
      executable = true;
      source = ./config/sway/scripts/volume.sh;
    };
    "fish/functions/fish_prompt.fish".source = ./config/fish/functions/fish_prompt.fish;
    "fetch/conf".source = ./config/fetch/conf;
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      gaps.inner = 12;
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      keybindings = {
        "Mod4+Return" = "exec foot";
        "Mod4+space" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
        "Mod4+q" = "kill";
        "Mod4+Left" = "focus left";
        "Mod4+Down" = "focus down";
        "Mod4+Up" = "focus up";
        "Mod4+Right" = "focus right";
        "Mod4+Shift+Left" = "move left";
        "Mod4+Shift+Down" = "move down";
        "Mod4+Shift+Up" = "move up";
        "Mod4+Shift+Right" = "move right";
        "Mod4+1" = "workspace number 1";
        "Mod4+2" = "workspace number 2";
        "Mod4+3" = "workspace number 3";
        "Mod4+4" = "workspace number 4";
        "Mod4+5" = "workspace number 5";
        "Mod4+6" = "workspace number 6";
        "Mod4+7" = "workspace number 7";
        "Mod4+8" = "workspace number 8";
        "Mod4+9" = "workspace number 9";
        "Mod4+0" = "workspace number 10";
        "Mod4+Shift+1" = "move container to workspace number 1";
        "Mod4+Shift+2" = "move container to workspace number 2";
        "Mod4+Shift+3" = "move container to workspace number 3";
        "Mod4+Shift+4" = "move container to workspace number 4";
        "Mod4+Shift+5" = "move container to workspace number 5";
        "Mod4+Shift+6" = "move container to workspace number 6";
        "Mod4+Shift+7" = "move container to workspace number 7";
        "Mod4+Shift+8" = "move container to workspace number 8";
        "Mod4+Shift+9" = "move container to workspace number 9";
        "Mod4+Shift+0" = "move container to workspace number 10";
        "XF86MonBrightnessUp" = "exec ~/.config/sway/scripts/brightness.sh -inc 2";
        "XF86MonBrightnessDown" = "exec ~/.config/sway/scripts/brightness.sh -dec 2";
        "XF86AudioRaiseVolume" = "exec ~/.config/sway/scripts/volume.sh -i 5";
        "XF86AudioLowerVolume" = "exec ~/.config/sway/scripts/volume.sh -d 5";
        "XF86AudioMute" = "exec ~/.config/sway/scripts/volume.sh -t";
        "Mod4+f" = "floating toggle";
        "Mod4+m" = "fullscreen toggle";
        "Mod4+h" = "split h";
        "Mod4+v" = "split v";
        "Mod4+r" = "mode resize";
        "Mod4+Shift+r" = "restart";
        "Mod4+Shift+q" = "exit";
      };
      modes = {
        resize = {
          Left = "resize shrink width";
          Right = "resize grow width";
          Down = "resize shrink height";
          Up = "resize grow height";
          Return = "mode default";
          Escape = "mode default";
        };
      };
      floating = {
        modifier = "Mod4";
        border = 4;
      };
      defaultWorkspace = "workspace number 1";
      output."*".background = "/home/sarvesh/Pictures/Wallpapers/default fill";
      window.border = 4;
    };
  };

  programs = {
    home-manager.enable = true;
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
    };
    fish = {
      enable = true;
      loginShellInit = ''
        if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
          exec sway
        end
      '';
      shellInit = ''
        set fish_greeting
        ~/.bin/fetch
      '';
      shellAliases = {
        nixupdate = "sudo nix-channel --update && sudo nixos-rebuild switch";
        homeupdate = "nix-channel --update && home-manager switch && nix-collect-garbage -d";
        allupdate = "nixupdate && homeupdate";
      };
    };
    git = {
      enable = true;
      userName = "sarveshrulz";
      userEmail = "sarveshkardekar@gmail.com";
    };
    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles."sarvesh" = {
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "layers.acceleration.force-enabled" = true;
          "gfx.webrender.all" = true;
          "svg.context-properties.content.enabled" = true;
        };
      };
    };
    foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=8";
          pad = "12x12";
        };
        colors = {
          background = "0a0a0a";
          foreground = "d0d0d0";
          regular0 = "0a0a0a";
          regular1 = "ac4142";
          regular2 = "90a959";
          regular3 = "f4bf75";
          regular4 = "6a9fb5";
          regular5 = "aa759f";
          regular6 = "75b5aa";
          regular7 = "d0d0d0";
          bright0 = "1a1a1a";
          bright1 = "ac4142";
          bright2 = "90a959";
          bright3 = "f4bf75";
          bright4 = "6a9fb5";
          bright5 = "aa759f";
          bright6 = "75b5aa";
          bright7 = "f5f5f5";
        };
      };
    };
  };
}
