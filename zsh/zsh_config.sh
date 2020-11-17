#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_ZSH_CONFIG})"
    sed "s|ZSH_INSTALL_PATH|${PATH_OHMYZSH}|" "${SCRIPT_DIR}/config/.zshrc" | 
        sed "s|PURE_INSTALL_PATH|${PATH_PURE}|" |
        tee "${PATH_ZSH_CONFIG}"
    chsh -s /bin/zsh "${USER}"
)}

uninstall() {(
    set -e
    rm -rf "${PATH_ZSH_CONFIG}"
    chsh -s /bin/bash "${USER}"
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
    HOME="$(cat /etc/passwd | grep "${USER}" | cut -d ':' -f 6)"
    [ -z "${HOME}" ] && usage && exit 3

    PATH_ZSH_CONFIG=$(echo ${PATH_ZSH_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing zsh config for user ${USER}"

    check_for_errors
}

main "${@}"
