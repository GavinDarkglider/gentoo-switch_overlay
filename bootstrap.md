# Bootstrap Gentoo using QEMU

## Summary

Gentoo is a source based distribution which requires an existing Linux system for the initial system setup. Usually a live-medium is used, Gentoo-Live-DVD or any other Linux Live Disk, is used for this step.

The following instructions describes how to install Gentoo for Nintendo Switch using crossdev environment and qemu emulator using common amd64 Gentoo workstation.

The switchroot kernel is still in old version 4.9 that results in incompatibilities with newer packages. particularly the sys-libs/glibc needs stay on version 2.35 that is masked in portage already.
Since the official stage3 packages does contain newer version and glibc downgrade is not possible, we need to build our @system from scratch using crossdev.


## Prerequisite

**Important Note:**  This document expect that you use **Gentoo on your PC to build Gentoo for your Switch**.

lot of storage space avalaible on your PC, depending on your target system size.


# Set up the Buildhost

As mentioned above, the host should be a gentoo system.

The switch overlay is important for many steps, so it should be checkout at the first. I do it in `/projects/switch_overlay`

```sh
git clone https://gitlab.com/bell07/gentoo-switch_overlay /projects/switch_overlay
```

## Installing crossdev

The crossdev toolchain need the same old version numbers like the target system.

 - Linux Headers: 4.9 like the switchroot kernel
 - Glibc: 2.35 is for kernel 5.19, but I did not noticed issues with them. Maybe we need to go to more older version
- Gcc: 11 for old glibc compatibility

Before setup check the curent versions for packages that you like to use. In my case I use 

- sys-kernel/linux-headers-4.9-r1
- sys-devel/gcc-11.5.0
- sys-libs/glibc-2.35-r11

Then build the toolchain for this versions:

```sh
emerge crossdev
crossdev -S --kernel 4.9-r1 --libc 2.35-r11 --gcc 11.5.0 -t aarch64-unknown-linux-gnu
```

If the toolchain is built, the toolchain packages are fixed to the given versions. To enable small updates if available (optional), the keywords and masks can be adjusted in `/etc/portage/package.accept_keywords/cross-aarch64-unknown-linux-gnu`
and `/etc/portage/package.mask/cross-aarch64-unknown-linux-gnu`

My settings are:
```sh
cross-aarch64-unknown-linux-gnu/binutils arm64 -amd64 -~amd64 # Stable version for arm64 only
=cross-aarch64-unknown-linux-gnu/gcc-11* arm64 -amd64 -~amd64 # Stable 11* version for arm64 only
=cross-aarch64-unknown-linux-gnu/linux-headers-4.9* ~arm64 -amd64 -~amd64  # Testing 4.9* version for arm64 only. There is no stable version :-(
=cross-aarch64-unknown-linux-gnu/glibc-2.35* arm64 -amd64 -~amd64  # Stable 2.35* version for arm64 only
cross-aarch64-unknown-linux-gnu/gdb arm64 -amd64 -~amd64 # Do not use it, but stable preferred
```

```sh
>cross-aarch64-unknown-linux-gnu/gcc-12
>cross-aarch64-unknown-linux-gnu/linux-headers-4.10
>cross-aarch64-unknown-linux-gnu/glibc-2.36
```


## Configure the crossdev build environment
If cross-emerge is used, some build-time dependencies are installed into `/usr/aarch64-unknown-linux-gnu`. This folder does have own portage configuration, that should be set to Switch-compatible settings.

Crete the file `/usr/aarch64-unknown-linux-gnu/etc/portage/repos.conf/switch_overlay.conf` to enable the the switch overlay

```sh
[switch]
location = /projects/switch_overlay
```

Set the overlay profile `switch_overlay:nintendo_switch/23.0/`

```sh
ln -svf /projects/switch_overlay/profiles/nintendo_switch/23.0/ /usr/aarch64-unknown-linux-gnu/etc/portage/make.profile
```

Edit `/usr/aarch64-unknown-linux-gnu/etc/portage/make.conf`: 
Remove USE, CFLAGS, CXXFLAGS lines. We use the settings from overlay profile. Set ACCEPT_KEYWORDS to your preference.
Optional: Remove features "buildpkg". It is beter to generate packages in chroot

## Optional: Replace the linux-headers in crossdev to the switch-version

Check the symlink `ls -l /var/db/repos/crossdev/cross-aarch64-unknown-linux-gnu/linux-headers`
Replace this symlink that should point to the switch_overlay version.

