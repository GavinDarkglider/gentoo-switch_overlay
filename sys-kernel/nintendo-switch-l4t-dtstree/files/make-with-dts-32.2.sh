#!/bin/bash

NVIDIA_VER="32.2"

## GCC-8 fix - The Set the new GCC-8 errors to warnings (Gcc-7 does not search for this bugs)
## Check if known at the first
MY_CFLAGS="-Wno-error=stringop-truncation -Wno-error=stringop-overflow "
MY_ERROR="$(LC_ALL=C gcc -E ${MY_CFLAGS} - < /dev/null 2>&1 >/dev/null| grep error)"

if [ -z "$MY_ERROR" ]; then
	export KCFLAGS+=${MY_CFLAGS}
	echo "Use KCFLAGS=\"$MY_CFLAGS\" for GCC-8 compatibility"
fi

## use distcc if found
if [ -x /usr/bin/distcc ]; then
	MY_DISTCC="CC=distcc gcc"
	echo "Use CC='distcc gcc'"
fi

## Be more tollerant
export KCFLAGS+="-Wno-error=unused-variable -Wno-error=memset-elt-size"
echo "Use KCFLAGS='$KCFLAGS'"

## Note: the source needs to be in /usr/src/nintendo-switch-l4t-dtstree-"$NVIDIA_VER"
## /usr/src contain a symlink to the kernel to be selecteable with eselect krenel
make tegra-dtstree="/usr/src/nintendo-switch-l4t-dtstree-"$NVIDIA_VER"/hardware/nvidia/" "$MY_DISTCC" "$@"
