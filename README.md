gentoo-switch_overlay
Info

Repoman status: Build Status

This overlay provides ebuilds for Nintendo Switch gentoo installation. The instructions below document how to add and use this overlay with Portage. (If you prefer to use the overlay differently than below, feel free.)
How to add the overlay

Adding using repos.conf

To add this overlay to Portage in repos.conf, here is example configuration for it:

[gentoo-switch_overlay]
priority = 1
location = /var/lib/layman/gentoo-switch_overlay
sync-type = git
sync-uri = https://github.com/GavinDarkglider/gentoo-switch_overlay.git
auto-sync = yes
clone-depth = 0

See the Gentoo wiki page at https://wiki.gentoo.org/wiki//etc/portage/repos.conf for how to use this. If auto-sync is set to yes, as it is in this example, the repository should be automatically updated when you update your system.
Adding using eselect-repository (not tested)

To add this overlay to Portage using eselect-repository, run eselect repository add gentoo-switch_overlay git https://github.com/GavinDarkglider/gentoo-switch_overlay.git. The repository should be automatically updated when you update your system.

Installation of packages
Should be more simple than it probably is. This is still very much experimental, and most things havnt been tested properly.

Available packages
Mainly stuff that is needed to run l4t on the switch with as much hardware support as possible. A few other things I might decide I want to run on my switch.
Look through the overlay, and see what is there.

Updating packages

Version ebuilds will be updated automatically in the usual manner of installed packages.

Live ebuilds will not be automatically updated when updating your installed packages, but can be updated by running smart-live-rebuild (if that command is not available, it can be installed by running emerge app-portage/smart-live-rebuild).
Getting help

Feel free to leave a bug report on github, and I will see what I can do to fix the issues.
Good luck!
