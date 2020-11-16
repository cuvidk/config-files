#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

PATH_CONFIG=$(echo ${PATH_VIM_CONFIG} | sed "s|HOME|${HOME}|")
if [ -n "${SUDO_USER}" ]; then
    SUDO_HOME="$(cat /etc/passwd | grep "${SUDO_USER}" | cut -d ':' -f6)"
    SUDO_PATH_CONFIG=$(echo ${PATH_VIM_CONFIG} | sed "s|HOME|${SUDO_HOME}|")
fi

install() {(
    set -e
    cp "${SCRIPT_DIR}/config/.vimrc" "${PATH_CONFIG}"
    cp "${SCRIPT_DIR}/config/vim.sh" "${PATH_VIM_PROFILE}"

    if [ -n "${SUDO_HOME}" ]; then
        cp "${SCRIPT_DIR}/config/.vimrc" "${SUDO_PATH_CONFIG}"
    fi
)}

uninstall() {(
    set -e
    rm -rf "${PATH_CONFIG}"
    rm -rf "${PATH_VIM_PROFILE}"
)}

usage() {
    print_msg "Usage: ${0} [install|uninstall] [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'Installing vim config'
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling vim config'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
