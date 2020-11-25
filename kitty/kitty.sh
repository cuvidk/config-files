install() {
    pacman -S --noconfirm --needed kitty
}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install kitty "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install kitty "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm kitty
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall kitty "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] &&  "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall kitty "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
