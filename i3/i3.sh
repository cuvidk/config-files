#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {
    pacman -S --noconfirm --needed i3-gaps
}

post_install() {
    "${SCRIPT_DIR}/i3_config.sh" install ${VERBOSE}
}

uninstall() {
    pacman -Rs --noconfirm i3-gaps
}

post_uninstall() {
    "${SCRIPT_DIR}/i3_config.sh" uninstall ${VERBOSE}
}

usage() {
    print_msg "Usage: ${0} [install | uninstall] [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'Installing i3'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling i3'
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