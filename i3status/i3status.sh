install() {
    pacman -S --noconfirm --needed i3status
}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install i3status "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install i3status "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm i3status
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall i3status "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall i3status "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
