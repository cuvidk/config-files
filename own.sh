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

chown_vim() {
    chown "${USER}":"${USER}" "$(echo ${PATH_VIM_CONFIG} | sed "s|HOME|${HOME}|")/.vimrc"
}

chown_picom() {
    # globabl file; not user specific. This can be owned by root
    chown "${USER}":"${USER}" "${PATH_PICOM_CONFIG}/picom.conf"
}

main() {
    setup_verbosity "${@}"

    chown -R "${USER}":"${USER}" "${HOME}/.config"

    #case "${1}" in 
    #    "i3")
    #        perform_task chown_i3 'Fixing owner for i3 config'
    #        ;;
    #    "i3status")
    #        perform_task chown_i3status 'Fixing owner for i3status config'
    #        ;;
    #    "vim")
    #        perform_task chown_vim 'Fixing owner for vim config'
    #        ;;
    #    "picom")
    #        perform_task chown_picom 'Fixing owner for picom config'
    #        ;;
    #    "all")
    #        perform_task chown_i3 'Fixing owner for i3 config'
    #        perform_task chown_i3 'Fixing owner for i3status config'
    #        perform_task chown_vim 'Fixing owner for vim config'
    #        ;;
    #    *)
    #        usage
    #        exit 1
    #        ;;
    #esac

    check_for_errors
}

main "${@}"
