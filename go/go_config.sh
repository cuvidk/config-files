install() {(
    set -e
    mkdir -p "$(dirname ${PATH_GO_PROFILE})"
    sed "s|PATH_GOLANG|${PATH_GOLANG}|" "${MAKE_CONFIG_SCRIPT_DIR}/go/config/go.sh" >"${PATH_GO_PROFILE}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_GO_PROFILE}"
}
