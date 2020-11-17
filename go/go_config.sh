#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_GO_PROFILE})"
    cp "${SCRIPT_DIR}/config/go.sh" "${PATH_GO_PROFILE}"
)}

uninstall() {
    rm -rf "${PATH_GO_PROFILE}"
}

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

    PATH_GO_PROFILE=$(echo ${PATH_GO_PROFILE} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing go config for user ${USER}"

    check_for_errors
}

main "${@}"
