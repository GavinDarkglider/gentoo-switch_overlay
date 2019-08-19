#!/bin/sh
if ! [ -x "$(which -q cbfstool 2>/dev/null)" ]; then
	echo "cbfstool is required to update the coreboot. Please install sys-boot/cbfstool"
	exit 1
fi

if [ "$1" == 'help' ] || [ "$1" == '--help' ] || [ "$1" == '-h' ]; then
	echo "Inject u-boot.elf into coreboot.rom file"
	echo "usage: update-coreboot.sh coreboot.rom u-boot.elf"
	echo "if files not specified, the /boot/coreboot.rom and /usr/share/u-boot/u-boot.elf is used"
	exit 0
fi

COREBOOT=${1:-/boot/coreboot.rom}
UBOOT=${2:-/usr/share/u-boot/u-boot.elf}

if ! [ -f "$COREBOOT" ]; then
	echo "$COREBOOT is not a valid file"
	exit 1
fi

if ! [ -f "$UBOOT" ]; then
        echo "$UBOOT is not a valid file"
        exit 1
fi

# Update u-boot in coreboot
echo "cbfstool \"$COREBOOT\" remove -v -n fallback/payload"
cbfstool "$COREBOOT" remove -v -n fallback/payload
echo "cbfstool \"$COREBOOT\" add-payload -v -n fallback/payload  -f \"$UBOOT\" -c lzma"
cbfstool "$COREBOOT" add-payload -v -n fallback/payload  -f "$UBOOT" -c lzma
