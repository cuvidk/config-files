install() {(
    set -e
    mkdir -p "$(dirname "${PATH_KITTY_PROFILE}")"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/kitty/config/kitty.sh" "${PATH_KITTY_PROFILE}"
    mkdir -p "$(dirname "${PATH_KITTY_CONFIG}")"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/kitty/config/kitty.conf" "${PATH_KITTY_CONFIG}"
    exit 0
)}

uninstall() {(
    set -e
    rm -rf "${PATH_KITTY_CONFIG}"
    rm -rf "${PATH_KITTY_PROFILE}"
    exit 0
)}
