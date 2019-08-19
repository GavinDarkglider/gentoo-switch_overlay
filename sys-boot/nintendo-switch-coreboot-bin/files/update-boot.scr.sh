#!/bin/sh

if ! [ -x "$(which -q mkimage 2>/dev/null)" ]; then
	echo "mkimage is required to update the boot.scr. Please install dev-embedded/u-boot-tools"
	exit 1
fi

if [ "$1" == 'help' ] || [ "$1" == '--help' ] || [ "$1" == '-h' ]; then
	echo "Update boot.scr file after boot.txt editing"
	echo "usage: update-boot.scr.sh boot.txt boot.scr"
	echo "if files not specified, the /etc/nintendo-switch-boot.txt and /boot/boot.scr is used"
	exit 0
fi

TXTFILE=${1:-/etc/nintendo-switch-boot.txt}
SCRFILE=${2:-/boot/boot.scr}

if ! [ -f "$TXTFILE" ]; then
	echo "$TXTFILE is not a valid file"
	exit 1
fi

echo "mkimage -A arm -T script -O linux -d \"$TXTFILE\" \"$SCRFILE\""
mkimage -A arm -T script -O linux -d "$TXTFILE" "$SCRFILE"
