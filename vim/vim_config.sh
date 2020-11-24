#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {(
    set -e
    mkdir -p "$(dirname "${PATH_VIM_PROFILE}")"
    cp "${SCRIPT_DIR}/config/vim.sh" "${PATH_VIM_PROFILE}"
    cp "${SCRIPT_DIR}/config/.vimrc" "${PATH_VIM_CONFIG}"
    mkdir -p "${PATH_VIM_DIR}/colors"
    cp -r "${SCRIPT_DIR}/config/colors" "${PATH_VIM_DIR}/colors"
    exit 0
)}

uninstall() {(
    set -e
    rm -rf "${PATH_VIM_CONFIG}"
    rm -rf "${PATH_VIM_PROFILE}"
    rm -rf "${PATH_VIM_DIR}"
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

    PATH_VIM_CONFIG=$(echo ${PATH_VIM_CONFIG} | sed "s|HOME|${HOME}|")
    PATH_VIM_DIR=$(echo ${PATH_VIM_DIR} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing vim config for user ${USER}"

    check_for_errors
}

main "${@}"
