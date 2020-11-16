#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

PATH_CONFIG=$(echo ${PATH_I3_CONFIG} | sed "s|HOME|${HOME}|")
if [ -n "${SUDO_USER}" ]; then
    SUDO_HOME="$(cat /etc/passwd | grep "${SUDO_USER}" | cut -d ':' -f6)"
    SUDO_PATH_CONFIG=$(echo ${PATH_I3_CONFIG} | sed "s|HOME|${SUDO_HOME}|")
fi

install() {(
    set -e

    mkdir -p "${PATH_CONFIG}"
    cp "${SCRIPT_DIR}/config/config" "${PATH_CONFIG}"

    if [ -n "${SUDO_HOME}" ]; then
        mkdir -p "${SUDO_PATH_CONFIG}"
        cp "${SCRIPT_DIR}/config/config" "${SUDO_PATH_CONFIG}"
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
            perform_task install 'Installing i3 config'
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling i3 config'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
