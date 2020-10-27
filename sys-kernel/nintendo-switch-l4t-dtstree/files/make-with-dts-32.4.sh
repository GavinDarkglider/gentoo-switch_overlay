#!/bin/bash

SLOT="32.4"

## GCC-7 fix - The Set the new GCC-7 errors to warnings
## Check if known at the first
GCC7_CFLAGS=" -Wno-error=unused-variable -Wno-error=memset-elt-size"
GCC7_ERROR="$(LC_ALL=C gcc -E ${GCC7_CFLAGS} - < /dev/null 2>&1 >/dev/null| grep error)"
if [ -z "$GCC7_ERROR" ]; then
	export KCFLAGS+=${GCC7_CFLAGS}
	echo "Use KCFLAGS=\"$GCC7_CFLAGS\" for GCC-7 compatibility"
fi

## GCC-8 fix - The Set the new GCC-8 errors to warnings
## Check if known at the first
GCC8_CFLAGS=" -Wno-error=stringop-truncation -Wno-error=stringop-overflow"
GCC8_ERROR="$(LC_ALL=C gcc -E ${GCC8_CFLAGS} - < /dev/null 2>&1 >/dev/null| grep error)"
if [ -z "$GCC8_ERROR" ]; then
	export KCFLAGS+=${GCC8_CFLAGS}
	echo "Use KCFLAGS=\"$GCC8_CFLAGS\" for GCC-8 compatibility"
fi

## GCC-9 fix - The Set the new GCC-9 errors to warnings
## Check if known at the first
GCC9_CFLAGS=" -Wno-error=packed-not-aligned -Wno-error=missing-attributes -Wno-error=address-of-packed-member -Wno-error=sizeof-pointer-memaccess -Wno-error=tautological-compare -Wno-error=maybe-uninitialized"
GCC9_ERROR="$(LC_ALL=C gcc -E ${GCC9_CFLAGS} - < /dev/null 2>&1 >/dev/null| grep error)"
if [ -z "$GCC9_ERROR" ]; then
	export KCFLAGS+=${GCC9_CFLAGS}
	echo "Use KCFLAGS=\"$GCC9_CFLAGS\" for GCC-9 compatibility"
fi

if [ "$1" == "emake" ]; then
## Called from portage Ebuild
	shift
	emake tegra-dtstree="../hardware/nvidia/" $@
else
	## use distcc if found
	if [ -x /usr/bin/distcc ]; then
		MY_DISTCC="CC=distcc gcc"
		echo "Use CC='distcc gcc'"
	fi

## Note: the source needs to be in /usr/src/nintendo-switch-l4t-dtstree-"$SLOT"
## /usr/src contain a symlink to the kernel to be selecteable with eselect krenel
	make tegra-dtstree="/usr/src/nintendo-switch-l4t-dtstree-"$SLOT"/hardware/nvidia/" "$MY_DISTCC" $@
fi
