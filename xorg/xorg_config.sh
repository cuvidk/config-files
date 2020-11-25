install() {(
    set -e
    mkdir -p "$(dirname "${PATH_XORG_TOUCHPAD_CONFIG}")"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/xorg/config/30-touchpad.conf" "${PATH_XORG_TOUCHPAD_CONFIG}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_XORG_TOUCHPAD_CONFIG}"
}
