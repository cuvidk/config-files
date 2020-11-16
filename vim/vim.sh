#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {
    pacman -S --noconfirm --needed vim
}

post_install() {
    "${SCRIPT_DIR}/vim_config.sh" install ${VERBOSE}
}

uninstall() {
    pacman -Rs --noconfirm vim
}

post_uninstall() {
    "${SCRIPT_DIR}/vim.sh" uninstall ${VERBOSE}
}

usage() {
    print_msg "Usage: ${0} [install | uninstall] [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'Installing vim'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling vim'
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
