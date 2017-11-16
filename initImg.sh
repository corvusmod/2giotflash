#!/bin/bash
OFFSET_BOOT=2097152 # fdisk -l xxx.img (boot partition offset ) * 512
OFFSET_DATA=69206016 # fdisk -l xxx.img (data partition offset ) * 512
TMP_DIR="$(mktemp -d)"
IMG_DIR="$2"

mkdir "$IMG_DIR/image/"
IMG_DIR="$IMG_DIR/image/"

# Copy data
mount -o loop,offset=$OFFSET_DATA "$1" "$TMP_DIR"
cp -R "$TMP_DIR/." "$IMG_DIR/"
umount "$1"

# Copy boot data
mount -o loop,offset=$OFFSET_BOOT "$1" "$TMP_DIR"
cp -R "$TMP_DIR/." "$IMG_DIR/boot"
umount "$1"

# Remove not needed TMP_DIR
rmdir "$TMP_DIR"

# Remove data to shrink final image
rm -rf "$IMG_DIR/var/backup/"**
rm -rf "$IMG_DIR/var/cache/"**
rm -rf "$IMG_DIR/var/lib/apt/lists/"**
rm -rf "$IMG_DIR/var/log/"**
rm -rf "$IMG_DIR/var/tmp/"**
rm -rf "$IMG_DIR/usr/share/doc/"**
rm -rf "$IMG_DIR/usr/share/man/"**

# Add nand bootloader
cp "./resources/boot-nand.cmd" "$IMG_DIR/boot/"
cp "./resources/boot-nand.scr" "$IMG_DIR/boot/"

# Remove old bootloaders
rm -f "$IMG_DIR/boot/boot.cmd"
rm -f "$IMG_DIR/boot/boot.scr"

# Copying custom fstab
cp "./resources/fstab" "$IMG_DIR/etc/"

# Setting root password to orangepi
TMP_SHADOW="$(mktemp)"
perl -pe 's|root:(.*?):(.*)|root:\$5\$AlaMaKot\$HEDfK0ic3HjOhU5vGuoteUmGvS7\.rBP0o.eGqQCYvh9:::::::|' \
		"$IMG_DIR/etc/shadow" > "$TMP_SHADOW"
mv "$TMP_SHADOW" "$IMG_DIR/etc/shadow"

# Setting WiFi
read -p "Set WiFi [y/n]:" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
	read -p "Access Point (SSID):" -r
	AP="$REPLY"
	read -p "Password:" -r -s
	PASSWORD="$REPLY"

	cp "./resources/wifiset.sh" "$IMG_DIR/usr/local/bin"
	echo -e '* * * * *\troot\tsh test -x /usr/local/bin/wifiset.sh || /usr/local/bin/wifiset.sh "'"$AP"'" "'"$PASSWORD"'"' >> "$IMG_DIR/etc/crontab"
fi









