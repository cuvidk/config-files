#!/bin/sh

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/../shell-utils/util.sh"
. "${WORKING_DIR}/../install_paths.sh"

install() {
    wget 'https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
    export ZSH="${PATH_OHMYZSH}"
    sudo -E -H sh install.sh --unattended
    local ret=$?
    unset ZSH
    rm -rf install.sh
    return ${ret}
}

uninstall() {
    sudo rm -rf "${PATH_OHMYZSH}"
}

usage() {
    print_msg "Usage: ${0} <install|uninstall>\n"
}

main() {
    sudo ls /etc/shadow >/dev/null
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'Installing Oh-My-Zsh'
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling Oh-My-Zsh'
            ;;
        *)
            usage
            exit 1
    esac

    check_for_errors
}

main "${@}"
