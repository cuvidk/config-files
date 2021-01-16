#!/bin/sh

VGA1=$(xrandr | grep VGA1 | grep -o connected)
eDP1=$(xrandr | grep eDP1 | grep -o connected)

if [ -n "${eDP1}" -a -n "${VGA1}" ]; then
    # probably laptop with additional VGA cable connected:
    # - turn laptop display off
    # - enable display connected through VGA as main display
    xrandr --output eDP1 --off
    xrandr --output VGA1 --auto
fi
