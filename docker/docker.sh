pre_install() {
    export GOPATH="${PATH_GOLANG}"
    "${MAKE_SCRIPT_DIR}/make.sh" install go ${VERBOSE}
}

install() {(
    set -e
    pacman -S --noconfirm --needed docker
    # the following shit fails to auto build so i'm preventing exiting
    # the current subshell by always exiting with 0 from the subshell in
    # which it executes
    (go get github.com/docker/docker-credential-helpers || exit 0)
    cd ${GOPATH}/src/github.com/docker/docker-credential-helpers
    make secretservice
    cp ./bin/docker-credential-secretservice "${PATH_DOCKER_SECRET_SERVICE}"
    cd -
    rm -rf ./docker-credential-helpers
    exit 0
)}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install docker "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install docker "${SUDO_USER}" ${VERBOSE}
    systemctl enable docker.service
    exit 0
)}

pre_uninstall() {
    systemctl disable docker.service
}

uninstall() {(
    set -e
    pacman -Rs --noconfirm docker
    rm -rf "${PATH_DOCKER_SECRET_SERVICE}"
    exit 0
)}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall docker "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall docker "${SUDO_USER}" ${VERBOSE}

    "${MAKE_SCRIPT_DIR}/make.sh" uninstall go ${VERBOSE}
    exit 0
)}
