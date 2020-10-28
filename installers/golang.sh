#!/bin/sh

WORKING_DIR="$(realpath "$(dirname "${0}")")"

. "${WORKING_DIR}/../shell-utils/util.sh"
. "${WORKING_DIR}/../install_paths.sh"

install() {
    sudo pacman -S --needed --noconfirm go
    sudo mkdir -p "${PATH_GOLANG}"
    sudo chown -R "${USER}:${USER}" "${PATH_GOLANG}"
    echo "export GOPATH=${PATH_GOLANG}" | sudo tee "/etc/profile.d/go.sh"
    . /etc/profile.d/go.sh
}

uninstall() {
    sudo pacman -Rs --noconfirm go
    sudo rm -rf /etc/profile.d/go.sh
    sudo rm -rf "${PATH_GOLANG}"
}

usage() {
    print_msg "Usage: ${0} <install|uninstall>\n"
}

main() {
    sudo ls /etc/shadow >/dev/null
    setup_output

    case "${1}" in
        "install")
            perform_task install 'Installing Golang'
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling Golang'
            ;;
        *)
            usage
            exit 1
    esac

    check_for_errors
}

main "${@}"
