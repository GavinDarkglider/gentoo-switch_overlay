#!/bin/bash

WIFI_DEVICE="wlan0" #I add net.ifnames=0 to kernel command line, if you do not, this will be randomly generated

case $1/$2 in
  pre/*)
    #hack to fix power button wake, doesnt work if you have power adapter
    #Computer attached, but.....
    if [ -f /tmp/wake.txt ]; then
      rm /tmp/wake.txt
      echo "Cancelled"
    fi
    ;;
  post/*)
    #Fix clock from hwclock
    hwclock
    #Fix Wifi, needs to be tested without this hack with network manager
    /etc/init.d/net.${WIFI_DEVICE} restart
    rfkill unblock wlan
    #Hack to fix power button wake
    if [ ! "$(dmesg | grep "Resume caused by PMC" | tail -1 | grep WAKE51)" = "" ]; then
      echo 1 > /tmp/wake.txt
    fi
    ;;
esac
