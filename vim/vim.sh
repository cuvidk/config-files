install() {
    pacman -S --noconfirm --needed vim
}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install vim "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install vim "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm vim
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall vim "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall vim "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
