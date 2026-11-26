#!/bin/bash
# gensplash: splashutils' silent splash in the initramfs.
# From dracut 056 (removed in dracut-ng), revived for splashutils 1.6:
# included whenever splashutils was built with it, not only when asked.

# called by dracut
check() {
    # the kernel helper draws the silent splash; it needs USE=fbcondecor
    require_binaries splash_geninitramfs /sbin/fbcondecor_helper || return 1
    [[ -e $dracutsysrootdir/usr/share/splashutils/initrd.splash ]] || return 1
    return 0
}

# called by dracut
depends() {
    return 0
}

# called by dracut
install() {
    local _opts=()
    local _splash_theme
    local _splash_res

    call_splash_geninitramfs() {
        local _out _ret

        _out=$(splash_geninitramfs -c "$1" "${@:2}" 2>&1)
        _ret=$?

        if [[ ${_out} ]]; then
            local IFS='
'
            for line in ${_out}; do
                if [[ ${line} =~ ^Warning ]]; then
                    dwarn "${line}"
                else
                    derror "${line}"
                    ((_ret == 0)) && _ret=1
                fi
            done
        fi

        return ${_ret}
    }

    if [[ ${DRACUT_GENSPLASH_THEME} ]]; then
        # Variables from the environment
        # They're supposed to be set up by e.g. Genkernel in basis of cmdline args.
        # If user set them he/she would expect to be included only given theme
        # rather then all even if we're building generic initramfs.
        _splash_theme=${DRACUT_GENSPLASH_THEME}
        _splash_res=${DRACUT_GENSPLASH_RES}
        [[ ${_splash_res} ]] && _opts+=(-r "${_splash_res}")
    elif [[ ${hostonly} ]]; then
        # Settings from config only in hostonly (its SPLASH_THEME; dracut
        # 056 read a variable the file never sets, so always "default")
        # shellcheck disable=SC1090
        [[ -e $dracutsysrootdir/etc/conf.d/splash ]] && _splash_theme=$(
            source "$dracutsysrootdir"/etc/conf.d/splash && echo "${SPLASH_THEME}")
        [[ ! ${_splash_theme} ]] && _splash_theme=default
        _splash_res=${DRACUT_GENSPLASH_RES}
        [[ ${_splash_res} ]] && _opts+=(-r "${_splash_res}")
    else
        # generic
        _splash_theme=--all
    fi

    dinfo "Installing Gentoo Splash (using the ${_splash_theme} theme)"

    pushd "${initdir}" > /dev/null || return 1
    mv dev dev.old
    call_splash_geninitramfs "${initdir}" "${_opts[@]}" ${_splash_theme} || {
        derror "Could not build splash"
        rm -rf dev
        mv dev.old dev
        popd > /dev/null
        return 1
    }
    rm -rf dev
    mv dev.old dev
    popd > /dev/null || return 1

    inst_multiple -o chvt
    inst /usr/share/splashutils/initrd.splash /lib/gensplash-lib.sh
    inst_hook pre-pivot 90 "${moddir}"/gensplash-newroot.sh
    inst_hook pre-trigger 10 "${moddir}"/gensplash-pretrigger.sh
    inst_hook emergency 50 "${moddir}"/gensplash-emergency.sh
}
