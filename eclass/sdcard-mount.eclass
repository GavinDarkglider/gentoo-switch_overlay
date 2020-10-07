EXPORT_FUNCTIONS pkg_setup pkg_preinst pkg_prerm pkg_postrm

#SDCARD_MOUNT_POINT=/mnt/sdcard1  ###should be provided in make.conf
SDCARD_DESTDIR=/usr/share/sdcard1


sdcard-mount_is_disabled() {
	# Skip things when EROOT is active.
	if [[ ${EROOT:-/} != / ]] ; then
		return 0
	fi

	# If we're only building a package, then there's no need to check things.
	if [[ ${MERGE_TYPE} == buildonly ]] ; then
		return 0
	fi

	# OK, we want to handle things ourselves.
	return 1
}


sdcard-mount_check_status() {
	sdcard-mount_is_disabled && return

	MP="${1}"

	if [[ -z ${MP} ]] ; then
		ewarn "SDCARD_MOUNT_POINT is not set"
		return 0
	fi

	if ! [[ -d ${MP} ]]; then
		eerror "${MP} directory does not exists"
		die "invalid SDCARD_MOUNT_POINT"
	fi

	if [[ -n "$(awk '$2 == "'${MP}'"' < /etc/fstab)" ]]; then
		eerror "${MP} is not in /etc/fstab"
		die "invalid SDCARD_MOUNT_POINT"
	fi

	local procstate=$(awk '$2 == "'${MP}'" { split($4, a, ","); \
		for (i in a) if (a[i] ~ /^r[ow]$/) { print a[i]; break }; exit }' \
		/proc/mounts || die "awk failed")

	if [[ -z ${procstate} ]] ; then
		eerror "${MP} is not mounted."
		eerror "Please mount it and retry."
		die "${MP} not mounted"
	fi

	if [[ ${procstate} == ro ]] ; then
		eerror "${MP} detected as being mounted read only."
		eerror "Please remount it as read-write and retry."
		die "${MP} mounted read-only"
	fi

	return 1
}


sdcard-mount_pkg_setup() {
	unset SDCARD_MOUNT_POINT
	sdcard-mount_is_disabled && return

	# Update setting / override the value in binary package
	SDCARD_MOUNT_POINT="$(portageq envvar SDCARD_MOUNT_POINT)"

	# Check if valid before start merging
	sdcard-mount_check_status "${SDCARD_MOUNT_POINT}"
}


sdcard-mount_pkg_preinst() {
	sdcard-mount_check_status "${SDCARD_MOUNT_POINT}" && return

	einfo "Install files to mounted ${SDCARD_MOUNT_POINT}"
	mkdir -p "${D}/${SDCARD_MOUNT_POINT}"
	cp -a "${D}/${SDCARD_DESTDIR}/." "${D}/${SDCARD_MOUNT_POINT}"
}

sdcard-mount_pkg_prerm() {
	# on de-installation use setting used by installation and stored in database
	sdcard-mount_check_status "${SDCARD_MOUNT_POINT}" && return
	einfo "clearup sceduled for SDCARD_MOUNT_POINT=${SDCARD_MOUNT_POINT}"

	# Create a .keep file, in case it is shadowed at the mount point
	touch "${SDCARD_MOUNT_POINT}"/.keep 2>/dev/null
}

sdcard-mount_pkg_postrm() {
	"${SDCARD_MOUNT_POINT}"/.keep 2>/dev/null
}
