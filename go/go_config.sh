install() {(
    set -e
    mkdir -p "$(dirname ${PATH_GO_PROFILE})"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/go/config/go.sh" "${PATH_GO_PROFILE}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_GO_PROFILE}"
}
