install() {(
    set -e
    mkdir -p "$(dirname ${PATH_ZSH_CONFIG})"
    sed "s|ZSH_INSTALL_PATH|${PATH_OHMYZSH}|" "${MAKE_CONFIG_SCRIPT_DIR}/zsh/config/.zshrc" | 
        sed "s|PURE_INSTALL_PATH|${PATH_PURE}|" |
        tee "${PATH_ZSH_CONFIG}"
    chsh -s /usr/bin/zsh "${USER}"
    exit 0
)}

uninstall() {(
    set -e
    rm -rf "${PATH_ZSH_CONFIG}"
    chsh -s /usr/bin/bash "${USER}"
    exit 0
)}
