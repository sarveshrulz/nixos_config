{ ... }: {
  home-manager.users.sarvesh.xdg.configFile."rofi/scripts/rofi-power-menu" = {
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
}
