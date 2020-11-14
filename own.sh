#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/paths.sh"
. "${SCRIPT_DIR}/shell-utils/util.sh"

if [ -n "${SUDO_USER}" ]; then
    USER="${SUDO_USER}"
    HOME="$(cat /etc/passwd | grep "${USER}" | cut -d ':' -f 6)"
fi

usage() {
    print_msg "Usage: ${0} [tool] [--verbose]"
}

chown_i3() {
    chown -R "${USER}":"${USER}" "$(echo ${PATH_I3_CONFIG} | sed "s|HOME|${HOME}|")"
}

chown_i3status() {
    chown -R "${USER}":"${USER}" "$(echo ${PATH_I3_STATUS_CONFIG} | sed "s|HOME|${HOME}|")"
}

main() {
    setup_verbosity "${@}"

    case "${1}" in 
        "i3")
            perform_task chown_i3 'Fixing owner for i3'
            ;;
        "i3status")
            perform_task chown_i3status 'Fixing owner for i3status'
            ;;
        "all")
            perform_task chown_i3 'Fixing owner for i3'
            perform_task chown_i3 'Fixing owner for i3status'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
