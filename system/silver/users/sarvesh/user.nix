{ pkgs, ... }: {
  home-manager.users.sarvesh = {
    home = {
      packages = with pkgs; [
        librewolf-wayland
        tdesktop
        capitaine-cursors
        nixpkgs-fmt
        onlyoffice-bin
        mate.eom
        rofi
        xfce.thunar
      ];
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
              exec ~/.config/weston/waydroid-session
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
          update-system = "pushd ~/.dotfiles && git add . && sudo nixos-rebuild switch --flake .#; popd";
        };
      };
      git = {
        enable = true;
        userName = "sarveshrulz";
        userEmail = "sarveshkardekar@gmail.com";
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
            y-offset: 58px;
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
            lines: 5;
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
        "hypr/autostart" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP &
            dunst &
            ${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store &
            ${pkgs.gammastep}/bin/gammastep -l 19:72 &
            ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
            foot -s &
            thunar --daemon &
            waybar &
            ${pkgs.swaybg}/bin/swaybg -o \* -i ~/Pictures/Wallpapers/default -m fill
          '';
        };
        "hypr/hyprland.conf".text = ''
          monitor=,1920x1080@60,0x0,1
          input {
              follow_mouse=1
              touchpad {
                natural_scroll=1
              }
          }
          gestures {
              workspace_swipe=1
          }
          misc {
              disable_hyprland_logo=1
              disable_splash_rendering=1
              disable_autoreload=1
          }
          general {
              sensitivity=1.0
              gaps_in=6
              gaps_out=12
              border_size=0
              damage_tracking=full
          }
          decoration {
              rounding=12
              drop_shadow=0
              blur=0
              multisample_edges=0
          }
          animations {
              enabled=1
              animation=windows,1,7,default
              animation=fade,1,10,default
              animation=workspaces,1,6,default
          }
          workspace=,1
          windowrule=float,^(Rofi)$
          windowrule=float,^(Dunst)$
          bind=SUPER,RETURN,exec,footclient
          bind=SUPER,SPACE,exec,rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/apps.rasi
          bind=SUPER,Q,killactive,
          bind=SUPER,left,movefocus,l
          bind=SUPER,right,movefocus,r
          bind=SUPER,up,movefocus,u
          bind=SUPER,down,movefocus,d
          bind=SUPER_SHIFT,left,movewindow,l
          bind=SUPER_SHIFT,right,movewindow,r
          bind=SUPER_SHIFT,up,movewindow,u
          bind=SUPER_SHIFT,down,movewindow,d
          bind=SUPER,1,workspace,1
          bind=SUPER,2,workspace,2
          bind=SUPER,3,workspace,3
          bind=SUPER,4,workspace,4
          bind=SUPER,5,workspace,5
          bind=SUPER,6,workspace,6
          bind=SUPER,7,workspace,7
          bind=SUPER,8,workspace,8
          bind=SUPER,9,workspace,9
          bind=SUPER,0,workspace,10
          bind=SUPER_SHIFT,1,movetoworkspacesilent,1
          bind=SUPER_SHIFT,2,movetoworkspacesilent,2
          bind=SUPER_SHIFT,3,movetoworkspacesilent,3
          bind=SUPER_SHIFT,4,movetoworkspacesilent,4
          bind=SUPER_SHIFT,5,movetoworkspacesilent,5
          bind=SUPER_SHIFT,6,movetoworkspacesilent,6
          bind=SUPER_SHIFT,7,movetoworkspacesilent,7
          bind=SUPER_SHIFT,8,movetoworkspacesilent,8
          bind=SUPER_SHIFT,9,movetoworkspacesilent,9
          bind=SUPER_SHIFT,0,movetoworkspacesilent,10
          bind=SUPER_SHIFT,Q,exit,
          bind=SUPER,F,togglefloating,
          bind=SUPER,M,fullscreen,
          bind=SUPER,PRINT,exec,${pkgs.grim}/bin/grim ~/Pictures/Screenshots/$(date +'%s_grim.png') && dunstify "Screenshot saved!"
          bind=,XF86MonBrightnessUp,exec,~/.config/hypr/scripts/brightness.sh -inc 2
          bind=,XF86MonBrightnessDown,exec,~/.config/hypr/scripts/brightness.sh -dec 2
          bind=,XF86AudioMute,exec,~/.config/hypr/scripts/volume.sh -t
          bind=,XF86AudioRaiseVolume,exec,~/.config/hypr/scripts/volume.sh -i 5
          bind=,XF86AudioLowerVolume,exec,~/.config/hypr/scripts/volume.sh -d 5
          exec-once=/home/sarvesh/.config/hypr/autostart
        '';
        "rofi/apps.rasi".text = ''
          ${rofi-theme}
          configuration {
            font: "Noto Sans Semi-bold 11";
            drun-display-format: "{name}";
            hover-select: false;
            location: 0;
          }
          window {
            width: 260px;
            x-offset: 0;
            y-offset: 0;
          }
        '';
        "rofi/bluetooth.rasi".text = ''
          ${rofi-theme}
          window {
            width: 175px;
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
          window {
            width: 400px;
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
            # Source: https://github.com/TimTinkers/rofi-iwd-menu
            THEME="~/.config/rofi/wlan.rasi"
            DEVICE=$(eval "echo "$\{1:-wlan0}"")
            iwctl station $DEVICE scan
            CURR_SSID=$(iwctl station wlan0 show | grep "Connected" | awk '{print $3}')
            IW_NETWORKS+=$(iwctl station $DEVICE get-networks | sed '/^--/d')
            IW_NETWORKS=$(echo "$IW_NETWORKS" | sed 1,4d)
            IW_NETWORKS=$(echo "$IW_NETWORKS" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
            IFS=$'\n'
            NETWORK_LIST=""
            while IFS= read -r line; do
            	line=$(eval "echo "$\{line:4}"")
            	SSID_NAME=$(echo "$line" | sed 's/\(\s*psk.*\)//')
            	printf -v pad %34s
            	line=$SSID_NAME$pad
            	line=$(eval "echo "$\{line:0:34}"")
            	line+=$'PSK'
            	printf -v pad %45s
            	line=$line$pad
            	line=$(eval "echo "$\{line:0:45}"")
            	line+=$'\n'
            	if ! [ "$SSID_NAME" = "$CURR_SSID" ]; then
            		NETWORK_LIST+=$line
            	fi
            done <<<"$IW_NETWORKS"
            IW_NETWORKS=$(echo "$NETWORK_LIST" | sed '$d')
            if [[ ! -z $CURR_SSID ]]; then
            	HIGHLINE=$(echo "$(echo "$IW_NETWORKS" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURR_SSID" | awk -F ":" '{print $1}') + 1" | ${pkgs.bc}/bin/bc)
            fi
            CON_STATE=$(iwctl station $DEVICE show)
            if [[ "$CON_STATE" =~ " connected" ]]; then
            	MENU="disconnect from $CURR_SSID\nmanually connect to a network\n$IW_NETWORKS"
            elif [[ "$CON_STATE" =~ "disconnected" ]]; then
            	MENU="manually connect to a network\n$IW_NETWORKS"
            fi
            R_WIDTH=$(($(echo "$IW_NETWORKS" | head -n 1 | awk '{print length($0); }') + 5))
            LINE_COUNT=$(echo "$IW_NETWORKS" | wc -l)
            if [[ "$CON_STATE" =~ " connected" ]]; then
            	LINE_COUNT=12
            elif [ "$LINE_COUNT" -gt 8 ] || [[ "$CON_STATE" =~ "disconnected" ]]; then
            	LINE_COUNT=12
            fi
            CHENTRY=$(echo -e "$MENU" | uniq -u | rofi -dmenu -p "WiFi SSID" -lines "$LINE_COUNT" -a "$HIGHLINE" -theme $THEME)
            CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')
            if [ "$CHENTRY" = "manually connect to a network" ]; then
            	MSSID=$(echo "Enter your network's SSID." | rofi -dmenu -p "SSID: " -lines 1 -theme $THEME)
            	WIFI_PASS=$(echo "Enter the network password." | rofi -dmenu -password -p "Password: " -lines 1 -theme $THEME)
            	iwctl station $DEVICE disconnect
            	iwctl --passphrase $WIFI_PASS station $DEVICE connect $MSSID
            elif [[ "$CHENTRY" =~ "disconnect from " ]]; then
            	iwctl station $DEVICE disconnect
            elif [ "$CHSSID" != "" ]; then
            	WIFI_PASS=$(echo "Enter the network password." | rofi -dmenu -password -p "Password: " -lines 1 -theme $THEME)
            	iwctl station $DEVICE disconnect
            	iwctl --passphrase $WIFI_PASS station $DEVICE connect $CHSSID
            fi
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
        "weston/waydroid-session" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            (${pkgs.westonLite}/bin/weston; waydroid session stop) &
            WAYLAND_DISPLAY="wayland-1" waydroid show-full-ui
          '';
        };
        "weston/background.jpg".source = ./files/config/weston/background.jpg;
        "dunst/icons/brightness.png".source = ./files/config/dunst/icons/brightness.png;
        "dunst/icons/muted.png".source = ./files/config/dunst/icons/muted.png;
        "dunst/icons/volume.png".source = ./files/config/dunst/icons/volume.png;
      };

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
      extraGroups = [ "wheel" "video" ];
      shell = pkgs.fish;
      hashedPassword = "$6$Zwt2/p7axZKbTrAS$TLnZdKjq8D712/Ps1bs2QU2VKVESksTc7cg4t6QDbXKTaA7i5NMJNjcRnwKg6vFVk5qVPO//p8PFniEVfRo8R/";
    };
  };
}
