#!/bin/sh

G_HOME_DIR="${HOME}"
G_USER="${USER}"
WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/shell-utils/util.sh"
. "${WORKING_DIR}/install_paths.sh"

configure_i3() {
    mkdir -p "${G_HOME_DIR}/.config/i3" &&
        cp "${WORKING_DIR}/config-files/i3/config" "${G_HOME_DIR}/.config/i3/"
}

configure_i3status() {
    mkdir -p "${G_HOME_DIR}/.config/i3status" &&
        cp "${WORKING_DIR}/config-files/i3status/config" "${G_HOME_DIR}/.config/i3status/"
}

configure_picom() {
    sudo cp -R "${WORKING_DIR}/config-files/picom/etc" /
}

configure_vim() {
    sudo cp -R "${WORKING_DIR}/config-files/vim/etc" /
}

configure_kitty() {
    mkdir -p "${G_HOME_DIR}/.config/kitty" &&
        cp "${WORKING_DIR}/config-files/kitty/kitty.conf" "${G_HOME_DIR}/.config/kitty/" &&
        sudo cp -R "${WORKING_DIR}/config-files/kitty/etc" /
}

configure_zsh() {
    sed "s|ZSH_INSTALL_PATH|${PATH_OHMYZSH}|" "${WORKING_DIR}/config-files/zsh/.zshrc" | sudo tee "${G_HOME_DIR}/.zshrc"
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
    if [ -d "${G_HOME_DIR}/.config" ]; then
        sudo chown -R "${G_USER}":"${G_USER}" "${G_HOME_DIR}/.config"
    fi
}

usage() {
    print_msg "Usage: ${0} [--user|-u <username>] [--config|-c <config>] [--help|-h]\n"
}

main() {
    # This is just a hack (required but can be ignored);
    # it's here to fix the output of the script. It requires
    # the root password before outputing anything on the
    # screen. This way, any function requiring root access
    # won't overwrite the information being displayed on
    # screen with a password prompt.
    sudo ls >/dev/null || exit 1
    setup_output


    while [ $# -gt 0 ]; do
        case "${1}" in
            "--help"|"-h")
                usage
                exit 0
                ;;
            "--user"|"-u")
                G_HOME_DIR="$(grep "${2}" /etc/passwd | cut -d ':' -f6)"
                G_USER="${2}"
                shift
                shift
                ;;
            "--config"|"-c")
                G_CONFIG="${2}"
                shift
                shift
                ;;
            *)
                usage
                exit 2
                ;;
        esac
    done

    if [ ! -d "${G_HOME_DIR}" ]; then
        print_msg "ERR: Unknown user ${G_USER}\n"
        exit 3
    fi

    case "${G_CONFIG}" in
        "i3")
            perform_task configure_i3 "Applying i3 config for user ${G_USER}"
            ;;
        "i3status")
            perform_task configure_i3status "Applying i3status config for user ${G_USER}"
            ;;
        "picom")
            perform_task configure_picom "Applying picom config for user ${G_USER}"
            ;;
        "vim")
            perform_task configure_vim "Applying vim config for user ${G_USER}"
            ;;
        "kitty")
            perform_task configure_kitty "Applying kitty config for user ${G_USER}"
            ;;
        "ly")
            perform_task configure_ly "Applying ly config for user ${G_USER}"
            ;;
        "zsh")
            perform_task configure_zsh "Applying zsh config for user ${G_USER}"
            ;;
        *)
            perform_task configure_i3 "Applying i3 config for user ${G_USER}"
            perform_task configure_i3status "Applying i3status config for user ${G_USER}"
            perform_task configure_picom "Applying picom config for user ${G_USER}"
            perform_task configure_vim "Applying vim config for user ${G_USER}"
            perform_task configure_kitty "Applying kitty config for user ${G_USER}"
            perform_task configure_zsh "Applying zsh config for user ${G_USER}"
            perform_task configure_ly "Applying ly config for user ${G_USER}"
            perform_task configure_x11_input "Applying x11 config for user ${G_USER}"
            perform_task notification_daemon "Applying notification-daemon config for user ${G_USER}"
            ;;
    esac

    perform_task fix_config_permissions "Fixing permissions "

    check_for_errors
}

main "${@}"
