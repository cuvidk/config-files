#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

pre_install() {
    export AUR_PKG_INSTALL_USER='aur'
    (
        set -e
        useradd "${AUR_PKG_INSTALL_USER}"
        echo "${AUR_PKG_INSTALL_USER} ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/${AUR_PKG_INSTALL_USER}"
        exit 0
    )
}

install() {(
    set -e
    git clone "https://aur.archlinux.org/ly-git.git"
    chown -R ${AUR_PKG_INSTALL_USER}:${AUR_PKG_INSTALL_USER} "./ly-git"
    cd "./ly-git"
    su ${AUR_PKG_INSTALL_USER} --command="makepkg -s --noconfirm"
    pacman -U --noconfirm *.pkg.tar.*
    cd -
    rm -rf "ly-git"
    exit 0
)}

post_install() {(
    set -e
    "${SCRIPT_DIR}/ly_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/ly_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
    userdel "${AUR_PKG_INSTALL_USER}"
    rm "/etc/sudoers.d/${AUR_PKG_INSTALL_USER}"
    systemctl disable getty@tty2.service
    systemctl enable ly.service
    exit 0
)}

uninstall() {(
    set -e
    systemctl enable getty@tty2.service
    systemctl disable ly.service
    pacman -Rs --noconfirm ly-git
    exit 0
)}

post_uninstall() {(
    set -e
    "${SCRIPT_DIR}/ly_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/ly_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install 'preinstall ly'
            perform_task install 'installing ly'
            perform_task post_install
            ;;
        "uninstall")
            perform_task uninstall 'uninstalling ly'
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
