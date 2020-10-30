#!/bin/sh

HOME="${HOME}"
G_USER="${USER}"
WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/shell-utils/util.sh"

configure_i3() {
    sudo mkdir -p "${HOME}/.config/i3" &&
        sudo cp "${WORKING_DIR}/config-files/i3/config" "${HOME}/.config/i3/"
}

configure_i3status() {
    sudo mkdir -p "${HOME}/.config/i3status" &&
        sudo cp "${WORKING_DIR}/config-files/i3status/config" "${HOME}/.config/i3status/"
}

configure_picom() {
    sudo cp -R "${WORKING_DIR}/config-files/picom/etc" /
}

configure_vim() {
    sudo cp -R "${WORKING_DIR}/config-files/vim/etc" /
}

configure_kitty() {
    sudo mkdir -p "${HOME}/.config/kitty" &&
        sudo cp "${WORKING_DIR}/config-files/kitty/kitty.conf" "${HOME}/.config/kitty/" &&
        sudo cp -R "${WORKING_DIR}/config-files/kitty/etc" /
}

configure_zsh() {
    if [ ! -d "${PATH_PURE}" ]; then
        sudo mkdir -p "${PATH_PURE}"
        sudo git clone 'https://github.com/sindresorhus/pure.git' "${PATH_PURE}"
    fi
    sed "s|ZSH_INSTALL_PATH|${PATH_OHMYZSH}|" "${WORKING_DIR}/config-files/zsh/.zshrc" | 
        sed "s|PURE_INSTALL_PATH|${PATH_PURE}|" |
        sudo tee "${HOME}/.zshrc"
}

configure_ssh() {
    sudo mkdir -p "${HOME}/.ssh" &&
        sudo cp -R "${WORKING_DIR}/config-files/ssh/ssh-agent.sh" "${HOME}/.ssh" &&
        echo '. ${HOME}/.ssh/ssh-agent.sh' | sudo tee -a "${HOME}/.zprofile"
}

configure_docker() {
    sudo mkdir -p "${HOME}/.docker" &&
        sudo cp "${WORKING_DIR}/config-files/docker/config.json" "${HOME}/.docker" &&
        sudo chown -R "${G_USER}":"${G_USER}" "${HOME}/.docker"
}

configure_go() {
    sudo mkdir -p "${PATH_GOLANG}" &&
        sed "s|PATH_GOLANG|${PATH_GOLANG}|" "${WORKING_DIR}/config-files/go/etc/profile.d/go.sh" |
        sudo tee /etc/profile.d/go.sh
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
    if [ -d "${HOME}/.config" ]; then
        sudo chown -R "${G_USER}":"${G_USER}" "${HOME}/.config"
    fi
}

usage() {
    print_msg "Usage: ${0} [--user|-u <username>] [--config|-c <config>] [--help|-h] [--verbose|-v]\n"
}

main() {
    # This is just a hack (required but can be ignored);
    # it's here to fix the output of the script. It requires
    # the root password before outputing anything on the
    # screen. This way, any function requiring root access
    # won't overwrite the information being displayed on
    # screen with a password prompt.
    sudo ls >/dev/null || exit 1

    setup_verbosity "${@}"

    while [ $# -gt 0 ]; do
        case "${1}" in
            "--help"|"-h")
                usage
                exit 0
                ;;
            "--user"|"-u")
                HOME="$(grep "${2}" /etc/passwd | cut -d ':' -f6)"
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
                shift
                ;;
        esac
    done

    . "${WORKING_DIR}/install_paths.sh"

    if [ ! -d "${HOME}" ]; then
        print_msg "ERR: Unknown user ${G_USER}\n"
        exit 2
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
        "ssh")
            perform_task configure_ssh "Applying ssh config for user ${G_USER}"
            ;;
        "docker")
            perform_task configure_docker "Applying docker config for user ${G_USER}"
            ;;
        "go")
            perform_task configure_go "Applying go config for user ${G_USER}"
            ;;
        *)
            perform_task configure_i3 "Applying i3 config for user ${G_USER}"
            perform_task configure_i3status "Applying i3status config for user ${G_USER}"
            perform_task configure_picom "Applying picom config for user ${G_USER}"
            perform_task configure_vim "Applying vim config for user ${G_USER}"
            perform_task configure_kitty "Applying kitty config for user ${G_USER}"
            perform_task configure_zsh "Applying zsh config for user ${G_USER}"
            perform_task configure_ssh "Applying ssh config for user ${G_USER}"
            perform_task configure_docker "Applying docker config for user ${G_USER}"
            perform_task configure_go "Applying go config for user ${G_USER}"
            perform_task configure_ly "Applying ly config for user ${G_USER}"
            perform_task configure_x11_input "Applying x11 config for user ${G_USER}"
            perform_task notification_daemon "Applying notification-daemon config for user ${G_USER}"
            ;;
    esac

    perform_task fix_config_permissions "Fixing permissions "

    check_for_errors
}

main "${@}"
