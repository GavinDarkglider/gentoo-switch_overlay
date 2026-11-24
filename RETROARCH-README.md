# RetroArch / Libretro packages

This file documents every RetroArch frontend, Libretro core and support package in this overlay.
Cores in the table below have an ebuild that compiles its sources for the Switch target
(CPU-optimised flags, L4T 4.9 kernel compatibility) and are included in `retroarch-meta`.
The sync tool parses the table below and reports these packages as RETROARCH in `classify`.
Packages listed in `README.md` belong to SWITCH-SPECIFIC instead.

| Package | Description |
| --- | --- |
| `games-emulation/azahar` | Azahar libretro core for Nintendo 3DS (optional USE=libretro) |
| `games-emulation/libretro-3dengine` | 3dengine libretro core |
| `games-emulation/libretro-a5200` | a5200 libretro core |
| `games-emulation/libretro-amiarcadia` | amiarcadia libretro core |
| `games-emulation/libretro-atari800` | Atari800 libretro port (Atari 8-bit / 5200) |
| `games-emulation/libretro-b2` | b2 libretro core |
| `games-emulation/libretro-bk` | bk libretro core |
| `games-emulation/libretro-blastem` | BlastEm libretro port (Sega Genesis / Mega Drive) |
| `games-emulation/libretro-bluemsx` | bluemsx libretro core |
| `games-emulation/libretro-boom3` | boom3 libretro core |
| `games-emulation/libretro-bsnes` | bsnes Libretro core for Nintendo SNES / Super Famicom |
| `games-emulation/libretro-bsnes-cplusplus98` | bsnes_cplusplus98 libretro core |
| `games-emulation/libretro-bsnes-mercury-accuracy` | bsnes_mercury_accuracy libretro core |
| `games-emulation/libretro-bsnes-mercury-balanced` | bsnes_mercury_balanced libretro core |
| `games-emulation/libretro-bsnes-mercury-performance` | Performance-focused bsnes-mercury core for Nintendo SNES / Super Famicom |
| `games-emulation/libretro-bsnes2014-performance` | bsnes2014_performance libretro core |
| `games-emulation/libretro-cannonball` | cannonball libretro core |
| `games-emulation/libretro-cap32` | cap32 libretro core |
| `games-emulation/libretro-chailove` | chailove libretro core |
| `games-emulation/libretro-clownmdemu` | clownmdemu libretro core |
| `games-emulation/libretro-common-overlays` | Collection of overlay files for use with RetroArch |
| `games-emulation/libretro-common-shaders` | Collection of commonly used Cg shaders |
| `games-emulation/libretro-craft` | craft libretro core |
| `games-emulation/libretro-crocods` | crocods libretro core |
| `games-emulation/libretro-daphne` | daphne libretro core |
| `games-emulation/libretro-database` | Repository containing cheat code files, content data files, etc. |
| `games-emulation/libretro-desmume` | Port of Nintendo DS emulator DeSmuME to libretro |
| `games-emulation/libretro-dice` | dice libretro core |
| `games-emulation/libretro-dinothawr` | dinothawr libretro core |
| `games-emulation/libretro-dolphin` | Dolphin libretro port |
| `games-emulation/libretro-dosbox-pure` | DOS emulator, built for RetroArch/Libretro aiming for simplicity and ease of use |
| `games-emulation/libretro-dosbox-svn` | dosbox_svn libretro core |
| `games-emulation/libretro-ecwolf` | ecwolf libretro core |
| `games-emulation/libretro-eightyone` | 81 libretro core |
| `games-emulation/libretro-ep128emu-core` | ep128emu_core libretro core |
| `games-emulation/libretro-fbalpha` | fbalpha libretro core |
| `games-emulation/libretro-fbalpha2012` | fbalpha2012 libretro core |
| `games-emulation/libretro-fbalpha2012-cps1` | fbalpha2012_cps1 libretro core |
| `games-emulation/libretro-fbalpha2012-cps2` | fbalpha2012_cps2 libretro core |
| `games-emulation/libretro-fbalpha2012-cps3` | fbalpha2012_cps3 libretro core |
| `games-emulation/libretro-fbalpha2012-neogeo` | fbalpha2012_neogeo libretro core |
| `games-emulation/libretro-fbneo` | fbneo libretro core |
| `games-emulation/libretro-fceumm` | fceumm libretro core |
| `games-emulation/libretro-fixgb` | fixgb libretro core |
| `games-emulation/libretro-fixnes` | fixnes libretro core |
| `games-emulation/libretro-flycast` | Multiplatform Sega Dreamcast emulator |
| `games-emulation/libretro-fmsx` | Port of fMSX to the libretro API |
| `games-emulation/libretro-freechaf` | freechaf libretro core |
| `games-emulation/libretro-freeintv` | FreeIntv libretro port (Mattel Intellivision) |
| `games-emulation/libretro-frodo` | frodo libretro core |
| `games-emulation/libretro-fuse` | A port of the Fuse Unix Spectrum Emulator to libretro |
| `games-emulation/libretro-gambatte` | Gambatte libretro port (Nintendo Game Boy / Game Boy Color) |
| `games-emulation/libretro-gametank` | gametank libretro core |
| `games-emulation/libretro-gearboy` | Gearboy libretro port (Nintendo Game Boy / Game Boy Color) |
| `games-emulation/libretro-gearcoleco` | gearcoleco libretro core |
| `games-emulation/libretro-geargrafx` | geargrafx libretro core |
| `games-emulation/libretro-gearlynx` | gearlynx libretro core |
| `games-emulation/libretro-gearsystem` | Gearsystem libretro port (Sega Master System / Game Gear / SG-1000) |
| `games-emulation/libretro-geartowns` | geartowns libretro core |
| `games-emulation/libretro-genesis-plus-gx` | libretro implementation of Genesis Plus GX. \ |
| `games-emulation/libretro-genesis-plus-gx-wide` | genesis_plus_gx_wide libretro core |
| `games-emulation/libretro-geolith` | geolith libretro core |
| `games-emulation/libretro-glsl-shaders` | Glsl shaders converted by hand from libretro's glsl-shaders repo |
| `games-emulation/libretro-gme` | gme libretro core |
| `games-emulation/libretro-gong` | gong libretro core |
| `games-emulation/libretro-gpsp` | gpsp libretro core |
| `games-emulation/libretro-gw` | gw libretro core |
| `games-emulation/libretro-handy` | Handy libretro port (Atari Lynx) |
| `games-emulation/libretro-info` | Libretro info files required for libretro cores |
| `games-emulation/libretro-jollycv` | jollycv libretro core |
| `games-emulation/libretro-jumpnbump` | jumpnbump libretro core |
| `games-emulation/libretro-lowresnx` | lowresnx libretro core |
| `games-emulation/libretro-lutro` | lutro libretro core |
| `games-emulation/libretro-m2000` | m2000 libretro core |
| `games-emulation/libretro-mame2000` | mame2000 libretro core |
| `games-emulation/libretro-mame2003` | MAME (0.78) for libretro. |
| `games-emulation/libretro-mame2003-midway` | mame2003_midway libretro core |
| `games-emulation/libretro-mame2003-plus` | MAME (0.78) with extra features for libretro |
| `games-emulation/libretro-mame2010` | mame2010 libretro core |
| `games-emulation/libretro-mednafen-gba` | mednafen_gba libretro core |
| `games-emulation/libretro-mednafen-lynx` | mednafen_lynx libretro core |
| `games-emulation/libretro-mednafen-ngp` | Beetle NGP libretro port (SNK Neo Geo Pocket / Pocket Color, Mednafen fork) |
| `games-emulation/libretro-mednafen-pce` | mednafen_pce libretro core |
| `games-emulation/libretro-mednafen-pce-fast` | mednafen_pce_fast libretro core |
| `games-emulation/libretro-mednafen-pcfx` | Standalone port of Mednafen PCFX to libretro |
| `games-emulation/libretro-mednafen-psx` | Beetle PSX: software-rendered Sony PlayStation core |
| `games-emulation/libretro-mednafen-psx-hw` | Beetle PSX HW: hardware-rendered Sony PlayStation core |
| `games-emulation/libretro-mednafen-saturn` | Mednafen Saturn |
| `games-emulation/libretro-mednafen-supafaust` | mednafen_supafaust libretro core |
| `games-emulation/libretro-mednafen-supergrafx` | mednafen_supergrafx libretro core |
| `games-emulation/libretro-mednafen-vb` | Beetle VB libretro port (Nintendo Virtual Boy, Mednafen fork) |
| `games-emulation/libretro-mednafen-wswan` | mednafen_wswan libretro core |
| `games-emulation/libretro-melonds` | melonds libretro core |
| `games-emulation/libretro-meowpc98` | meowpc98 libretro core |
| `games-emulation/libretro-mesen` | mesen libretro core |
| `games-emulation/libretro-mesen-s` | mesen-s libretro core |
| `games-emulation/libretro-meteor` | meteor libretro core |
| `games-emulation/libretro-minivmac` | minivmac libretro core |
| `games-emulation/libretro-mrboom` | mrboom libretro core |
| `games-emulation/libretro-mu` | mu libretro core |
| `games-emulation/libretro-mupen64plus-next` | Improved mupen64plus libretro core reimplementation |
| `games-emulation/libretro-nekop2` | nekop2 libretro core |
| `games-emulation/libretro-neocd` | neocd libretro core |
| `games-emulation/libretro-nestopia` | Nestopia libretro port |
| `games-emulation/libretro-np2kai` | Neko Project II kai libretro port (NEC PC-9801 / PC-9821) |
| `games-emulation/libretro-numero` | numero libretro core |
| `games-emulation/libretro-nxengine` | nxengine libretro core |
| `games-emulation/libretro-o2em` | o2em libretro core |
| `games-emulation/libretro-oberon` | oberon libretro core |
| `games-emulation/libretro-openlara` | openlara libretro core |
| `games-emulation/libretro-opera` | opera libretro core |
| `games-emulation/libretro-parallel-n64` | parallel_n64 libretro core |
| `games-emulation/libretro-pcsx-rearmed` | libretro implementation of PCSX ReARMed. (PlayStation) |
| `games-emulation/libretro-pcsx1` | pcsx1 libretro core |
| `games-emulation/libretro-pd777` | pd777 libretro core |
| `games-emulation/libretro-picodrive` | Fast MegaDrive/MegaCD/32X emulator |
| `games-emulation/libretro-pocketcdg` | pocketcdg libretro core |
| `games-emulation/libretro-pokemini` | pokemini libretro core |
| `games-emulation/libretro-potator` | potator libretro core |
| `games-emulation/libretro-prboom` | libretro implementation of PrBoom. (Doom) |
| `games-emulation/libretro-prosystem` | ProSystem libretro port (Atari 7800) |
| `games-emulation/libretro-puae` | WIP libretro port of UAE (P-UAE and libco), a Commodore Amiga Emulator |
| `games-emulation/libretro-puae2021` | puae2021 libretro core |
| `games-emulation/libretro-px68k` | px68k libretro core |
| `games-emulation/libretro-quasi88` | quasi88 libretro core |
| `games-emulation/libretro-quicknes` | quicknes libretro core |
| `games-emulation/libretro-race` | race libretro core |
| `games-emulation/libretro-radio` | radio libretro core |
| `games-emulation/libretro-reminiscence` | reminiscence libretro core |
| `games-emulation/libretro-remotejoy` | remotejoy libretro core |
| `games-emulation/libretro-retro8` | retro8 libretro core |
| `games-emulation/libretro-same-cdi` | same_cdi libretro core |
| `games-emulation/libretro-sameboy` | Gameboy and Gameboy Color emulator written in C |
| `games-emulation/libretro-sameduck` | sameduck libretro core |
| `games-emulation/libretro-scummvm` | Interpreter for point-and-click adventure games as a libretro core. |
| `games-emulation/libretro-slang-shaders` | Vulkan GLSL RetroArch shaders |
| `games-emulation/libretro-smsplus` | smsplus libretro core |
| `games-emulation/libretro-snes9x2002` | snes9x2002 libretro core |
| `games-emulation/libretro-snes9x2005` | snes9x2005 libretro core |
| `games-emulation/libretro-snes9x2005-plus` | snes9x2005_plus libretro core |
| `games-emulation/libretro-snes9x2010` | snes9x2010 libretro core |
| `games-emulation/libretro-stella2014` | Stella 2014 libretro port (Atari 2600 VCS) |
| `games-emulation/libretro-stella2023` | stella2023 libretro core |
| `games-emulation/libretro-superbroswar` | superbroswar libretro core |
| `games-emulation/libretro-swanstation` | Fast Sony Playstation emulator |
| `games-emulation/libretro-tamalibretro` | tamalibretro libretro core |
| `games-emulation/libretro-tgbdual` | tgbdual libretro core |
| `games-emulation/libretro-theodore` | theodore libretro core |
| `games-emulation/libretro-thepowdertoy` | thepowdertoy libretro core |
| `games-emulation/libretro-tia` | tia libretro core |
| `games-emulation/libretro-tic80` | tic80 libretro core |
| `games-emulation/libretro-twentyfortyeight` | 2048 libretro core |
| `games-emulation/libretro-tyrquake` | libretro implementation of TyrQuake. (Quake) |
| `games-emulation/libretro-uw8` | uw8 libretro core |
| `games-emulation/libretro-uzem` | uzem libretro core |
| `games-emulation/libretro-vaporspec` | vaporspec libretro core |
| `games-emulation/libretro-vba-next` | vba_next libretro core |
| `games-emulation/libretro-vbam` | VBA-M libretro port (Nintendo Game Boy Advance / Game Boy / Game Boy Color) |
| `games-emulation/libretro-vecx` | vecx libretro core |
| `games-emulation/libretro-vemulator` | vemulator libretro core |
| `games-emulation/libretro-vice-x128` | vice_x128 libretro core |
| `games-emulation/libretro-vice-x64` | VICE core for Commodore 64 |
| `games-emulation/libretro-vice-x64sc` | VICE core for Commodore 64 SC (accurate model) |
| `games-emulation/libretro-vice-xcbm2` | vice_xcbm2 libretro core |
| `games-emulation/libretro-vice-xcbm5x0` | vice_xcbm5x0 libretro core |
| `games-emulation/libretro-vice-xpet` | vice_xpet libretro core |
| `games-emulation/libretro-vice-xplus4` | vice_xplus4 libretro core |
| `games-emulation/libretro-vice-xscpu64` | vice_xscpu64 libretro core |
| `games-emulation/libretro-vice-xvic` | vice_xvic libretro core |
| `games-emulation/libretro-video-processor` | video_processor libretro core |
| `games-emulation/libretro-virtualjaguar` | Virtual Jaguar libretro port (Atari Jaguar) |
| `games-emulation/libretro-virtualxt` | virtualxt libretro core |
| `games-emulation/libretro-vitaquake2` | vitaquake2 libretro core |
| `games-emulation/libretro-vitaquake3` | vitaquake3 libretro core |
| `games-emulation/libretro-x1` | x1 libretro core |
| `games-emulation/libretro-xrick` | xrick libretro core |
| `games-emulation/libretro-yabasanshiro` | Sega Saturn Emulated Hardware |
| `games-emulation/libretro-yabause` | Yabause libretro port (Sega Saturn) |
| `games-emulation/mgba` | mGBA Game Boy Advance Emulator (from the Gentoo repository, USE=libretro) |
| `games-emulation/retroarch` | Frontend for emulators, game engines and media players |
| `games-emulation/retroarch-assets` | Assets needed for RetroArch. Also contains the official branding |
| `games-emulation/retroarch-joypad-autoconfig` | RetroArch joypad autoconfig files |
| `games-emulation/retroarch-meta` | Meta package for RetroArch and the Libretro cores |
| `sys-devel/rgbds` | Rednex Game Boy Development System |

