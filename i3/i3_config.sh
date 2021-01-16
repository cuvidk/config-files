install() {(
    set -e
    mkdir -p "$(dirname ${PATH_I3_CONFIG})"
    mkdir -p "${PATH_I3_SCRIPTS}"
    sed "s|PATH_I3_SCRIPTS|${PATH_I3_SCRIPTS}|" "${MAKE_CONFIG_SCRIPT_DIR}/i3/config/config" >"${PATH_I3_CONFIG}"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/i3/config/setup_resolution.sh" "${PATH_I3_SCRIPTS}"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_I3_CONFIG}"
    rm -rf "${PATH_I3_SCRIPTS}"
}
