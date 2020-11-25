install() {(
    set -e
    mkdir -p "$(dirname "${PATH_VIM_PROFILE}")"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/vim/config/vim.sh" "${PATH_VIM_PROFILE}"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/vim/config/.vimrc" "${PATH_VIM_CONFIG}"
    mkdir -p "${PATH_VIM_DIR}"
    cp -r "${MAKE_CONFIG_SCRIPT_DIR}/vim/config/colors" "${PATH_VIM_DIR}/colors"
    exit 0
)}

uninstall() {(
    set -e
    rm -rf "${PATH_VIM_CONFIG}"
    rm -rf "${PATH_VIM_PROFILE}"
    rm -rf "${PATH_VIM_DIR}"
    exit 0
)}
