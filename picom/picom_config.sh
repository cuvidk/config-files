install() {(
    set -e
    mkdir -p "$(dirname "${PATH_PICOM_CONFIG}")"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/picom/config/picom.conf" "${PATH_PICOM_CONFIG}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_PICOM_CONFIG}"
}
