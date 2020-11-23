#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../shell-utils/util.sh"
. "${SCRIPT_DIR}/../paths.sh"

pre_install() {
    export GOPATH="${PATH_GOLANG}"
    "${SCRIPT_DIR}/../go/go.sh" install ${VERBOSE}
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
    "${SCRIPT_DIR}/docker_config.sh" install --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/docker_config.sh" install --for-user "${SUDO_USER}" ${VERBOSE}
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
    "${SCRIPT_DIR}/docker_config.sh" uninstall --for-user "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${SCRIPT_DIR}/docker_config.sh" uninstall --for-user "${SUDO_USER}" ${VERBOSE}

    "${SCRIPT_DIR}/../go/go.sh" uninstall ${VERBOSE}
    exit 0
)}

usage() {
    print_msg "Usage: ${0} <install | uninstall> [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task pre_install
            perform_task install 'installing docker'
            perform_task post_install
            ;;
        "uninstall")
            perform_task pre_uninstall
            perform_task uninstall 'uninstalling docker'
            perform_task post_uninstall
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
