#!/bin/sh

SCRIPT_DIR="$(realpath "$(dirname "${0}")")"
. "${SCRIPT_DIR}/../paths.sh"
. "${SCRIPT_DIR}/../shell-utils/util.sh"

install() {(
    mkdir -p "${PATH_PICOM_CONFIG}"
    cp "${SCRIPT_DIR}/config/picom.conf" "${PATH_PICOM_CONFIG}"
)}

uninstall() {
    rm -rf "${PATH_PICOM_CONFIG}"
}

usage() {
    print_msg "Usage: ${0} [install | uninstall] [--verbose]"
}

main() { 
    setup_verbosity "${@}"

    case "${1}" in
        "install")
            perform_task install 'Installing picom config'
            ;;
        "uninstall")
            perform_task uninstall 'Uninstalling picom config'
            ;;
        *)
            usage
            exit 1
            ;;
    esac

    check_for_errors
}

main "${@}"
