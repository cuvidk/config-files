#!/bin/sh

HOME="${HOME}"
G_USER="${USER}"
WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/shell-utils/util.sh"

configure_zsh() {
    if [ ! -d "${PATH_PURE}" ]; then
        sudo mkdir -p "${PATH_PURE}"
        sudo git clone 'https://github.com/sindresorhus/pure.git' "${PATH_PURE}"
    fi
    sed "s|ZSH_INSTALL_PATH|${PATH_OHMYZSH}|" "${WORKING_DIR}/config-files/zsh/.zshrc" | 
        sed "s|PURE_INSTALL_PATH|${PATH_PURE}|" |
        sudo tee "${HOME}/.zshrc"
    sudo chown -R "${G_USER}":"${G_USER}" "${HOME}/.zshrc"
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
        "zsh")
            perform_task configure_zsh "Applying zsh config for user ${G_USER}"
            ;;
        *)
            perform_task configure_zsh "Applying zsh config for user ${G_USER}"
            perform_task notification_daemon "Applying notification-daemon config for user ${G_USER}"
            ;;
    esac

    perform_task fix_config_permissions "Fixing permissions "

    check_for_errors
}

main "${@}"
