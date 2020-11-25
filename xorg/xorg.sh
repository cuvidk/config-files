install() {(
    set -e
    pacman -S --noconfirm --needed xorg-server
    pacman -S --noconfirm --needed xorg-xinit
    exit 0
)}

post_install() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" install xorg "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" install xorg "${SUDO_USER}" ${VERBOSE}
    exit 0
)}

uninstall() {(
    set -e
    pacman -Rs --noconfirm xorg-server
    pacman -Rs --noconfirm xorg-xinit
    exit 0
)}

post_uninstall() {(
    set -e
    "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall xorg "${USER}" ${VERBOSE}
    [ -n "${SUDO_USER}" ] && "${MAKE_SCRIPT_DIR}/make_config.sh" uninstall xorg "${SUDO_USER}" ${VERBOSE}
    exit 0
)}
