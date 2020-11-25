install() {
    pacman -S --noconfirm --needed i3-gaps
}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install i3 "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install i3 "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm i3-gaps
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall i3 "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall i3 "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
