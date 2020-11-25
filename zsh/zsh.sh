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
    "${MAKE_SCRIPT_DIR}/make_config.sh" install zsh "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install zsh "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm zsh
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall zsh "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall zsh "${SUDO_USER}" ${VERBOSE}
    rm -rf "${PATH_PURE}"
    rm -rf "${PATH_OHMYZSH}"
    exit 0
)}
