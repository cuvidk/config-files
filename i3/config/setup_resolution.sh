#!/bin/sh

MBOARD="$(cat /sys/devices/virtual/dmi/id/board_name)"
MAIN="$(/usr/bin/xrandr | grep -m 1 ' connected' | cut -f 1 -d ' ')"
OTHER="$(/usr/bin/xrandr | grep ' connected' | grep -v "${MAIN}" | cut -f 1 -d ' ')"

case "${MBOARD}" in
    'VIUU4') # notebook
        if [ -n "${OTHER}" ]; then
            /usr/bin/xrandr --output "${MAIN}" --off
        else
            /usr/bin/xrandr --output "${MAIN}" --auto --pos 0x0 --primary
        fi

        prev_output=
        for output in $(echo "${OTHER}"); do
            if [ -z "${prev_output}" ]; then
                /usr/bin/xrandr --output "${output}" --auto --pos 0x0 --primary
            else
                /usr/bin/xrandr --output "${output}" --auto --pos 0x0 --right-of "${prev_output}"
            fi
            prev_output="${output}"
        done
        ;;
    *) # do nothing
        ;;
esac
