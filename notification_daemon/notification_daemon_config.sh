install() {(
    set -e
    mkdir -p "$(dirname ${PATH_NOTIFICATION_DAEMON_CONFIG})"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/notification_daemon/config/org.freedesktop.Notifications.service" "${PATH_NOTIFICATION_DAEMON_CONFIG}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_NOTIFICATION_DAEMON_CONFIG}"
}
