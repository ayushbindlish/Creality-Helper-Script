#!/bin/sh

# Main entry point for the interactive text interface.  All menu navigation
# starts here once `helper.sh` has loaded every script.

set -e

# Ensure the factory reset service exists so that the "Reset" option works.
if [ ! -f /etc/init.d/S58factoryreset ]; then
  cp /usr/data/helper-script/files/services/S58factoryreset /etc/init.d/S58factoryreset
  chmod 755 /etc/init.d/S58factoryreset
fi

# Detect which printer model is running the script.  Some menu options are
# only applicable to certain models.
get_model=$( /usr/bin/get_sn_mac.sh model 2>&1 )
if echo "$get_model" | grep -iq "K1"; then
  model="K1"
elif echo "$get_model" | grep -iq "F001"; then
  model="3V3"
elif echo "$get_model" | grep -iq "F002"; then
  model="3V3"
elif echo "$get_model" | grep -iq "F005"; then
  model="3KE"
elif echo "$get_model" | grep -iq "F003"; then
  model="10SE"
elif echo "$get_model" | grep -iq "F004"; then
  model="E5M"
fi

# Display the current version tag of the helper script in the menu footer.
function get_script_version() {
  local version
  cd "${HELPER_SCRIPT_FOLDER}"
  version="$(git describe HEAD --always --tags | sed 's/-.*//')"
  echo "${cyan}${version}${white}"
}

# Helper for formatting version text to match the menu border width.
function version_line() {
  local content="$1"
  local content_length="${#content}"
  local width=$((75))
  local padding_length=$((width - content_length - 3))
  printf " │ %*s%s%s\n" $padding_length '' "$content" " │"
}

# Build a title string depending on the detected printer model.
function script_title() {
  local title
  if [ "$model" = "K1" ]; then
    title="K1 SERIES"
  elif [ "$model" = "3V3" ]; then
    title="ENDER-3 V3 SERIES"
  elif [ "$model" = "3KE" ]; then
    title="ENDER-3 V3 KE"
  elif [ "$model" = "10SE" ]; then
    title="CR-10 SE"
  elif [ "$model" = "E5M" ]; then
    title="Ender-5 MAX"
  else
    title="PRINTERS"
  fi
  echo "${title}"
}

# Draw the main menu screen.  The UI helpers used here are defined in other
# sourced scripts.
function main_menu_ui() {
  top_line
  title "• HELPER SCRIPT FOR CREALITY $(script_title) •" "${blue}"
  title "Copyright © Cyril Guislain (Guilouz)" "${white}"
  inner_line
  title "/!\\ ONLY USE THIS SCRIPT WITH LATEST FIRMWARE VERSION /!\\" "${darkred}"
  inner_line
  hr
  main_menu_option '1' '[Install]' 'Menu'
  main_menu_option '2' '[Remove]' 'Menu'
  main_menu_option '3' '[Customize]' 'Menu'
  main_menu_option '4' '[Backup & Restore]' 'Menu'
  main_menu_option '5' '[Tools]' 'Menu'
  main_menu_option '6' '[Information]' 'Menu'
  main_menu_option '7' '[System]' 'Menu'
  hr
  inner_line
  hr
  bottom_menu_option 'q' 'Exit' "${darkred}"
  hr
  version_line "$(get_script_version)"
  bottom_line
}

# Main menu loop.  Based on the user selection the appropriate sub menu is
# displayed.  Each of the called functions is defined in a printer specific
# script loaded by `helper.sh`.
function main_menu() {
  clear
  main_menu_ui
  local main_menu_opt
  while true; do
    read -p "${white} Type your choice and validate with Enter: ${yellow}" main_menu_opt
    case "${main_menu_opt}" in
      1) clear
         if [ "$model" = "K1" ]; then
           install_menu_k1
         elif [ "$model" = "3V3" ]; then
           install_menu_3v3
         elif [ "$model" = "3KE" ]; then
           install_menu_3ke
         elif [ "$model" = "E5M" ]; then
           install_menu_e5m
         else
           install_menu_10se
         fi
         break;;
      2) clear
         if [ "$model" = "K1" ]; then
           remove_menu_k1
         elif [ "$model" = "3V3" ]; then
           remove_menu_3v3
         elif [ "$model" = "3KE" ]; then
           remove_menu_3ke
         elif [ "$model" = "E5M" ]; then
           remove_menu_e5m
         else
           remove_menu_10se
         fi
         break;;
      3) clear
         if [ "$model" = "K1" ]; then
           customize_menu_k1
         elif [ "$model" = "3V3" ]; then
           customize_menu_3v3
         elif [ "$model" = "3KE" ]; then
           customize_menu_3ke
         elif [ "$model" = "E5M" ]; then
           customize_menu_e5m
         else
           customize_menu_10se
         fi
         break;;
      4) clear
         backup_restore_menu
         break;;
      5) clear
         if [ "$model" = "K1" ]; then
           tools_menu_k1
         elif [ "$model" = "3V3" ]; then
           tools_menu_3v3
         elif [ "$model" = "3KE" ]; then
           tools_menu_3ke
         elif [ "$model" = "E5M" ]; then
           tools_menu_e5m
         else
           tools_menu_10se
         fi
         main_ui;;
      6) clear
         if [ "$model" = "K1" ]; then
           info_menu_k1
         elif [ "$model" = "3V3" ]; then
           info_menu_3v3
         elif [ "$model" = "3KE" ]; then
           info_menu_3ke
         elif [ "$model" = "E5M" ]; then
           info_menu_e5m
         else
           info_menu_10se
         fi
         break;;
      7) clear
         system_menu
         break;;
      Q|q)
         clear; exit 0;;
      *)
         error_msg "Please select a correct choice!";;
    esac
  done
  main_menu
}
