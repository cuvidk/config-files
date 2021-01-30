#!/bin/sh

MBOARD="$(cat /sys/devices/virtual/dmi/id/board_name)"
MAIN="$(xrandr | grep -m 1 ' connected' | cut -f 1 -d ' ')"
OTHER="$(xrandr | grep ' connected' | grep -v "${MAIN}" | cut -f 1 -d ' ')"

case "${MBOARD}" in
    'VIUU4') # notebook
        [ -n "${OTHER}" ] && xrandr --output "${MAIN}" --off
        prev_output=
        for output in $(echo "${OTHER}"); do
            if [ -z "${prev_output}" ]; then
                xrandr --output "${output}" --off
                xrandr --output "${output}" --auto --primary
            else
                xrandr --output "${output}" --off
                xrandr --output "${output}" --auto --right-of "${prev_output}"
            fi
            prev_output="${output}"
        done
        ;;
    *) # do nothing
        ;;
esac
