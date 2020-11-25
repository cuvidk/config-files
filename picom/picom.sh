install() {
    pacman -S --noconfirm --needed picom
}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install picom "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install picom "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm picom
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall picom "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall picom "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
