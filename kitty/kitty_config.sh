#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {(
    set -e
    mkdir -p "$(dirname "${PATH_KITTY_PROFILE}")"
    cp "${SCRIPT_DIR}/config/kitty.sh" "${PATH_KITTY_PROFILE}"
    mkdir -p "$(dirname "${PATH_KITTY_CONFIG}")"
    cp "${SCRIPT_DIR}/config/kitty.conf" "${PATH_KITTY_CONFIG}"
    exit 0
)}

uninstall() {(
    set -e
    rm -rf "${PATH_KITTY_CONFIG}"
    rm -rf "${PATH_KITTY_PROFILE}"
    exit 0
)}

usage() {
    print_msg "Usage: ${0} <install|uninstall> --for-user <username> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            action=install
            shift
            ;;
        "uninstall")
            action=uninstall
            shift
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    USER=
    while [ $# -gt 0 ]; do
        case "${1}" in
            "--for-user")
                USER="${2}"
                break
                ;;
            *)
                shift
                ;;
        esac
    done

    [ -z "${USER}" ] && usage && exit 2
    HOME=
    for entry in $(cat /etc/passwd); do
        if [ "${USER}" = "$(echo ${entry} | cut -d ':' -f 1)" ]; then
            HOME="$(echo ${entry} | cut -d ':' -f 6)"
            break
        fi
    done
    [ -z "${HOME}" -o ! -d "${HOME}" ] && usage && exit 3

    PATH_KITTY_CONFIG=$(echo ${PATH_KITTY_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing kitty config for user ${USER}"

    check_for_errors
}

main "${@}"
