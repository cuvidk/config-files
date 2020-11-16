#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {(
    set -e
    pacman -S --noconfirm --needed xorg-server
    pacman -S --noconfirm --needed xorg-xinit
)}

post_install() {(
    set -e
    "${SCRIPT_DIR}/xorg_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/xorg_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
)}

uninstall() {(
    set -e
    pacman -Rs --noconfirm xorg-server
    pacman -Rs --noconfirm xorg-xinit
)}

post_uninstall() {(
    set -e
    "${SCRIPT_DIR}/xorg_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/xorg_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'installing xorg-server xorg-xinit'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling xorg-server xorg-xinit'
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
