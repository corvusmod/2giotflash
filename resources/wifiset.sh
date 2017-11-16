#!/bin/bash
ESSID_CURRENT=$(iwconfig wlan0 | grep "$1")
if [ ${#ESSID_CURRENT} -eq 0 ]; then
	if [ -d "/etc/NetworkManager" ]; then
		nmcli device wifi con "$1" password "$2"
	else
		killall wpa_supplicant
		wpa_passphrase "$1" "$2" > /etc/wpa_supplicant.conf
		wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf
		dhclient wlan0
	fi
fi
