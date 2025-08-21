#!/bin/sh

# Entry point for the Creality Helper Script.  The file is executed on the
# printer and is responsible for loading every other shell script in this
# repository before displaying the interactive menu.

set -e               # exit immediately on errors
clear                 # start with a clean terminal

# Absolute path to the directory containing this script.  Other scripts are
# loaded relative to this location so the helper can run from anywhere.
HELPER_SCRIPT_FOLDER="$(dirname "$(readlink -f "$0")")"

# Source the shared helper functions.
for script in "${HELPER_SCRIPT_FOLDER}/scripts/"*.sh; do . "${script}"; done
# Source general menu helpers.
for script in "${HELPER_SCRIPT_FOLDER}/scripts/menu/"*.sh; do . "${script}"; done
# Source printer specific menu entries.
for script in "${HELPER_SCRIPT_FOLDER}/scripts/menu/K1/"*.sh; do . "${script}"; done
for script in "${HELPER_SCRIPT_FOLDER}/scripts/menu/3V3/"*.sh; do . "${script}"; done
for script in "${HELPER_SCRIPT_FOLDER}/scripts/menu/3KE/"*.sh; do . "${script}"; done
for script in "${HELPER_SCRIPT_FOLDER}/scripts/menu/10SE/"*.sh; do . "${script}"; done
for script in "${HELPER_SCRIPT_FOLDER}/scripts/menu/E5M/"*.sh; do . "${script}"; done

# Fetch the latest changes from the repository and restart the script.  This
# function is triggered when the user chooses to update from the menu.
function update_helper_script() {
  echo -e "${white}"
  echo -e "Info: Updating Creality Helper Script..."
  cd "${HELPER_SCRIPT_FOLDER}"
  git reset --hard && git pull
  ok_msg "Creality Helper Script has been updated!"
  echo -e "   ${green}Please restart script to load the new version.${white}"
  echo
  exit 0
}

# Check if a newer version of the script is available upstream.  The function
# compares the local HEAD to the latest commit on the `main` branch.
function update_available() {
  [[ ! -d "${HELPER_SCRIPT_FOLDER}/.git" ]] && return
  local remote current
  cd "${HELPER_SCRIPT_FOLDER}"
  ! git branch -a | grep -q "\* main" && return
  git fetch -q > /dev/null 2>&1
  remote=$(git rev-parse --short=8 FETCH_HEAD)
  current=$(git rev-parse --short=8 HEAD)
  if [[ ${remote} != "${current}" ]]; then
    echo "true"
  fi
}

# Display an interactive prompt asking the user to update when a newer version
# is detected.
function update_menu() {
  local update_available=$(update_available)
  if [[ "$update_available" == "true" ]]; then
    top_line
    title "A new script version is available!" "${green}"
    inner_line
    hr
    echo -e " │ ${cyan}It's recommended to keep script up to date. Updates usually    ${white}│"
    echo -e " │ ${cyan}contain bug fixes, important changes or new features.          ${white}│"
    echo -e " │ ${cyan}Please consider updating!                                      ${white}│"
    hr
    echo -e " │ See changelog here: ${yellow}https://tinyurl.com/3sf3bzck               ${white}│"
    hr
    bottom_line
    local yn
    while true; do
      read -p " Do you want to update now? (${yellow}y${white}/${yellow}n${white}): ${yellow}" yn
      case "${yn}" in
        Y|y)
          run "update_helper_script"
          if [ ! -x "$HELPER_SCRIPT_FOLDER"/helper.sh ]; then
            chmod +x "$HELPER_SCRIPT_FOLDER"/helper.sh >/dev/null 2>&1
          fi
          break;;
        N|n)
          break;;
        *)
          error_msg "Please select a correct choice!";;
      esac
    done
  fi
}

# Create a convenience symlink so the script can be started by typing
# `helper` from anywhere in the terminal.
if [ ! -L /usr/bin/helper ]; then
  ln -sf "$HELPER_SCRIPT_FOLDER"/helper.sh /usr/bin/helper > /dev/null 2>&1
fi

rm -rf /root/.cache          # remove residual cache to save space
set_paths                    # defined in sourced scripts
set_permissions              # ensure files have the correct permissions
update_menu                  # check for updates before showing the menu
main_menu                    # launch the interactive menu
