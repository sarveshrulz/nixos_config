{ pkgs, ... }: {
  home-manager.users.sarvesh = {
    home = {
      packages = with pkgs; [
        librewolf-wayland
        tdesktop
        capitaine-cursors
        inkscape
        nixpkgs-fmt
        onlyoffice-bin
        mate.eom
        rofi-wayland
        xfce.thunar
      ];
      file.".ssh" = {
        recursive = true;
        source = ../../../../secrets/silver/sarvesh/ssh;
      };
      stateVersion = "22.11";
    };

    programs = {
      mpv = {
        enable = true;
        config = {
          profile = "gpu-hq";
          scale = "ewa_lanczossharp";
          cscale = "ewa_lanczossharp";
          video-sync = "display-resample";
          interpolation = true;
          tscale = "oversample";
        };
      };
      fish = {
        enable = true;
        loginShellInit = ''
          if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
            echo -e "Select session:\n[H] Hyprland\n[W] Waydroid\n[N] none\n"
            read -P "[H/w/n]: " c
            test -n $c; or set c "H"
            if test $c = "H" || test $c = "h"
              exec Hyprland
            else if test $c = "W" || test $c = "w"
              exec sh -c "(${pkgs.westonLite}/bin/weston; waydroid session stop) & WAYLAND_DISPLAY=wayland-1 waydroid show-full-ui"
            end
          end
        '';
        shellInit = ''
          set fish_greeting
          ${pkgs.pfetch}/bin/pfetch
        '';
        shellAliases = {
          bpytop = "${pkgs.bpytop}/bin/bpytop";
          editconf = "codium ~/.dotfiles";
          update-flake = "pushd ~/.dotfiles && nix flake update; popd";
          update-system = "pushd ~/.dotfiles && git add . && sudo nixos-rebuild switch --flake '.?submodules=1#'; popd";
          silver-oracle = "ssh sarvesh@140.238.255.129";
        };
      };
      git = {
        enable = true;
        userName = "sarveshrulz";
        userEmail = "sarveshkardekar@gmail.com";
        extraConfig.credential.helper = "rbw";
      };
      vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          foxundermoon.shell-format
        ];
      };
      foot = {
        enable = true;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font:weight=500:slant=italic:size=7";
            pad = "12x12";
          };
          colors = {
            background = "0a0a0a";
            foreground = "b0b0b0";
            regular0 = "0a0a0a";
            regular1 = "ac4142";
            regular2 = "90a959";
            regular3 = "f4bf75";
            regular4 = "6a9fb5";
            regular5 = "aa759f";
            regular6 = "75b5aa";
            regular7 = "b0b0b0";
            bright0 = "4a4a4a";
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
      waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
        settings = [{
          position = "top";
          margin = "12 12 0 12";
          modules-left = [ "wlr/workspaces" ];
          modules-center = [ "clock" "clock#time" ];
          modules-right = [ "network" "pulseaudio" "custom/bluetooth" "battery" "custom/power" ];
          "clock" = {
            format = "{:%a, %d %b %Y}";
            interval = 3600;
          };
          "clock#time" = {
            format = "{:%I:%M %p}";
            interval = 60;
          };
          "network" = {
            format = " ";
            on-click = "~/.config/rofi/scripts/rofi-wifi-menu";
            tooltip = false;
          };
          "pulseaudio" = {
            format = "{icon}";
            format-muted = "<span color=\"#4a4a4a\"> </span>";
            format-icons = [ " " " " " " ];
            on-click = "pamixer -t";
            tooltip = false;
          };
          "battery" = {
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-icons = [ "" "" "" "" "" ];
            tooltip = false;
          };
          "custom/power" = {
            format = "";
            on-click = "rofi -show power-menu -modi power-menu:~/.config/rofi/scripts/rofi-power-menu -theme ~/.config/rofi/powermenu.rasi";
            tooltip = false;
          };
          "custom/bluetooth" = {
            exec = "~/.config/rofi/scripts/rofi-bluetooth --status";
            interval = 1;
            on-click = "~/.config/rofi/scripts/rofi-bluetooth";
            tooltip = false;
          };
        }];
        style = ''
          #waybar {
            font-family: "NotoSans", "FontAwesome6Free";
            font-weight: bolder;
            background: transparent;
            color: #b0b0b0;
          }
          #workspaces {
            border-radius: 12px;
            padding: 4px;
          }
          #workspaces button {
            color: #b0b0b0;
            border-radius: inherit;
            font-weight: inherit;
            transition: none;
            padding: 0 4px;
          }
          #workspaces, #network, #pulseaudio, #battery, #clock, #custom-bluetooth {
            background: #0a0a0a;
          }
          #custom-power, #network, #pulseaudio, #battery, #clock, #clock.time, custom-bluetooth {
            padding: 0 8px;
          }
          #network, #clock {
            border-radius: 12px 0 0 12px;
          }
          #custom-power, #clock.time {
            border-radius: 0 12px 12px 0;
          }
          #clock.time {
            padding-left: 4px;
          }
          #workspaces button.active, #clock.time {
            background: #b0b0b0;
            color: #0a0a0a;
          }
          #network.disconnected {
            color: #4a4a4a;
          }
          #custom-power {
            background: #a54242;
            color: #0a0a0a;
          }
        '';
      };
      rbw = {
        enable = true;
        settings.email = "sarveshkardekar+bitwarden@gmail.com";
      };
    };

    services.dunst = {
      enable = true;
      settings = {
        global = {
          width = "(0, 360)";
          height = 136;
          offset = "12x12";
          frame_width = 0;
          padding = 8;
          font = "Noto Sans 10";
          max_icon_size = 14;
          corner_radius = 12;
          separator_height = 1;
          separator_color = "#4a4a4a";
        };
        urgency_low = {
          background = "#0a0a0a";
          foreground = "#b0b0b0";
          timeout = 3;
        };
        urgency_normal = {
          background = "#0a0a0a";
          foreground = "#b0b0b0";
          timeout = 5;
        };
        urgency_critical = {
          background = "#a54242";
          foreground = "#0a0a0a";
          timeout = 7;
        };
      };
    };

    systemd.user.services.mpris-proxy = {
      Unit.Description = "Mpris proxy";
      Unit.After = [ "network.target" "sound.target" ];
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Install.WantedBy = [ "default.target" ];
    };

    xdg.configFile =
      let
        rofi-theme = ''
          configuration {
          	font: "Noto Sans Semi-bold 11";
          	me-select-entry: "MouseSecondary";
          	me-accept-entry: "MousePrimary";
            hover-select: true;
            location: 3;
          }
          window {
            x-offset: -12px;
            y-offset: 12px;
            border-radius: 12px;
          }
          * {
            background: #0a0a0a;
            foreground: #b0b0b0;
          }
          entry {
            padding: 12px 12px 0px 12px;
          }
          prompt, textbox-prompt-colon, case-indicator {
            enabled: false;
          }
          mainbox, entry, listview, element {
            background-color: @background;
            text-color: @foreground;
          }
          listview {
            padding: 12px;
            spacing: 4px;
            cycle: false;
          }
          element-text selected {
            background-color: @foreground;
            text-color: @background;
            border-radius: 12px;
          }
          element-text {
            padding: 6px 12px;
            background-color: @background;
            text-color: @foreground;
          }
        '';
      in
      {
        "hypr/scripts/brightness.sh" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            msgId="69"
            xbacklight -fps 60 "$@"
            curr="$(xbacklight -get)"
            dunstify -a "changeBrightness" -i ~/.config/dunst/icons/brightness.png -u low -r "$msgId" "Brightness: $curr%"
          '';
        };
        "hypr/scripts/volume.sh" = {
          executable = true;
          text =
            let
              pamixer = "${pkgs.pamixer}/bin/pamixer";
            in
            ''
              #!/usr/bin/env bash
              msgId="69"
              ${pamixer} $@ > /dev/null
              if [ $(${pamixer} --get-mute) = true ] && [ ! $@ = '-t' ]; then
                   ${pamixer} -t
              fi
              volume=$(${pamixer} --get-volume)
              mute=$(${pamixer} --get-mute)
              if [ $volume = 0 ] || [ $mute = true ]; then
                  dunstify -a "changeVolume" -i ~/.config/dunst/icons/muted.png -u low -r "$msgId" "Volume: muted" 
              else
                  dunstify -a "changeVolume" -i ~/.config/dunst/icons/volume.png -u low -r "$msgId" "Volume: $volume%"
              fi
            '';
        };
        "hypr/hyprland.conf".text =
          let
            swaylock = "${pkgs.swaylock-effects}/bin/swaylock --clock --timestr '%l:%M %p' --datestr '%a, %d %b %Y' --indicator --indicator-radius 100 --indicator-thickness 12 --ring-color 0a0a0a --key-hl-color b0b0b0 --effect-blur 12x12";
          in
          ''
            input {
              sensitivity = 0.5
              touchpad {
                natural_scroll = true
              }
            }
            gestures {
              workspace_swipe = true
            }
            misc {
              disable_hyprland_logo = true
              disable_splash_rendering = true
              disable_autoreload = true
            }
            general {
              gaps_in = 6
              gaps_out = 12
              border_size = 0
            }
            decoration {
              rounding = 12
              blur = false
              drop_shadow = false
              dim_inactive = true
            }
            monitor = ,preffered,auto,1
            workspace = ,1
            windowrule = float,^(nm-connection-editor)$
            windowrulev2 = float,class:^(telegramdesktop)$,title:^(Media viewer)$
            bind = SUPER,RETURN,exec,footclient
            bind = SUPER,SPACE,exec,rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/apps.rasi
            bind = SUPER,Q,killactive,
            bind = SUPER,left,movefocus,l
            bind = SUPER,right,movefocus,r
            bind = SUPER,up,movefocus,u
            bind = SUPER,down,movefocus,d
            bind = SUPER_SHIFT,left,movewindow,l
            bind = SUPER_SHIFT,right,movewindow,r
            bind = SUPER_SHIFT,up,movewindow,u
            bind = SUPER_SHIFT,down,movewindow,d
            bind = SUPER,1,workspace,1
            bind = SUPER,2,workspace,2
            bind = SUPER,3,workspace,3
            bind = SUPER,4,workspace,4
            bind = SUPER,5,workspace,5
            bind = SUPER,6,workspace,6
            bind = SUPER,7,workspace,7
            bind = SUPER,8,workspace,8
            bind = SUPER,9,workspace,9
            bind = SUPER,0,workspace,10
            bind = SUPER_SHIFT,1,movetoworkspacesilent,1
            bind = SUPER_SHIFT,2,movetoworkspacesilent,2
            bind = SUPER_SHIFT,3,movetoworkspacesilent,3
            bind = SUPER_SHIFT,4,movetoworkspacesilent,4
            bind = SUPER_SHIFT,5,movetoworkspacesilent,5
            bind = SUPER_SHIFT,6,movetoworkspacesilent,6
            bind = SUPER_SHIFT,7,movetoworkspacesilent,7
            bind = SUPER_SHIFT,8,movetoworkspacesilent,8
            bind = SUPER_SHIFT,9,movetoworkspacesilent,9
            bind = SUPER_SHIFT,0,movetoworkspacesilent,10
            binde = SUPER_CTRL,right,resizeactive,10 0
            binde = SUPER_CTRL,left,resizeactive,-10 0
            binde = SUPER_CTRL,up,resizeactive,0 -10
            binde = SUPER_CTRL,down,resizeactive,0 10
            bind = SUPER_SHIFT,Q,exit,
            bind = SUPER,F,togglefloating,
            bind = SUPER,M,fullscreen,
            bind = SUPER,PRINT,exec,${pkgs.hyprwm-contrib-packages.grimblast}/bin/grimblast --notify copysave area ~/Pictures/Screenshots/$(date +'%s_screenshot.png')
            bind = SUPER,L,exec,${swaylock} --screenshots --effect-scale 0.3
            bind = ,XF86MonBrightnessUp,exec,~/.config/hypr/scripts/brightness.sh -inc 2
            bind = ,XF86MonBrightnessDown,exec,~/.config/hypr/scripts/brightness.sh -dec 2
            bind = ,XF86AudioMute,exec,~/.config/hypr/scripts/volume.sh -t
            bind = ,XF86AudioRaiseVolume,exec,~/.config/hypr/scripts/volume.sh -i 5
            bind = ,XF86AudioLowerVolume,exec,~/.config/hypr/scripts/volume.sh -d 5
            bindl = ,switch:Lid Switch,exec,${swaylock} --image ~/Pictures/Wallpapers/default --effect-scale 0.1
            bindm = SUPER,mouse:272,movewindow
            bindm = SUPER,mouse:273,resizewindow
            exec-once = dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP
            exec-once = ${pkgs.gammastep}/bin/gammastep -l 19:72
            exec-once = ${pkgs.swaybg}/bin/swaybg -o \* -i ~/Pictures/Wallpapers/default -m fill
            exec-once = TERM='xterm-256color' waybar
            exec-once = foot -s
            exec-once = dunst
            exec-once = thunar --daemon
            exec-once = ${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store
            exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
          '';
        "rofi/apps.rasi".text = ''
          ${rofi-theme}
          configuration {
            drun-display-format: "{name}";
            hover-select: false;
            location: 0;
          }
          listview {
            lines: 4;
          }
          window {
            width: 205px;
            x-offset: 0;
            y-offset: 0;
          }
        '';
        "rofi/bluetooth.rasi".text = ''
          ${rofi-theme}
          window {
            width: 175px;
          }
          listview{
            lines: 6;
          }
          entry {
            enabled: false;
          }
        '';
        "rofi/powermenu.rasi".text = ''
          ${rofi-theme}
          window {
            width: 132px;
          }
          entry {
            enabled: false;
          }
          listview {
            lines: 3;
          }
        '';
        "rofi/wlan.rasi".text = ''
          ${rofi-theme}
          configuration {
            font: "Noto Sans Mono Semi-bold 11";
          }
        '';
        "rofi/scripts/rofi-bluetooth" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            # source: https://github.com/nickclyde/rofi-bluetooth
            divider="---------"
            goback="Back"
            power_on() {
            	if bluetoothctl show | grep -q "Powered: yes"; then
            		return 0
            	else
            		return 1
            	fi
            }
            toggle_power() {
            	if power_on; then
            		bluetoothctl power off
            		show_menu
            	else
            		if rfkill list bluetooth | grep -q 'blocked: yes'; then
            			rfkill unblock bluetooth && sleep 3
            		fi
            		bluetoothctl power on
            		show_menu
            	fi
            }
            scan_on() {
            	if bluetoothctl show | grep -q "Discovering: yes"; then
            		echo "Scan: on"
            		return 0
            	else
            		echo "Scan: off"
            		return 1
            	fi
            }
            toggle_scan() {
            	if scan_on; then
            		kill $(pgrep -f "bluetoothctl scan on")
            		bluetoothctl scan off
            		show_menu
            	else
            		bluetoothctl scan on &
            		echo "Scanning..."
            		sleep 5
            		show_menu
            	fi
            }
            pairable_on() {
            	if bluetoothctl show | grep -q "Pairable: yes"; then
            		echo "Pairable: on"
            		return 0
            	else
            		echo "Pairable: off"
            		return 1
            	fi
            }
            toggle_pairable() {
            	if pairable_on; then
            		bluetoothctl pairable off
            		show_menu
            	else
            		bluetoothctl pairable on
            		show_menu
            	fi
            }
            discoverable_on() {
            	if bluetoothctl show | grep -q "Discoverable: yes"; then
            		echo "Discoverable: on"
            		return 0
            	else
            		echo "Discoverable: off"
            		return 1
            	fi
            }
            toggle_discoverable() {
            	if discoverable_on; then
            		bluetoothctl discoverable off
            		show_menu
            	else
            		bluetoothctl discoverable on
            		show_menu
            	fi
            }
            device_connected() {
            	device_info=$(bluetoothctl info "$1")
            	if echo "$device_info" | grep -q "Connected: yes"; then
            		return 0
            	else
            		return 1
            	fi
            }
            toggle_connection() {
            	if device_connected $1; then
            		bluetoothctl disconnect $1
            		device_menu "$device"
            	else
            		bluetoothctl connect $1
            		device_menu "$device"
            	fi
            }
            device_paired() {
            	device_info=$(bluetoothctl info "$1")
            	if echo "$device_info" | grep -q "Paired: yes"; then
            		echo "Paired: yes"
            		return 0
            	else
            		echo "Paired: no"
            		return 1
            	fi
            }
            toggle_paired() {
            	if device_paired $1; then
            		bluetoothctl remove $1
            		device_menu "$device"
            	else
            		bluetoothctl pair $1
            		device_menu "$device"
            	fi
            }
            device_trusted() {
            	device_info=$(bluetoothctl info "$1")
            	if echo "$device_info" | grep -q "Trusted: yes"; then
            		echo "Trusted: yes"
            		return 0
            	else
            		echo "Trusted: no"
            		return 1
            	fi
            }
            toggle_trust() {
            	if device_trusted $1; then
            		bluetoothctl untrust $1
            		device_menu "$device"
            	else
            		bluetoothctl trust $1
            		device_menu "$device"
            	fi
            }
            print_status() {
            	if power_on; then
            		mapfile -t paired_devices < <(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
            		counter=0
            		for device in $(eval "echo "$\{paired_devices[@]}""); do
            			if device_connected $device; then
            				((counter++))
            			fi
            		done
            		if ! [[ $counter = 0 ]]; then
            			printf "%d %s" "$counter" " "
            		else
            			printf ' '
            		fi
            	else
            		echo "<span color=\"#4a4a4a\"> </span>"
            	fi
            }
            device_menu() {
            	device=$1
            	device_name=$(echo $device | cut -d ' ' -f 3-)
            	mac=$(echo $device | cut -d ' ' -f 2)
            	if device_connected $mac; then
            		connected="Connected: yes"
            	else
            		connected="Connected: no"
            	fi
            	paired=$(device_paired $mac)
            	trusted=$(device_trusted $mac)
            	options="$connected\n$paired\n$trusted\n$divider\n$goback\nExit"
            	chosen="$(echo -e "$options" | $rofi_command "$device_name")"
            	case $chosen in
            	"" | $divider)
            		echo "No option chosen."
            		;;
            	$connected)
            		toggle_connection $mac
            		;;
            	$paired)
            		toggle_paired $mac
            		;;
            	$trusted)
            		toggle_trust $mac
            		;;
            	$goback)
            		show_menu
            		;;
            	esac
            }
            show_menu() {
            	if power_on; then
            		power="Power: on"
            		devices=$(bluetoothctl devices | grep Device | cut -d ' ' -f 3-)
            		scan=$(scan_on)
            		pairable=$(pairable_on)
            		discoverable=$(discoverable_on)
            		options="$devices\n$divider\n$power\n$scan\n$pairable\n$discoverable\nExit"
            	else
            		power="Power: off"
            		options="$power\nExit"
            	fi
            	chosen="$(echo -e "$options" | $rofi_command "Bluetooth")"
            	case $chosen in
            	"" | $divider)
            		echo "No option chosen."
            		;;
            	$power)
            		toggle_power
            		;;
            	$scan)
            		toggle_scan
            		;;
            	$discoverable)
            		toggle_discoverable
            		;;
            	$pairable)
            		toggle_pairable
            		;;
            	*)
            		device=$(bluetoothctl devices | grep "$chosen")
            		if [[ $device ]]; then device_menu "$device"; fi
            		;;
            	esac
            }
            rofi_command="rofi -theme ~/.config/rofi/bluetooth.rasi -dmenu"
            case "$1" in
            --status)
            	print_status
            	;;
            *)
            	show_menu
            	;;
            esac
          '';
        };
        "rofi/scripts/rofi-power-menu" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            # Source: https://github.com/jluttine/rofi-power-menu
            set -e
            set -u
            all=(shutdown reboot suspend)
            show=("$(eval "echo "$\{all[@]}"")")
            declare -A texts
            texts[suspend]="suspend"
            texts[reboot]="reboot"
            texts[shutdown]="shut down"
            declare -A icons
            icons[suspend]=""
            icons[reboot]=""
            icons[shutdown]=""
            icons[cancel]=""
            declare -A actions
            actions[suspend]="systemctl suspend"
            actions[reboot]="systemctl reboot"
            actions[shutdown]="systemctl poweroff"
            confirmations=(reboot shutdown suspend)
            dryrun=false
            showsymbols=true
            function check_valid() {
                option="$1"
                shift 1
                for entry in $(eval "echo "$\{@}""); do
                    if [ -z "$(eval "echo "$\{actions[$entry]+x}"")" ]; then
                        echo "Invalid choice in $1: $entry" >&2
                        exit 1
                    fi
                done
            }
            parsed=$(getopt --options=h --longoptions=help,dry-run,confirm:,choices:,choose:,symbols,no-symbols --name "$0" -- "$@")
            if [ $? -ne 0 ]; then
                echo 'Terminating...' >&2
                exit 1
            fi
            eval set -- "$parsed"
            unset parsed
            while true; do
                case "$1" in
                "-h" | "--help")
                    echo "rofi-power-menu - a power menu mode for Rofi"
                    echo
                    echo "Usage: rofi-power-menu [--choices CHOICES] [--confirm CHOICES]"
                    echo "                       [--choose CHOICE] [--dry-run] [--symbols|--no-symbols]"
                    echo
                    echo "Use with Rofi in script mode. For instance, to ask for shutdown or reboot:"
                    echo
                    echo "  rofi -show menu -modi \"menu:rofi-power-menu --choices=shutdown/reboot\""
                    echo
                    echo "Available options:"
                    echo "  --dry-run          Don't perform the selected action but print it to stderr."
                    echo "  --choices CHOICES  Show only the selected choices in the given order. Use / "
                    echo "                     as the separator. Available choices are lockscreen, logout,"
                    echo "                     suspend, hibernate, reboot and shutdown. By default, all"
                    echo "                     available choices are shown."
                    echo "  --confirm CHOICES  Require confirmation for the gives choices only. Use / as"
                    echo "                     the separator. Available choices are lockscreen, logout,"
                    echo "                     suspend, hibernate, reboot and shutdown. By default, only"
                    echo "                     irreversible actions logout, reboot and shutdown require"
                    echo "                     confirmation."
                    echo "  --choose CHOICE    Preselect the given choice and only ask for a confirmation"
                    echo "                     (if confirmation is set to be requested). It is strongly"
                    echo "                     recommended to combine this option with --confirm=CHOICE"
                    echo "                     if the choice wouldn't require confirmation by default."
                    echo "                     Available choices are lockscreen, logout, suspend,"
                    echo "                     hibernate, reboot and shutdown."
                    echo "  --[no-]symbols     Show Unicode symbols or not. Requires a font with support"
                    echo "                     for the symbols. Use, for instance, fonts from the"
                    echo "                     Nerdfonts collection. By default, they are shown"
                    echo "  -h,--help          Show this help text."
                    exit 0
                    ;;
                "--dry-run")
                    dryrun=true
                    shift 1
                    ;;
                "--confirm")
                    IFS='/' read -ra confirmations <<<"$2"
                    check_valid "$1" "$(eval "echo "$\{confirmations[@]}"")"
                    shift 2
                    ;;
                "--choices")
                    IFS='/' read -ra show <<<"$2"
                    check_valid "$1" "$(eval "echo "$\{show[@]}"")"
                    shift 2
                    ;;
                "--choose")
                    check_valid "$1" "$2"
                    selectionID="$2"
                    shift 2
                    ;;
                "--symbols")
                    showsymbols=true
                    shift 1
                    ;;
                "--no-symbols")
                    showsymbols=false
                    shift 1
                    ;;
                "--")
                    shift
                    break
                    ;;
                *)
                    echo "Internal error" >&2
                    exit 1
                    ;;
                esac
            done
            function write_message() {
                icon="<span font_size=\"medium\">$1</span>"
                text="<span font_size=\"medium\">$2</span>"
                if [ "$showsymbols" = "true" ]; then
                    echo -n "\u200e$icon \u2068$text\u2069"
                else
                    echo -n "$text"
                fi
            }
            function print_selection() {
                echo -e "$1" | $(
                    read -r -d '\' entry
                    echo "echo $entry"
                )
            }
            declare -A messages
            declare -A confirmationMessages
            for entry in $(eval "echo "$\{all[@]}""); do
                messages[$entry]=$(write_message "$(eval "echo "$\{icons[$entry]}"")" "$(eval "echo "$\{texts[$entry]^}"")")
            done
            for entry in $(eval "echo "$\{all[@]}""); do
                confirmationMessages[$entry]=$(write_message "$(eval "echo "$\{icons[$entry]}"")" "Yes, $(eval "echo "$\{texts[$entry]}"")")
            done
            confirmationMessages[cancel]=$(write_message "$(eval "echo "$\{icons[cancel]}"")" "No, cancel")
            if [ $# -gt 0 ]; then
                selection="$(eval "echo "$\{@}"")"
            else
                if [ -n "$(eval "echo "$\{selectionID+x}"")" ]; then
                    selection="$(eval "echo "$\{messages[$selectionID]}"")"
                fi
            fi
            echo -e "\0no-custom\x1ftrue"
            echo -e "\0markup-rows\x1ftrue"
            if [ -z "$(eval "echo "$\{selection+x}"")" ]; then
                echo -e "\0prompt\x1fPower menu"
                for entry in $(eval "echo "$\{show[@]}""); do
                    echo -e "$(eval "echo "$\{messages[$entry]}"")\0icon\x1f$(eval "echo "$\{icons[$entry]}"")"
                done
            else
                for entry in $(eval "echo "$\{show[@]}""); do
                    if [ "$selection" = "$(print_selection "$(eval "echo "$\{messages[$entry]}"")")" ]; then
                        for confirmation in $(eval "echo "$\{confirmations[@]}""); do
                            if [ "$entry" = "$confirmation" ]; then
                                echo -e "\0prompt\x1fAre you sure"
                                echo -e "$(eval "echo "$\{confirmationMessages[$entry]}"")\0icon\x1f$(eval "echo "$\{icons[$entry]}"")"
                                echo -e "$(eval "echo "$\{confirmationMessages[cancel]}"")\0icon\x1f$(eval "echo "$\{icons[cancel]}"")"
                                exit 0
                            fi
                        done
                        selection=$(print_selection "$(eval "echo "$\{confirmationMessages[$entry]}"")")
                    fi
                    if [ "$selection" = "$(print_selection "$(eval "echo "$\{confirmationMessages[$entry]}"")")" ]; then
                        if [ $dryrun = true ]; then
                            echo "Selected: $entry" >&2
                        else
                            $(eval "echo "$\{actions[$entry]}"")
                        fi
                        exit 0
                    fi
                    if [ "$selection" = "$(print_selection "$(eval "echo "$\{confirmationMessages[cancel]}"")")" ]; then
                        exit 0
                    fi
                done
                echo "Invalid selection: $selection" >&2
                exit 1
            fi
          '';
        };
        "rofi/scripts/rofi-wifi-menu" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            # Source: https://github.com/P3rf/rofi-network-manager
            WIDTH_FIX_STATUS=10
            PASSWORD_ENTER="if connection is stored, hit enter/esc."
            WIRELESS_INTERFACES=($(nmcli device | awk '$2=="wifi" {print $1}'))
            WIRELESS_INTERFACES_PRODUCT=()
            WLAN_INT=0
            WIRED_INTERFACES=($(nmcli device | awk '$2=="ethernet" {print $1}'))
            WIRED_INTERFACES_PRODUCT=()
            RASI_DIR="~/.config/rofi/wlan.rasi"
            function initialization() {
            	for i in $(eval "echo "$\{WIRELESS_INTERFACES[@]}""); do WIRELESS_INTERFACES_PRODUCT+=("$(nmcli -f general.product device show "$i" | awk '{print $2}')"); done
            	for i in $(eval "echo "$\{WIRED_INTERFACES[@]}""); do WIRED_INTERFACES_PRODUCT+=("$(nmcli -f general.product device show "$i" | awk '{print $2}')"); done
            	wireless_interface_state && ethernet_interface_state
            }
            function notification() {
            	dunstify -r "5" -u "normal" $1 "$2"
            }
            function wireless_interface_state() {
            	ACTIVE_SSID=$(nmcli device status | grep "^$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")." | awk '{print $4}')
            	WIFI_CON_STATE=$(nmcli device status | grep "^$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")." | awk '{print $3}')
            	{ [[ "$WIFI_CON_STATE" == "unavailable" ]] && WIFI_LIST="***Wi-Fi Disabled***" && WIFI_SWITCH="~Wi-Fi On" && OPTIONS="$WIFI_LIST\n$WIFI_SWITCH\n~Scan"; } || { [[ "$WIFI_CON_STATE" =~ "connected" ]] && {
            		PROMPT="$(eval "echo "$\{WIRELESS_INTERFACES_PRODUCT[WLAN_INT]}"")[$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")]"
            		WIFI_LIST=$(nmcli --fields IN-USE,SSID,SECURITY,BARS device wifi list ifname "$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")" | awk -F'  +' '{ if (!seen[$2]++) print}' | sed "s/^IN-USE\s//g" | sed "/*/d" | sed "s/^ *//" | awk '$1!="--" {print}')
            		[[ "$ACTIVE_SSID" == "--" ]] && WIFI_SWITCH="~Scan\n~Manual/Hidden\n~Wi-Fi Off" || WIFI_SWITCH="~Scan\n~Disconnect\n~Manual/Hidden\n~Wi-Fi Off"
            		OPTIONS="$WIFI_LIST\n$WIFI_SWITCH"
            	}; }
            }
            function ethernet_interface_state() {
            	WIRED_CON_STATE=$(nmcli device status | grep "ethernet" | head -1 | awk '{print $3}')
            	{ [[ "$WIRED_CON_STATE" == "disconnected" ]] && WIRED_SWITCH="~Eth On"; } || { [[ "$WIRED_CON_STATE" == "connected" ]] && WIRED_SWITCH="~Eth Off"; } || { [[ "$WIRED_CON_STATE" == "unavailable" ]] && WIRED_SWITCH="***Wired Unavailable***"; } || { [[ "$WIRED_CON_STATE" == "connecting" ]] && WIRED_SWITCH="***Wired Initializing***"; }
            	OPTIONS="$OPTIONS\n$WIRED_SWITCH"
            }
            function rofi_menu() {
            	{ [[ $(eval "echo "$\{\#WIRELESS_INTERFACES[@]}"") -ne "1" ]] && OPTIONS="$OPTIONS\n~Change Wifi Interface\n~More Options"; } || { OPTIONS="$OPTIONS\n~More Options"; }
            	{ [[ "$WIRED_CON_STATE" == "connected" ]] && PROMPT="$WIRED_INTERFACES_PRODUCT[$WIRED_INTERFACES]"; } || PROMPT="$(eval "echo "$\{WIRELESS_INTERFACES_PRODUCT[WLAN_INT]}"")[$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")]"
            	SELECTION=$(echo -e "$OPTIONS" | rofi_cmd "$OPTIONS" 1 "-a 0")
            	SSID=$(echo "$SELECTION" | sed "s/\s\{2,\}/\|/g" | awk -F "|" '{print $1}')
            	selection_action
            }
            function dimensions() {
            	{ [[ "$1" != "" ]] && WIDTH=$(echo -e "$1" | awk '{print length}' | sort -n | tail -1) && ((WIDTH += $2)) && LINES=$(echo -e "$1" | wc -l); } || { WIDTH=$2 && LINES=0; }
            }
            function rofi_cmd() {
            	dimensions "$1" $2
            	rofi -dmenu -i $3 \
            		-theme "$RASI_DIR" -theme-str '
            		window{width: '"$((WIDTH / 2))"'em;}
            		listview{lines: '"$LINES"';}
            		textbox-prompt-colon{str:"'"$PROMPT"':";}
            		'"$4"""
            }
            function change_wireless_interface() {
            	{ [[ $(eval "echo "$\{\#WIRELESS_INTERFACES[@]}"") -eq "2" ]] && { [[ $WLAN_INT -eq "0" ]] && WLAN_INT=1 || WLAN_INT=0; }; } || {
            		LIST_WLAN_INT=""
            		for i in $(eval "echo "$\{\!WIRELESS_INTERFACES[@]}""); do LIST_WLAN_INT=("$(eval "echo "$\{LIST_WLAN_INT[@]}"")$(eval "echo "$\{WIRELESS_INTERFACES_PRODUCT[\$i]}"")[$(eval "echo "$\{WIRELESS_INTERFACES[\$i]}"")]\n"); done
            		LIST_WLAN_INT[-1]="$(eval "echo "$\{LIST_WLAN_INT[-1]::-2}"")"
            		CHANGE_WLAN_INT=$(echo -e "$(eval "echo "$\{LIST_WLAN_INT[@]}"")" | rofi_cmd "$(eval "echo "$\{LIST_WLAN_INT[@]}"")" $WIDTH_FIX_STATUS)
            		for i in $(eval "echo "$\{\!WIRELESS_INTERFACES[@]}""); do [[ $CHANGE_WLAN_INT == "$(eval "echo "$\{WIRELESS_INTERFACES_PRODUCT[\$i]}"")[$(eval "echo "$\{WIRELESS_INTERFACES[\$i]}"")]" ]] && WLAN_INT=$i && break; done
            	}
            	wireless_interface_state && ethernet_interface_state
            	rofi_menu
            }
            function scan() {
            	[[ "$WIFI_CON_STATE" =~ "unavailable" ]] && change_wifi_state "Wi-Fi" "Enabling Wi-Fi connection" "on" && sleep 2
            	notification "-t 0 Wifi" "Please Wait, Scanning..."
            	WIFI_LIST=$(nmcli --fields IN-USE,SSID,SECURITY,BARS device wifi list ifname "$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")" --rescan yes | awk -F'  +' '{ if (!seen[$2]++) print}' | sed "s/^IN-USE\s//g" | sed "/*/d" | sed "s/^ *//" | awk '$1!="--" {print}')
            	wireless_interface_state && ethernet_interface_state
            	notification "-t 1 Wifi" "Please Wait, Scanning..."
            	rofi_menu
            }
            function change_wifi_state() {
            	notification "$1" "$2"
            	nmcli radio wifi "$3"
            }
            function change_wired_state() {
            	notification "$1" "$2"
            	nmcli device "$3" "$4"
            }
            function net_restart() {
            	notification "$1" "$2"
            	nmcli networking off && sleep 3 && nmcli networking on
            }
            function disconnect() {
            	ACTIVE_SSID=$(nmcli -t -f GENERAL.CONNECTION dev show "$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")" | cut -d ':' -f2)
            	notification "$1" "You're now disconnected from Wi-Fi network '$ACTIVE_SSID'"
            	nmcli con down id "$ACTIVE_SSID"
            }
            function check_wifi_connected() {
            	[[ "$(nmcli device status | grep "^$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")." | awk '{print $3}')" == "connected" ]] && disconnect "Connection_Terminated"
            }
            function connect() {
            	check_wifi_connected
            	notification "-t 0 Wi-Fi" "Connecting to $1"
            	{ [[ $(nmcli dev wifi con "$1" password "$2" ifname "$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")" | grep -c "successfully activated") -eq "1" ]] && notification "Connection_Established" "You're now connected to Wi-Fi network '$1'"; } || notification "Connection_Error" "Connection can not be established"
            }
            function enter_passwword() {
            	PROMPT="Enter_Password" && PASS=$(echo "$PASSWORD_ENTER" | rofi_cmd "$PASSWORD_ENTER" 4 "-password")
            }
            function enter_ssid() {
            	PROMPT="Enter_SSID" && SSID=$(rofi_cmd "" 40)
            }
            function stored_connection() {
            	check_wifi_connected
            	notification "-t 0 Wi-Fi" "Connecting to $1"
            	{ [[ $(nmcli dev wifi con "$1" ifname "$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")" | grep -c "successfully activated") -eq "1" ]] && notification "Connection_Established" "You're now connected to Wi-Fi network '$1'"; } || notification "Connection_Error" "Connection can not be established"
            }
            function ssid_manual() {
            	enter_ssid
            	[[ -n $SSID ]] && {
            		enter_passwword
            		{ [[ -n "$PASS" ]] && [[ "$PASS" != "$PASSWORD_ENTER" ]] && connect "$SSID" "$PASS"; } || stored_connection "$SSID"
            	}
            }
            function ssid_hidden() {
            	enter_ssid
            	[[ -n $SSID ]] && {
            		enter_passwword && check_wifi_connected
            		[[ -n "$PASS" ]] && [[ "$PASS" != "$PASSWORD_ENTER" ]] && {
            			nmcli con add type wifi con-name "$SSID" ssid "$SSID" ifname "$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")"
            			nmcli con modify "$SSID" wifi-sec.key-mgmt wpa-psk
            			nmcli con modify "$SSID" wifi-sec.psk "$PASS"
            		} || [[ $(nmcli -g NAME con show | grep -c "$SSID") -eq "0" ]] && nmcli con add type wifi con-name "$SSID" ssid "$SSID" ifname "$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")"
            		notification "-t 0 Wifi" "Connecting to $SSID"
            		{ [[ $(nmcli con up id "$SSID" | grep -c "successfully activated") -eq "1" ]] && notification "Connection_Established" "You're now connected to Wi-Fi network '$SSID'"; } || notification "Connection_Error" "Connection can not be established"
            	}
            }
            function interface_status() {
            	local -n INTERFACES=$1 && local -n INTERFACES_PRODUCT=$2
            	for i in $(eval "echo "$\{\!INTERFACES[@]}""); do
            		CON_STATE=$(nmcli device status | grep "^$(eval "echo "$\{INTERFACES[\$i]}"")." | awk '{print $3}')
            		INT_NAME=$(eval "echo "$\{INTERFACES_PRODUCT[\$i]}"")[$(eval "echo "$\{INTERFACES[\$i]}"")]
            		[[ "$CON_STATE" == "connected" ]] && STATUS="$INT_NAME:\n\t$(nmcli -t -f GENERAL.CONNECTION dev show "$(eval "echo "$\{INTERFACES[\$i]}"")" | awk -F '[:]' '{print $2}') ~ $(nmcli -t -f IP4.ADDRESS dev show "$(eval "echo "$\{INTERFACES[\$i]}"")" | awk -F '[:/]' '{print $2}')" || STATUS="$INT_NAME: $(eval "echo "$\{CON_STATE^}"")"
            		echo -e "$STATUS"
            	done
            }
            function status() {
            	WLAN_STATUS="$(interface_status WIRELESS_INTERFACES WIRELESS_INTERFACES_PRODUCT)"
            	ETH_STATUS="$(interface_status WIRED_INTERFACES WIRED_INTERFACES_PRODUCT)"
            	OPTIONS="$ETH_STATUS\n$WLAN_STATUS"
            	ACTIVE_VPN=$(nmcli -g NAME,TYPE con show --active | awk '/:vpn/' | sed 's/:vpn.*//g')
            	[[ -n $ACTIVE_VPN ]] && OPTIONS="$OPTIONS\n$ACTIVE_VPN[VPN]: $(nmcli -g ip4.address con show "$ACTIVE_VPN" | awk -F '[:/]' '{print $1}')"
            	echo -e "$OPTIONS" | rofi_cmd "$OPTIONS" $WIDTH_FIX_STATUS "" "mainbox {children:[listview];}"
            }
            function share_pass() {
            	SSID=$(nmcli dev wifi show-password | grep -oP '(?<=SSID: ).*' | head -1)
            	PASSWORD=$(nmcli dev wifi show-password | grep -oP '(?<=Password: ).*' | head -1)
            	OPTIONS="SSID: $SSID\nPassword: $PASSWORD"
            	SELECTION=$(echo -e "$OPTIONS" | rofi_cmd "$OPTIONS" $WIDTH_FIX_STATUS "-a "$((LINES - 1))"" "mainbox {children:[listview];}")
            	selection_action
            }
            function manual_hidden() {
            	OPTIONS="~Manual\n~Hidden" && SELECTION=$(echo -e "$OPTIONS" | rofi_cmd "$OPTIONS" $WIDTH_FIX_STATUS "" "mainbox {children:[listview];}")
            	selection_action
            }
            function vpn() {
            	ACTIVE_VPN=$(nmcli -g NAME,TYPE con show --active | awk '/:vpn/' | sed 's/:vpn.*//g')
            	[[ $ACTIVE_VPN ]] && OPTIONS="~Deactive $ACTIVE_VPN" || OPTIONS="$(nmcli -g NAME,TYPE connection | awk '/:vpn/' | sed 's/:vpn.*//g')"
            	VPN_ACTION=$(echo -e "$OPTIONS" | rofi_cmd "$OPTIONS" "$WIDTH_FIX_STATUS" "" "mainbox {children:[listview];}")
            	[[ -n "$VPN_ACTION" ]] && { { [[ "$VPN_ACTION" =~ "~Deactive" ]] && nmcli connection down "$ACTIVE_VPN" && notification "VPN_Deactivated" "$ACTIVE_VPN"; } || {
            		notification "-t 0 Activating_VPN" "$VPN_ACTION" && VPN_OUTPUT=$(nmcli connection up "$VPN_ACTION" 2>/dev/null)
            		{ [[ $(echo "$VPN_OUTPUT" | grep -c "Connection successfully activated") -eq "1" ]] && notification "VPN_Successfully_Activated" "$VPN_ACTION"; } || notification "Error_Activating_VPN" "Check your configuration for $VPN_ACTION"
            	}; }
            }
            function more_options() {
            	OPTIONS=""
            	[[ "$WIFI_CON_STATE" == "connected" ]] && OPTIONS="~Share Wifi Password\n"
            	OPTIONS="$OPTIONS~Status\n~Restart Network"
            	[[ $(nmcli -g NAME,TYPE connection | awk '/:vpn/' | sed 's/:vpn.*//g') ]] && OPTIONS="$OPTIONS\n~VPN"
            	OPTIONS="$OPTIONS\n~Open Connection Editor"
            	SELECTION=$(echo -e "$OPTIONS" | rofi_cmd "$OPTIONS" "$WIDTH_FIX_STATUS" "" "mainbox {children:[listview];}")
            	selection_action
            }
            function selection_action() {
            	case "$SELECTION" in
            	"~Disconnect") disconnect "Connection_Terminated" ;;
            	"~Scan") scan ;;
            	"~Status") status ;;
            	"~Share Wifi Password") share_pass ;;
            	"~Manual/Hidden") manual_hidden ;;
            	"~Manual") ssid_manual ;;
            	"~Hidden") ssid_hidden ;;
            	"~Wi-Fi On") change_wifi_state "Wi-Fi" "Enabling Wi-Fi connection" "on" ;;
            	"~Wi-Fi Off") change_wifi_state "Wi-Fi" "Disabling Wi-Fi connection" "off" ;;
            	"~Eth Off") change_wired_state "Ethernet" "Disabling Wired connection" "disconnect" "$WIRED_INTERFACES" ;;
            	"~Eth On") change_wired_state "Ethernet" "Enabling Wired connection" "connect" "$WIRED_INTERFACES" ;;
            	"***Wi-Fi Disabled***") ;;
            	"***Wired Unavailable***") ;;
            	"***Wired Initializing***") ;;
            	"~Change Wifi Interface") change_wireless_interface ;;
            	"~Restart Network") net_restart "Network" "Restarting Network" ;;
            	"~More Options") more_options ;;
            	"~Open Connection Editor") ${pkgs.networkmanagerapplet}/bin/nm-connection-editor ;;
            	"~VPN") vpn ;;
            	*)
            		[[ -n "$SELECTION" ]] && [[ "$WIFI_LIST" =~ .*"$SELECTION".* ]] && {
            			[[ "$SSID" == "*" ]] && SSID=$(echo "$SELECTION" | sed "s/\s\{2,\}/\|/g " | awk -F "|" '{print $3}')
            			{ [[ "$ACTIVE_SSID" == "$SSID" ]] && nmcli con up "$SSID" ifname "$(eval "echo "$\{WIRELESS_INTERFACES[WLAN_INT]}"")"; } || {
            				[[ "$SELECTION" =~ "WPA2" ]] || [[ "$SELECTION" =~ "WEP" ]] && enter_passwword
            				{ [[ -n "$PASS" ]] && [[ "$PASS" != "$PASSWORD_ENTER" ]] && connect "$SSID" "$PASS"; } || stored_connection "$SSID"
            			}
            		}
            		;;
            	esac
            }
            function main() {
            	initialization && rofi_menu
            }
            main
          '';
        };
        "weston.ini".text = ''
          [libinput]
          enable-tap=true
          natural-scroll=true
          [shell]
          panel-position=none
          background-image=/home/sarvesh/.config/weston/background.jpg
        '';
        "weston/background.jpg".source = ./files/config/weston/background.jpg;
        "dunst/icons/brightness.png".source = ./files/config/dunst/icons/brightness.png;
        "dunst/icons/muted.png".source = ./files/config/dunst/icons/muted.png;
        "dunst/icons/volume.png".source = ./files/config/dunst/icons/volume.png;
      };

    manual.manpages.enable = false;

    gtk =
      let
        gtkconf = {
          gtk-application-prefer-dark-theme = 1;
          gtk-cursor-theme-name = "capitaine-cursors-white";
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
          gtk-xft-rgba = "rgb";
        };
      in
      {
        enable = true;
        font = {
          name = "Noto Sans";
          size = 11;
        };
        theme = {
          package = pkgs.materia-theme;
          name = "Materia-dark-compact";
        };
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-blue-dark";
        };
        gtk4.extraConfig = gtkconf;
        gtk3.extraConfig = gtkconf;
        gtk2.extraConfig = ''
          gtk-application-prefer-dark-theme=1
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
          gtk-cursor-theme-name="capitaine-cursors-white"
        '';
      };
  };

  networking.wg-quick.interfaces.protonvpn = {
    autostart = true;
    address = [ "10.2.0.2/32" ];
    dns = [ "10.2.0.1" ];
    privateKeyFile = "${../../../../secrets/silver/sarvesh/protonvpnPrivateKey}";
    peers = [{
      publicKey = "6viKMPw7x82HUJJbPTA08M3oY9U0SRDxpktohKENJTk=";
      allowedIPs = [ "0.0.0.0/0" ];
      endpoint = "37.19.200.22:51820";
    }];
  };

  services.getty = {
    loginOptions = "-p -- sarvesh";
    extraArgs = [ "--noclear" "--skip-login" ];
    greetingLine = "Welcome to silver! please enter password for sarvesh to login...";
  };

  security.pam.enableEcryptfs = true;

  users.users = {
    sarvesh = {
      description = "Sarvesh Kardekar";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "networkmanager" ];
      shell = pkgs.fish;
      passwordFile = "${../../../../secrets/silver/sarvesh/sarveshPassword}";
    };
  };
}
