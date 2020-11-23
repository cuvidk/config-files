#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {
    pacman -S --noconfirm --needed i3status
}

post_install() {(
    set -e
    "${SCRIPT_DIR}/i3status_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/i3status_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm i3status
}

post_uninstall() {(
    set -e
    "${SCRIPT_DIR}/i3status_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/i3status_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'installing i3status'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling i3status'
            perform_task post_uninstall
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
