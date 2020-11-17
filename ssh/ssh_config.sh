#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_SSH_CONFIG})"
    cp "${SCRIPT_DIR}/config/ssh_agent.sh" "${PATH_SSH_CONFIG}"

    # i'm doing this dinamically because I want to append
    # instead of overwritting with a static file
    echo '. ${HOME}/.ssh/ssh_agent.sh' | sudo tee -a "${HOME}/.zprofile"
)}

uninstall() {
    rm -rf "${PATH_SSH_CONFIG}"
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

    PATH_SSH_CONFIG=$(echo ${PATH_SSH_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing ssh config for user ${USER}"

    check_for_errors
}

main "${@}"