```sh
ln -svf /projects/switch_overlay/sys-kernel/linux-headers /var/db/repos/crossdev/cross-aarch64-unknown-linux-gnu/linux-headers`
```

Adjust the version in `/etc/portage/package.accept_keywords/cross-aarch64-unknown-linux-gnu`
and `/etc/portage/package.mask/cross-aarch64-unknown-linux-gnu`, then downgrade cross-aarch64-unknown-linux-gnu/linux-headers to 9999* version and rebuild the glibc.

```sh
emerge -vp =cross-aarch64-unknown-linux-gnu/linux-headers-9999* cross-aarch64-unknown-linux-gnu/glibc
```

Unsure if needed, I did it some times ago. I enabled the switch overlay in my host's portage, just to have all ebuilds available for host. Of course without any profiles activations.
All ebuilds in switch overlay are aarch64 only ant therefore masked on amd64 by missing keyword.


## Installing QEMU on host

The official [Gentoo Howto](https://wiki.gentoo.org/wiki/Embedded_Handbook/General/Compiling_with_qemu_user_chroot)

In a nutshell:

1. Check that `CONFIG_BINFMT_MISC` is set in your Kernel config.

2. QEMU needs to be compiled with `static-user` USE-flag and the Switch-compatible target `aarch64` :

```sh
echo 'app-emulation/qemu static-user' > /etc/portage/package.use/qemu
echo 'QEMU_USER_TARGETS="aarch64"' >> /etc/portage/make.conf
emerge app-emulation/qemu
```

3. The service `/etc/init.d/qemu-binfmt start` needs to be started in order for binfmt_misc to be able to register QEMU binaries for other architectures.

4. The trick is to copy `/usr/bin/qemu-aarch64` to an aarch64 root filesystem like `/gentoo-switch/usr/bin/qemu-aarch64` before execution. This way you can chroot into this root filesystem like you would with root filesystem of the same architecture. Extraction binary package is NOT necessary.


## Installing distcc on host

To speed up compilation times I recommend to use cross-compilation with distcc. Using this setup (crossdev+distcc) is advised to move compiling tasks away from compiler in emulation to native cross-compiler on host.

Distcc shares CPU load between multiple devices within the same network 

```sh
emerge distcc
```

Then, add `--allow 127.0.0.0/24"` in `/etc/conf.d/distccd` to DISTCCD_OPTS.

`/etc/init.d/distccd` needs to be started.

### Optional: Enable cross-distcc for llvm/clang compiler

To enable cross-compiling in clang, set `USE=llvm_targets_AArch64` in make conf, or use the expand LLVM_TARGETS as you need. Recompile `llvm-core/clang` and `llvm-core/llvm` with the newly set USE flags.

Gentoo does not set up cross-distcc configuration for clang yet. See https://bugs.gentoo.org/651908. To enable this feature, some symlinks are required. Please use [bell07's fix-clang-distcc.sh](https://github.com/bell07/bashscripts-switch_gentoo/blob/master/tools/fix-clang-distcc.sh) to create this links.
This step needs to be repeated each llvm/clang upgrade.


# Prepare the the target system skeleton
Because no up-to date stage3 is available for older glibc, we start with empty folder and build the stage from scratch.
For simplicity I create an folder `/gentoo-switch` This folder will contain target system files, I can use as buildhost or just to copy into root partition on SD-Card later.
But at the first I go into this folder and create some folders, special /dev and portage configuration files as skeleton.


```sh
mkdir /gentoo-switch
# Create skeleton folders
mkdir -p /gentoo-switch/{boot,dev,etc,mnt,root,run,sys,proc,usr/bin,usr/lib,usr/lib64}
ln -s usr/bin /gentoo-switch/bin
ln -s usr/bin /gentoo-switch/sbin
ln -s bin /gentoo-switch/usr/sbin
ln -s usr/lib /gentoo-switch/lib
ln -s usr/lib64 /gentoo-switch/lib64

# Minimal devices https://tldp.org/LDP/lfs/LFS-BOOK-6.1.1-HTML/chapter06/devices.html
mknod -m 622 /gentoo-switch/dev/console c 5 1
mknod -m 666 /gentoo-switch/dev/null c 1 3
mknod -m 666 /gentoo-switch/dev/zero c 1 5
mknod -m 666 /gentoo-switch/dev/ptmx c 5 2
mknod -m 666 /gentoo-switch/dev/tty c 5 0
mknod -m 666 /gentoo-switch/dev/tty0 c 4 0
mknod -m 666 /gentoo-switch/dev/tty1 c 4 1
mknod -m 444 /gentoo-switch/dev/random c 1 8
mknod -m 444 /gentoo-switch/dev/urandom c 1 9
chown -v root:tty /gentoo-switch/dev/{console,ptmx,tty}

# Bind-mount hosts folders
mkdir -p /gentoo-switch/var/cache/distfiles
mount -o bind /var/cache/distfiles /gentoo-switch/var/cache/distfiles
mkdir -p /gentoo-switch/var/db/repos/gentoo
mount -o bind /var/db/repos/gentoo /gentoo-switch/var/db/repos/gentoo

# Required for cross and for chroot emerge
mkdir -p /gentoo-switch/usr/share/openpgp-keys
cp -v /usr/share/openpgp-keys/gentoo-release.asc /gentoo-switch/usr/share/openpgp-keys/gentoo-release.asc

# Set switch_overlay:nintendo_switch/23.0/ profile that contain all needed setup
mkdir -p /gentoo-switch/etc/portage/
ln -s /projects/switch_overlay/profiles/nintendo_switch/23.0/ /gentoo-switch/etc/portage/make.profile
```

