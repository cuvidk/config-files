install() {
    pacman -S --noconfirm --needed go
}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install go "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install go "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm go
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall go "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall go "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
