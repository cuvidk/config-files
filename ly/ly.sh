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
    "${MAKE_SCRIPT_DIR}/make_config.sh" install ly "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install ly "${SUDO_USER}" ${VERBOSE}
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
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall ly "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall ly "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
