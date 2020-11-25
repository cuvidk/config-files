install() {
    pacman -S --noconfirm --needed openssh
}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install ssh "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install ssh "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm openssh
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall ssh "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall ssh "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
