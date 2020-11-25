install() {(
    set -e
    mkdir -p "$(dirname ${PATH_SSH_CONFIG})"
    cp "${MAKE_CONFIG_SCRIPT_DIR}/ssh/config/ssh_agent.sh" "${PATH_SSH_CONFIG}"

    # i'm doing this dinamically because I want to append
    # instead of overwritting with a static file
    echo '. ${HOME}/.ssh/ssh_agent.sh' | sudo tee -a "${HOME}/.zprofile"
    exit 0
)}

uninstall() {
    rm -rf "${PATH_SSH_CONFIG}"
}
