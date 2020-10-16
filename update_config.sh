#!/bin/sh

################################################################################

configure_i3() {
    mkdir -p "$g_home_dir/.config/i3" &&
        cp "${WORKING_DIR}/config-files/i3/config" "$g_home_dir/.config/i3/"
}

configure_i3status() {
    mkdir -p "$g_home_dir/.config/i3status" &&
        cp "${WORKING_DIR}/config-files/i3status/config" "$g_home_dir/.config/i3status/"
}

configure_picom() {
    sudo cp -R "${WORKING_DIR}/config-files/picom/etc" /
}

configure_vim() {
    sudo cp -R "${WORKING_DIR}/config-files/vim/etc" /
}

configure_kitty() {
    mkdir -p "$g_home_dir/.config/kitty" &&
        cp "${WORKING_DIR}/config-files/kitty/kitty.conf" "$g_home_dir/.config/kitty/" &&
        sudo cp -R "${WORKING_DIR}/config-files/kitty/etc" /
}

configure_ly() {
    sudo cp -R "${WORKING_DIR}/config-files/ly/etc" /
}

configure_x11_input() {
    # is it worth copying this only if a touchpad is present ?
    sudo cp -R "${WORKING_DIR}/config-files/X11/etc" /
}

notification_daemon() {
    sudo cp -R "${WORKING_DIR}/config-files/notification-daemon/usr" /
}

fix_config_permissions() {
    sudo chown -R "$g_user":"$g_user" "$g_home_dir/.config"
}

usage() {
    print_msg "Usage: ${0} [--user|-u <username>] [--config|-c <config>] [--help|-h]\n"
}

################################################################################

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/shell-utils/util.sh"

setup_output

# This is just a hack (required but can be ignored);
# it's here to fix the output of the script. It requires
# the root password before outputing anything on the
# screen. This way, any function requiring root access
# won't overwrite the information being displayed on
# screen with a password prompt.
sudo ls >/dev/null || exit 1

g_home_dir="${HOME}"
g_user="${USER}"

while [ $# -gt 0 ]; do
    case "${1}" in
        "--help"|"-h")
            usage
            exit 0
            ;;
        "--user"|"-u")
            g_home_dir="$(grep "${2}" /etc/passwd | cut -d ':' -f6)"
            g_user="${2}"
            shift
            shift
            ;;
        "--config"|"-c")
            g_config="${2}"
            shift
            shift
            ;;
        *)
            usage
            exit 2
            ;;
    esac
done

if [ ! -d "${g_home_dir}" ]; then
    print_msg "ERR: Unknown user ${g_user}\n"
    exit 3
fi

case "${g_config}" in
    "i3")
        perform_task configure_i3 "Applying i3 config for user ${g_user}"
        ;;
    "i3status")
        perform_task configure_i3status "Applying i3status config for user ${g_user}"
        ;;
    "picom")
        perform_task configure_picom "Applying picom config for user ${g_user}"
        ;;
    "vim")
        perform_task configure_vim "Applying vim config for user ${g_user}"
        ;;
    "kitty")
        perform_task configure_kitty "Applying kitty config for user ${g_user}"
        ;;
    "ly")
        perform_task configure_ly "Applying ly config for user ${g_user}"
        ;;
    *)
        perform_task configure_i3 "Applying i3 config for user ${g_user}"
        perform_task configure_i3status "Applying i3status config for user ${g_user}"
        perform_task configure_picom "Applying picom config for user ${g_user}"
        perform_task configure_vim "Applying vim config for user ${g_user}"
        perform_task configure_kitty "Applying kitty config for user ${g_user}"
        perform_task configure_ly "Applying ly config for user ${g_user}"
        perform_task configure_x11_input "Applying x11 config for user ${g_user}"
        perform_task notification_daemon "Applying notification-daemon config for user ${g_user}"
        ;;
esac

perform_task fix_config_permissions "Fixing permissions "

check_for_errors
exit $?
