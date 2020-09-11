# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Azamat H. Hackimov <azamat.hackimov@gmail.com>
# Purpose: Unpack Nixstaller archives (http://nixstaller.sourceforge.net/)
#
# @ECLASS: unpacker-nixstaller.eclass
# @MAINTAINER:
# azamat.hackimov@gmail.com
# @BLURB: helper for unpacking Nixstaller archives
# @DESCRIPTION:
# Some packages comes only in Nixstaller archives (mostly, games), so there
# we come to help unpack them.

inherit unpacker

# @FUNCTION: unpack_nixstaller
# @USAGE: <files to unpack>
# @DESCRIPTION:
# Unpack nixstaller generated files
# They're shell scripts with the blob package tagged onto
# the end of the archive. In the blob placed tarballs with
# actual content.
#
# Please note, if you need additional dependecies make sure to unpack subarch
# archive as first argument.
#
nixstaller_unpack() {
	unpack_makeself

	local unpack_files="$@"

	for i in $unpack_files ; do
		unpack_banner "$i"
		# Make sure that file exists
		[[ -f "./$i" ]] && (
			local type=$(file -b ${i})
			case ${type} in
				data|LZMA*)
					tar -xJf "./$i"
					;;
				gzip*)
					tar -xzf "./$i"
					;;
			esac
		) || die "Failed to unpack $i"
	done
}
