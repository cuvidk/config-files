#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {(
    set -e
    mkdir -p "$(dirname ${PATH_NOTIFICATION_DAEMON_CONFIG})"
    cp "${SCRIPT_DIR}/config/org.freedesktop.Notifications.service" "${PATH_NOTIFICATION_DAEMON_CONFIG}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_NOTIFICATION_DAEMON_CONFIG}"
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

    PATH_NOTIFICATION_DAEMON_CONFIG=$(echo ${PATH_NOTIFICATION_DAEMON_CONFIG} | sed "s|HOME|${HOME}|")

    perform_task ${action} "${action}ing notification-daemon config for user ${USER}"

    check_for_errors
}

main "${@}"
