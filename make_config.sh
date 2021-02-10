#!/bin/sh

MAKE_CONFIG_SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${MAKE_CONFIG_SCRIPT_DIR}/shell-utils/util.sh"
. "${MAKE_CONFIG_SCRIPT_DIR}/paths.sh"

perform_replacements() {
    PATH_OHMYZSH="$(echo ${PATH_OHMYZSH} | sed "s|HOME|${HOME}|")"
    PATH_PURE="$(echo ${PATH_PURE} | sed "s|HOME|${HOME}|")"
    PATH_GOLANG="$(echo ${PATH_GOLANG} | sed "s|HOME|${HOME}|")"
    PATH_DOCKER_SECRET_SERVICE="$(echo ${PATH_DOCKER_SECRET_SERVICE} | sed "s|HOME|${HOME}|")"
    PATH_I3_CONFIG="$(echo ${PATH_I3_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_I3_SCRIPTS="$(echo ${PATH_I3_SCRIPTS} | sed "s|HOME|${HOME}|")"
    PATH_I3_STATUS_CONFIG="$(echo ${PATH_I3_STATUS_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_PICOM_CONFIG="$(echo ${PATH_PICOM_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_VIM_CONFIG="$(echo ${PATH_VIM_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_VIM_PROFILE="$(echo ${PATH_VIM_PROFILE} | sed "s|HOME|${HOME}|")"
    PATH_VIM_DIR="$(echo ${PATH_VIM_DIR} | sed "s|HOME|${HOME}|")"
    PATH_KITTY_CONFIG="$(echo ${PATH_KITTY_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_KITTY_PROFILE="$(echo ${PATH_KITTY_PROFILE} | sed "s|HOME|${HOME}|")"
    PATH_XORG_TOUCHPAD_CONFIG="$(echo ${PATH_XORG_TOUCHPAD_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_DOCKER_CONFIG="$(echo ${PATH_DOCKER_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_GO_PROFILE="$(echo ${PATH_GO_PROFILE} | sed "s|HOME|${HOME}|")"
    PATH_SSH_CONFIG="$(echo ${PATH_SSH_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_LY_CONFIG="$(echo ${PATH_LY_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_ZSH_CONFIG="$(echo ${PATH_ZSH_CONFIG} | sed "s|HOME|${HOME}|")"
    PATH_NOTIFICATION_DAEMON_CONFIG="$(echo ${PATH_NOTIFICATION_DAEMON_CONFIG} | sed "s|HOME|${HOME}|")"
}

usage() {
    print_msg "Usage: ${0} <install|uninstall> <pkg> <username> [--verbose]"
}

exit_with_msg() {
    print_msg "${1}\n"
    usage
    exit ${2}
}

main() {
    setup_verbosity "${@}"

    local action="${1}"
    local pkg="${2}"
    USER="${3}"

    [ -z "${pkg}" ] && exit_with_msg "Missing pkg param" 1
    [ ! -f "${MAKE_CONFIG_SCRIPT_DIR}/${pkg}/${pkg}_config.sh" ] && exit_with_msg "Missing ${pkg}_config.sh" 2

    [ -z "${USER}" ] && exit_with_msg "Missing user param" 3
    HOME=
    for entry in $(cat /etc/passwd); do
        if [ "${USER}" = "$(echo ${entry} | cut -d ':' -f 1)" ]; then
            HOME="$(echo ${entry} | cut -d ':' -f 6)"
            break
        fi
    done
    [ -z "${HOME}" -o ! -d "${HOME}" ] && exit_with_msg "Unable to find home dir for ${USER}" 4

    perform_replacements

    # source config script after performing replacements
    . "${MAKE_CONFIG_SCRIPT_DIR}/${pkg}/${pkg}_config.sh"

    [ -z "$(type install | grep "function")" ] && exit_with_msg "Missing install func" 5
    [ -z "$(type uninstall | grep "function")" ] && exit_with_msg "Missing uninstall func" 6

    if [ "${action}" = "install" ]; then
        [ -n "$(type pre_install | grep "function")" ] && perform_task pre_install
        perform_task install "Installing ${pkg} config for user ${USER}"
        [ -n "$(type post_install | grep "function")" ] && perform_task post_install
    elif [ "${action}" = "uninstall" ]; then
        [ -n "$(type pre_uninstall | grep "function")" ] && perform_task pre_uninstall
        perform_task uninstall "Uninstalling ${pkg} config ${USER}"
        [ -n "$(type post_uninstall | grep "function")" ] && perform_task post_uninstall
    else
        exit_with_msg "Unknown action ${action}" 5
    fi

    check_for_errors
}

main "${@}"
