#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/paths.sh"
. "${SCRIPT_DIR}/shell-utils/util.sh"

usage() {
    print_msg "Usage: ${0} <username>"
}

main() {
    setup_verbosity "${@}"

    [ -z "${1}" ] && usage && exit 1
    USER="${1}"
    HOME="$(cat /etc/passwd | grep -E "^${USER}$" | cut -d ':' -f 6)"
    [ -z "${HOME}" -o ! -d "${HOME}" ] && usage && exit 2

    PATH_VIM_CONFIG="$(echo "${PATH_VIM_CONFIG}" | sed "s|HOME|${HOME}|")"
    PATH_ZSH_CONFIG="$(echo "${PATH_ZSH_CONFIG}" | sed "s|HOME|${HOME}|")"

    chown -R "${USER}":"${USER}" "${HOME}/.config"
    chown -R "${USER}":"${USER}" "${HOME}/.ssh"
    chown -R "${USER}":"${USER}" "${HOME}/.docker"
    chown -R "${USER}":"${USER}" "${PATH_VIM_CONFIG}"
    chown -R "${USER}":"${USER}" "${PATH_ZSH_CONFIG}"
    chown -R "${USER}":"${USER}" "${PATH_GOLANG}"

    check_for_errors
}

main "${@}"
