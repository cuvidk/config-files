install() {(
    set -e
    mkdir -p "$(dirname ${PATH_LY_CONFIG})"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/ly/config/config.ini" "${PATH_LY_CONFIG}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_LY_CONFIG}"
}
