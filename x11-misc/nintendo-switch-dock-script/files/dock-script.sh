#!/bin/bash

logger  "Run /usr/bin/dock-script.sh"
source "/etc/dock-script.env" || exit 1

if [ -z "$DOCKED_VIDEO" ]; then
	echo "No DOCKED_VIDEO is set, use TV"
	DOCKED_VIDEO="TV"
fi

if [ -z "$DOCKED_AUDIO" ]; then
        echo "No DOCKED_AUDIO is set, use HDMI"
        DOCKED_AUDIO="HDMI"
fi

## No other modes does sense for handheld
HANDHELD_VIDEO="HANDHELD"
HANDHELD_AUDIO="HANDHELD"


function get_display() {
	x="$(basename /tmp/.X11-unix/X*)"
	[[ -z "$x" ]] && return
	echo ":${x#X}" # Return value
}

function get_session_user() {
	DISPLAY=$1
	USER_NAME="$(who | awk -v vt="$DISPLAY" '$0 ~ vt {print $1}')"
	if [ -n "$USER_NAME" ]; then
		echo "$USER_NAME"
	else
		echo root
	fi
}

function get_xauthority() {
	# $1 is user name

	# Check by Xorg commandline
	XAUTHORITY=$(ps -C Xorg -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p')
	[[ -n "$XAUTHORITY" ]] && echo "$XAUTHORITY" && return

	# Check by X commandline
	XAUTHORITY=$(ps -C X -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p')
	[[ -n "$XAUTHORITY" ]] && echo "$XAUTHORITY" && return

	# Check by user $HOME/.Xauthority
	USER_HOME=$(getent passwd "$1" | cut -d: -f6)
	[[ "$USER_HOME"/.Xauthority ]] && echo "$USER_HOME"/.Xauthority & return
}

function get_pulse_server() {
	USER_NAME="$(ps -C pulseaudio -f --no-header | while read a b; do echo $a; break; done)"
	[[ -z "$USER_NAME" ]] && return

	echo "unix:/run/user/$(id -u "$USER_NAME")/pulse/native"
	# echo "127.0.0.1"
}

while true; do
	sleep 1

	DISPLAY="$(get_display)"
	[[ -z "$DISPLAY" ]] && return
	export DISPLAY

	USER_NAME="$(get_session_user "$DISPLAY")"

	XAUTHORITY="$(get_xauthority "$USER_NAME")"
	[[ -z "$XAUTHORITY" ]] && return
	export XAUTHORITY

	export PULSE_SERVER="$(get_pulse_server)"

	if [[ -n "$(xrandr | grep 'DP-0 connected')" ]]; then
		VIDEO="$DOCKED_VIDEO"
		AUDIO="$DOCKED_AUDIO"
	else
		VIDEO="$HANDHELD_VIDEO"
		AUDIO="$HANDHELD_AUDIO"
	fi
xrandr
	logger "dock-script.sh: Set Video to $VIDEO"
	# Connected mode
	case "$VIDEO" in
		HANDHELD)
			xrandr --output DSI-0 --mode 720x1280 --rotate left --primary
			xrandr --output DP-0 --off
			xrandr --fb 1280x720
			xinput enable 6
			;;
		TV)
			xrandr --output DP-0 --auto --primary --scale 1x1
			xrandr --output DSI-0 --off
			xinput disable 6
			;;
		TVLEFT)
			xrandr --output DSI-0 --mode 720x1280 --rotate left --primary
			xrandr --output DP-0 --auto --left-of DSI-0 --scale 1x1
			xinput enable 6
			;;
		TVRIGHT)
			xrandr --output DSI-0 --mode 720x1280 --rotate left --primary
			xrandr --output DP-0 --auto --right-of DSI-0 --scale 1x1
			xinput enable 6
			;;
		MIRROR)
			xrandr --output DSI-0 --mode 720x1280 --rotate left --primary
			xrandr --output DP-0 --auto --same-as DSI-0  --scale-from 1280x720
			xinput enable 6
			;;
	esac

	if [ -n "$PULSE_SERVER" ]; then
		case "$AUDIO" in
			HDMI)
				sudo -u "$USER_NAME" pactl set-card-profile 1 off
				sudo -u "$USER_NAME" pactl set-card-profile 0 output:hdmi-stereo
				;;
			HANDHELD)
				sudo -u "$USER_NAME" pactl set-card-profile 1 HiFi
				sudo -u "$USER_NAME" pactl set-card-profile 0 off
				;;
	   esac
	fi

	break # exit while loop
done

