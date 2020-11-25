install() {(
    set -e
    mkdir -p "$(dirname ${PATH_DOCKER_CONFIG})"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/docker/config/config.json" "${PATH_DOCKER_CONFIG}"
    gpasswd -a "${USER}" docker
    exit 0
)}

uninstall() {
    rm -rf "${PATH_DOCKER_CONFIG}"
}
