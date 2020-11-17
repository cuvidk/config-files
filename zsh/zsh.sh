#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../shell-utils/util.sh"
. "${SCRIPT_DIR}/../paths.sh"

install() {
    pacman -S --noconfirm --needed zsh
}

post_install() {(
    set -e
    wget 'https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
    export ZSH="${PATH_OHMYZSH}"
    sh install.sh --unattended
    rm -rf install.sh
    mkdir -p "${PATH_PURE}"
    git clone 'https://github.com/sindresorhus/pure.git' "${PATH_PURE}"
    "${SCRIPT_DIR}/zsh_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/zsh_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
)}

uninstall() {
    set -e
    pacman -Rs --noconfirm zsh
}

post_uninstall() {(
    set -e
    "${SCRIPT_DIR}/zsh_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/zsh_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    rm -rf "${PATH_PURE}"
    rm -rf "${PATH_OHMYZSH}"
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'installing zsh'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling zsh'
            perform_task post_uninstall
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
