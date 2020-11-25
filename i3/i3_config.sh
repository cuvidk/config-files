install() {(
    set -e
    mkdir -p "$(dirname ${PATH_I3_CONFIG})"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/i3/config/config" "${PATH_I3_CONFIG}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_I3_CONFIG}"
}