The switch overlay needs to be enabled by creating the file `/gentoo-switch/etc/portage/repos.conf/switch_overlay.conf`

```sh
[switch]
location = /projects/switch_overlay
sync-type = git
sync-uri = https://gitlab.com/bell07/gentoo-switch_overlay
auto-sync = yes
```

## bootstrap the stage using cross-emerge
```
# Build essential toolchain packages
ROOT=/gentoo-switch PORTAGE_CONFIGROOT=/gentoo-switch CHOST=aarch64-unknown-linux-gnu cross-emerge -uva1 gcc glibc binutils linux-headers

# Build @system
ROOT=/gentoo-switch PORTAGE_CONFIGROOT=/gentoo-switch CHOST=aarch64-unknown-linux-gnu cross-emerge -uva --with-bdeps y @system

```

# Configure the created stage for qemu/chroot

Check the official installation instructions at https://wiki.gentoo.org/wiki/Handbook:PPC/Installation/Base, [https://wiki.gentoo.org/wiki/Handbook:PPC/Installation/System] and [https://wiki.gentoo.org/wiki/Handbook:PPC/Installation/Finalizing] (yea, PPC, there is no ARM documentation yet) for additional settings like timezone or locales.

Read the [switch_overlay/README.md](https://gitlab.com/bell07/gentoo-switch_overlay/-/blob/master/README.md).

## Configuring portage

The path in `/gentoo-switch/etc/portage/repos.conf/switch_overlay.conf` needs to be changed to valid chrooted path `/var/db/repos/switch_overlay`

Do additional bind-mount

```sh
mkdir -p /gentoo-switch/var/db/repos/switch_overlay
mount -o bind /projects/switch_overlay /gentoo-switch/var/db/repos/switch_overlay
```

Create `/gentoo-switch/etc/portage/make.conf` and setup the next parameters :

```sh
FEATURES="$FEATURES -pid-sandbox" # qemu caveat
FEATURES="$FEATURES distcc"       # Distribute compiling to the host crossdev
MAKEOPTS="-j6"                    # Parallel compiling tasks. Maybe other number is optimal for you
```

All other usual settings like CFLAGS are not necessary because they are set within the switch profile provided by the overlay.

See [make.defaults](https://gitlab.com/bell07/gentoo-switch_overlay/-/blob/master/profiles/nintendo_switch/make.defaults) in profile.




## Prepare qemu / chroot

cross-emerge way abowe does have still issues, therefore the best way is to utilize qemu emulator to chroot into the target folder and use emulated "real" emerge.



Copy qemu static binary to `switch-gentoo` to allow binfmt execution:

```sh
cp /usr/bin/qemu-aarch64 /gentoo-switch/usr/bin/
```

Copy `resolv.conf` for DNS resolution in chroot:

```sh
cp --dereference /etc/resolv.conf /gentoo-switch/etc/
```

Mount bind other special device needed for chroot as described in handbook:

```sh
mount --types proc /proc /gentoo-switch/proc
mount --rbind /sys /gentoo-switch/sys
mount --make-rslave /gentoo-switch/sys
mount --rbind /dev /gentoo-switch/dev
mount --make-rslave /gentoo-switch/dev
```

Check the previously bind-mounts

```sh
mount -o bind /var/cache/distfiles /gentoo-switch/var/cache/distfiles
mount -o bind /var/db/repos/gentoo /gentoo-switch/var/db/repos/gentoo
mount -o bind /projects/switch_overlay /gentoo-switch/var/db/repos/switch_overlay
```


# Chroot  and complete stage3

Enter the chroot environment as usual. The qemu should allow you to execute the arm64 binaries.
```sh
chroot /gentoo-switch /bin/bash
env-update
source /etc/profile
```

adjust profile symlink
```sh
eselect profile set switch:nintendo_switch/17.0
```

At the first Insatll distcc inside chroot to speed-up the compiling

```sh
emerge distcc
```

Add your distcc host IP with port number (default port: 3632): `127.0.0.1:3632` to `/etc/distcc/hosts` to send compiling tasks to host distcc cross-compiler trough lo network interface instead of socket file.

Then rebuild world, that is @system + distcc at this time:

```sh
emerge -evaDNj world
```

# Done - Stage 3 is reached!

# Build your own system

List profiles avalaible:

```sh
eselect profile list
```

Select the switch profile avalaible that you wish to use. 

```sh
eselect profile set switch:nintendo_switch/23.0/desktop
```

Verify that the profile has been correctly set:

```sh
emerge --info
```

## Work around DRM compiling issues
Some packages fail to build because of missed drm. In Switch overlay the `x11-libs/libdrm` is patched to not provide `/usr/lib64/libdrm.so.2`. This file is provided by `sys-libs/jetson-tx1-drivers`. To avoid compiling issues just install the drivers package without dependencies at the first.

```sh
emerge -va1 --nodeps jetson-tx1-drivers
```

## Install Switch base system files

Read again the [switch_overlay/README.md](https://gitlab.com/bell07/gentoo-switch_overlay/-/blob/master/README.md).

```sh
emerge -a --autounmask y nintendo-switch-meta
```

Accept the proposed keywords and licenses, let autounmask write the `/etc/portage/package.accept_keywords` and `/etc/portage/package.license` for you.

You should run `etc-update` or `dispatch-conf` to resolve conflict in your config files.

Then try again:

```sh
emerge -a --autounmask y nintendo-switch-meta
```
Configure your system as you need


# Compile and install the kernel

They are 3 ways to get working kernel

 - 1: Use `sys-kernel/nintendo-switch-l4t-kernel` that compiles and install kernel with default configuration.

 - 2: Use `sys-kernel/nintendo-switch-l4t-sources` for old-style manuall compilation in /usr/src

The default configuration is 

```sh
make tegra_linux_defconfig
```

Building as usual with`make`. Installation steps are described in ebuild output.


- 3: Any other way like [https://gitlab.com/switchroot/kernel/l4t-kernel-build-scripts]


# Install to SD-Card in Switch

After all files are build in the world, it is time to move the work to SD-Card for first boot. The best way is to work with Hekate homebrew that is able to format the SD-Card and export as USB Storage..
Before you do anything: Export the SD-Card as USB Storage and **do full backup of all SD-Card content !!!**


### Formatting SD-Card

The SD-Card needs 2x partitions. The first one is FAT32 for bootloader, the second is ext4 or your choice for Gentoo. The best way to format the SD card is directly using Switch and Hekate Homebrew. 


### Install files into VFAT partition

The Files for the VFAT partition are managed by ebuilds too. The files are installed into `/gentoo-switch/usr/share/sdcard1/` So we just need to copy the files.

Export the SD in Hekate as USB-Storage and connect them to the building PC.


```sh
mkdir /mnt/gentoo-switch-vfat
mount -t vfat /dev/sdX1 /mnt/gentoo-switch-vfat
cp -a /gentoo-switch/usr/share/sdcard1/* /mnt/gentoo-switch-vfat
```

Next files are required to boot:
```sh
switchroot/gentoo/bl31.bin
switchroot/gentoo/bl33.bin
switchroot/gentoo/boot.scr
bootloader/ini/L4T-gentoo.ini
```

Gentoo does support the kernel and initramfs files in /boot folder of Gentoo partition. Therefore the files are not listed at this place.

### Install root files
Just format the second partition as you like and copy all files.

```sh
mkdir /mnt/gentoo-switch-ext4
mkfs.ext4 -L switch-gentoo /dev/sdX2
mount /dev/sdX2 /mnt/gentoo-switch-ext4
cp -a /gentoo-switch/* /mnt/gentoo-switch-ext4
```

## Try to boot
For debugging reasons set the `fbconsole=1` in your L4T-gentoo.ini to see what appears.

cross fingers.

If you miss some things or the system does not boot, you can mount the SD-Card and chroot it directly. Just copying the qemu binary to SD-Card as described above.


# Cleanup after installation

If gentoo is up and running on the switch, and you plan to maintain/update your Gentoo on the Switch nativelly in future, you need to cleanup the next settings:

 - remove `FEATURES=-pid-sandbox`. It's for qemu only

 - change the host in `/etc/distcc/hosts` to network IP or disable `FEATURES=distcc`.

 - Remove the x86 binary `/usr/bin/qemu-aarch64` copied into system above