## Removed cores

These cores keep their ebuild in the overlay for reference, but are not part of `retroarch-meta`
because their current source does not build for the Switch target (aarch64 or the L4T 4.9 kernel).
The listed version is the last one that was tried; a newer upstream release may add support, in
which case the core can be enabled in the meta package and tested again.

| Core | Last tested version | Date | Reason |
| --- | --- | --- | --- |
| `games-emulation/libretro-amiberry` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-anarch` | `1.0_pre20260831` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-applewin` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-arduous` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-bsnes-jg` | `1.0_pre20261111` | 2026-11-24 | /var/tmp/portage/games-emulation/libretro-bsnes-jg-1.0_pre20261111/work/bsnes-jg-7ed3cf55cbe3e88414d921db88388ec9e60c6db0/jg.cpp:26:10: fatal error: jg/jg.h: No such f... |
| `games-emulation/libretro-cdi2015` | `1.0_pre20261123` | 2026-11-24 | gcc: error: unrecognized command-line option ‘-mlittle-endian’ |
| `games-emulation/libretro-cemu` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-citra` | `1.0_pre20261123` | 2026-11-24 | cat: ./externals/faad2/faad2/properties.json: No such file or directory |
| `games-emulation/libretro-citra2018` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-desmume2015` | `1.0_pre20261123` | 2026-11-24 | src/utils/AsmJit/x86/x86cpuinfo.cpp:140:3: error: impossible constraint in ‘asm’ |
| `games-emulation/libretro-dirksimple` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-dosbox-core` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-easyrpg` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-emuscv` | `1.0_pre20261014` | 2026-11-24 | collect2: error: ld returned 1 exit status |
| `games-emulation/libretro-ffmpeg` | `1.0_pre20200828` | 2026-11-24 | upstream abandoned (no commit since 2020-08-28); aarch64 link fails against incompatible libav API |
| `games-emulation/libretro-fsuae` | `1.0_pre20261123` | 2026-11-24 | ./sources/src/od-fs/sysconfig.h:11:10: fatal error: config.h: No such file or directory |
| `games-emulation/libretro-gam4980` | `1.0_pre20260830` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-hatari` | `1.0_pre20261123` | 2026-11-24 | collect2: error: ld returned 1 exit status |
| `games-emulation/libretro-hatari2014` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-hbmame` | `1.0_pre20261123` | 2026-11-24 | gcc: error: unrecognized command-line option ‘-mlittle-endian’ |
| `games-emulation/libretro-holani` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-irogb` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-jaxe` | `1.0_pre20261123` | 2026-11-24 | src/libretro.c:6:10: fatal error: libretro.h: No such file or directory |
| `games-emulation/libretro-jgenesis` | `1.0_pre20261123` | 2026-11-24 | error: could not compile `proc-macro2` (build script) due to 1 previous error |
| `games-emulation/libretro-kronos` | `1.0_pre20261123` | 2026-11-24 | aarch64-unknown-linux-gnu-gcc: error: unrecognized command-line option ‘-mfpmath=sse’ |
| `games-emulation/libretro-mame` | `1.0_pre20261123` | 2026-11-24 | gcc: error: unrecognized command-line option ‘-mlittle-endian’ |
| `games-emulation/libretro-mame2009` | `1.0_pre20261123` | 2026-11-24 | /cross_root/usr/include/bits/string_fortified.h:29:10: error: ‘__builtin_memcpy’ accessing 199 bytes at offsets 0 and 1 overlaps 198 bytes at offset 1 [-Werror=restrict] |
| `games-emulation/libretro-mame2015` | `1.0_pre20261123` | 2026-11-24 | /cross_root/usr/include/bits/math-vector.h:377:1: error: ‘__sv_f64_t’ does not name a type |
| `games-emulation/libretro-mame2016` | `1.0_pre20261123` | 2026-11-24 | make[2]: ./m68kmake: No such file or directory |
| `games-emulation/libretro-mednafen-bsnes` | `1.0_pre20260823` | 2026-11-24 | ./mednafen/snes/src/lib/nall/string/strl.hpp:25:50: error: redefinition of ‘size_t strlcat(char*, const char*, size_t)’ |
| `games-emulation/libretro-mednafen-snes` | `1.0_pre20261123` | 2026-11-24 | ./mednafen/snes/src/lib/nall/string/strl.hpp:25:50: error: redefinition of ‘size_t strlcat(char*, const char*, size_t)’ |
| `games-emulation/libretro-melondsds` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-mesen2` | `1.0_pre20260604` | 2026-11-24 | aarch64-unknown-linux-gnu-gcc: error: unrecognized command-line option ‘-m64’ |
| `games-emulation/libretro-mess2015` | `1.0_pre20260906` | 2026-11-24 | gcc: error: unrecognized command-line option ‘-mlittle-endian’ |
| `games-emulation/libretro-mojozork` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-omicron` | `1.0_pre20260904` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-openmsx` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-parallel-dc` | `1.0_pre20261123` | 2026-11-24 | core/rend/vulkan/vk_motion_pass.c:155:13: error: conflicting types for ‘free_sized’; have ‘void(void *)’ |
| `games-emulation/libretro-pcem` | `1.0_pre20261123` | 2026-11-24 | 386_dynarec.c:1354:63: error: ‘BLOCK_START’ undeclared (first use in this function) |
| `games-emulation/libretro-pcsx2` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-play` | `1.0_pre20261123` | 2026-11-24 | /var/tmp/portage/games-emulation/libretro-play-1.0_pre20261123/work/Play--884ae3b96c631f235cd18b2643d1f318fa6951fb/deps/CodeGen/src/Jitter_CodeGen_AArch64.cpp:1440:33:... |
| `games-emulation/libretro-rpcs3` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-rustynes` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-simcp` | `1.0_pre20261123` | 2026-11-24 | libretro/libretro-simcp.c:135:16: error: type defaults to ‘int’ in declaration of ‘rload’ [-Wimplicit-int] |
| `games-emulation/libretro-squirreljme` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-stella` | `1.0_pre20261123` | 2026-11-24 | ../../emucore/FBSurface.hxx:450:21: error: ‘const std::string_view’ {aka ‘const class std::basic_string_view<char>’} has no member named ‘contains’ |
| `games-emulation/libretro-stonesoup` | `1.0_pre20140213` | 2026-11-24 | upstream abandoned (no commit since 2014-02-13); x86-only SSE code |
| `games-emulation/libretro-supermodel` | `1.0_pre20260816` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-vircon32` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-vita3k` | `1.0_pre20261124` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-vitavoyager` | `1.0_pre20200102` | 2026-11-24 | upstream abandoned (no commit since 2020-01-02); no aarch64 build |
| `games-emulation/libretro-wasm4` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-xemu` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |
| `games-emulation/libretro-xenia-edge` | `1.0_pre20261123` | 2026-11-24 | build fails for aarch64 |

## Update workflow

When asked to update, use these upstream sources instead of guessing:

- **Active arm64 cores**: `https://buildbot.libretro.com/nightly/linux/aarch64/latest/` -> every
  `<core>_libretro.so.zip` is an officially built core for our target.
- **Core -> upstream repository**: `https://raw.githubusercontent.com/libretro/libretro-super/master/rules.d/core-rules.sh`
  -> lines `libretro_<core>_git_url="https://github.com/..."`. Pin the newest commit with
  `git ls-remote <url> HEAD`, then bump `LIBRETRO_COMMIT_SHA`/PV, regenerate the Manifest and
  validate with `cross-ebuild <package> install`.

A core that disappears from the active list stays in this overlay as long as it still builds;
remove it only on explicit request. A core that cannot be built for aarch64 gets a row in
"Removed cores" with its last tested version and date.
