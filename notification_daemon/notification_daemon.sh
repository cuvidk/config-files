install() {
    pacman -S --noconfirm --needed notification-daemon
}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install notification_daemon "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install notification_daemon "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {
    pacman -Rs --noconfirm notification-daemon
}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall notification_daemon "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall notification_daemon "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
