#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

PATH_CONFIG=$(echo ${PATH_KITTY_CONFIG} | sed "s|HOME|${HOME}|")
if [ -n "${SUDO_USER}" ]; then
    SUDO_HOME="$(cat /etc/passwd | grep "${SUDO_USER}" | cut -d ':' -f6)"
    SUDO_PATH_CONFIG=$(echo ${PATH_KITTY_CONFIG} | sed "s|HOME|${SUDO_HOME}|")
fi

install() {(
    set -e

    mkdir -p "$(dirname "${PATH_KITTY_PROFILE}")"
    cp "${SCRIPT_DIR}/config/kitty.sh" "${PATH_KITTY_PROFILE}"

    mkdir -p "$(dirname "${PATH_CONFIG}")"
    cp "${SCRIPT_DIR}/config/kitty.conf" "${PATH_CONFIG}"

    if [ -n "${SUDO_HOME}" ]; then
        mkdir -p "$(dirname "${SUDO_PATH_CONFIG}")"
        cp "${SCRIPT_DIR}/config/kitty.conf" "${SUDO_PATH_CONFIG}"
    fi
)}

uninstall() {(
    set -e
    rm -rf "${PATH_CONFIG}"
    [ -n "${SUDO_HOME}" ] && rm -rf "${SUDO_PATH_CONFIG}"
)}

usage() {
    print_msg "Usage: ${0} [install|uninstall] [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'Installing kitty config'
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling kitty config'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
