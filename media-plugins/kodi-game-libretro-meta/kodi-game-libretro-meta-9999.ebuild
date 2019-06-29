# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Meta package for various kodi-game-libretro implementations"
HOMEPAGE=""
LICENSE="metapackage"
SLOT="0"
IUSE="+2048 +4do +beetle-psx bnes +bsnes bsnes-cpp98 citra craft +desmume dolphin easyrpg +fbalpha fbalpha2012 fceumm +gambatte +genplus \
+handy mame mame2000 +mame2003 mame2016 mednafen-gba +mednafen-ngp +mednafen-pce-fast \
+mednafen-saturn mednafen-snes +mednafen-vb +mednafen-wswan melonds meowpc98 meteor +mgba mrboom +mupen64plus +nestopia +nxengine \
openlara pcsx-rearmed +mednafen-supergrafx parallel-n64 picodrive +ppsspp +prboom +prosystem px68k quicknes redream +reicast sameboy +scummvm \
snes9x snes9x2002 snes9x2010 +stella tgbdual +tyrquake vba-next vbam yabause"

KEYWORDS=""

RDEPEND="2048? ( >=media-plugins/kodi-game-libretro-twentyfortyeight-9999 )
		4do? ( >=media-plugins/kodi-game-libretro-4do-9999 )
		bnes? ( >=media-plugins/kodi-game-libretro-bnes-9999 )
		bsnes? ( >=media-plugins/kodi-game-libretro-bsnes-9999 )
		fbalpha? ( >=media-plugins/kodi-game-libretro-fbalpha-9999 )
		fbalpha2012? ( >=media-plugins/kodi-game-libretro-fbalpha2012-9999 )
		fceumm? ( >=media-plugins/kodi-game-libretro-fceumm-9999 )
		gambatte? ( >=media-plugins/kodi-game-libretro-gambatte-9999 )
		genplus? ( >=media-plugins/kodi-game-libretro-genplus-9999 )
		handy? ( >=media-plugins/kodi-game-libretro-handy-9999 )
		mame2000? ( >=media-plugins/kodi-game-libretro-mame2000-9999 )
		mame2003? ( >=media-plugins/kodi-game-libretro-mame2003-9999 )
		melonds? ( >=media-plugins/kodi-game-libretro-melonds-9999 )
		meteor? ( >=media-plugins/kodi-game-libretro-meteor-9999 )
		mgba? (  >=media-plugins/kodi-game-libretro-mgba-9999 )
		mrboom? ( >=media-plugins/kodi-game-libretro-mrboom-9999 )
		mupen64plus? ( >=media-plugins/kodi-game-libretro-mupen64plus-9999 )
		nestopia? ( >=media-plugins/kodi-game-nestopia-9999 )
		nxengine? ( >=media-plugins/kodi-game-nxengine-9999 )
		snes9x2002? ( >=media-plugins/kodi-game-libretro-snes9x2002-9999 )
		prboom? ( >=media-plugins/kodi-game-libretro-prboom-9999 )
		prosystem? ( >=media-plugins/kodi-game-libretro-prosystem-9999 )
		quicknes? ( >=media-plugins/kodi-game-libretro-quicknes-9999 )
		sameboy? ( >=media-plugins/kodi-game-libretro-sameboy-9999 )
		scummvm? ( >=media-plugins/kodi-game-libretro-scummvm-9999 )
		snes9x? ( >=media-plugins/kodi-game-libretro-snes9x-9999 )
		snes9x2010? ( >=media-plugins/kodi-game-libretro-snes9x2010-9999 )
		stella? ( >=media-plugins/kodi-game-libretro-stella-9999 )
		tgbdual? ( >=media-plugins/kodi-game-libretro-tgbdual-9999 )
		tyrquake? ( >=media-plugins/kodi-game-libretro-tyrquake-9999 )
		vba-next? ( >=media-plugins/kodi-game-libretro-vba-next-9999 )
		vbam? ( >=media-plugins/kodi-game-libretro-vbam-9999 )
		yabause? ( >=media-plugins/kodi-game-libretro-yabause-9999 )"
DEPEND=""
