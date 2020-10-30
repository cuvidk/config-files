#!/bin/sh

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/../shell-utils/util.sh"
. "${WORKING_DIR}/../install_paths.sh"

install() {
    go get github.com/docker/docker-credential-helpers
    cd "${GOPATH}/src/github.com/docker/docker-credential-helpers/"
    make secretservice
    sudo cp ./bin/docker-credential-secretservice /usr/bin
    rm -rf "${GOPATH}/src/github.com/docker/docker-credential-helpers/"
    cd -
}

uninstall() {
    rm -rf /usr/bin/docker-credential-secretservice
}

install_deps() {
    "${WORKING_DIR}/golang.sh" install ${VERBOSE} &&
        export GOPATH="${PATH_GOLANG}"
}

uninstall_deps() {
    sudo rm -rf /usr/bin/docker-credential-secretservice
    "${WORKING_DIR}/golang.sh" uninstall ${VERBOSE}
}

usage() {
    print_msg "Usage: ${0} <install|uninstall>\n"
}

main() {
    sudo ls /etc/shadow >/dev/null
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install_deps
            perform_task install 'Installing docker-secret-service'
            ;;
        "uninstall")
            perform_task uninstall_deps
            perform_task uninstall 'Uninstalling docker-secret-service'
            ;;
        *)
            usage
            exit 1
    esac

    check_for_errors
}

main "${@}"
