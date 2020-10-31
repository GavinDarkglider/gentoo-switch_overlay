#!/bin/bash

MODULES="brcmfmac"

case $1/$2 in
  pre/*)
    rfkill block bluetooth
    rfkill block wlan

    for M in $MODULES; do
        rmmod $M
    done

    ;;
  post/*)

    for M in $MODULES; do
        modprobe $M
    done

    rfkill unblock bluetooth
    rfkill unblock wlan
    hwclock -s
    ;;
esac
