#!/bin/sh

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/../shell-utils/util.sh"

install() {
    sudo pacman -S --needed --noconfirm go
}

uninstall() {
    sudo pacman -Rs --noconfirm go
}

usage() {
    print_msg "Usage: ${0} <install|uninstall>\n"
}

main() {
    sudo ls /etc/shadow >/dev/null
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'Installing Golang'
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling Golang'
            ;;
        *)
            usage
            exit 1
    esac

    check_for_errors
}

main "${@}"
