#!/bin/bash
OFFSET_BOOT=2097152 # fdisk -l xxx.img (boot partition offset ) * 512
OFFSET_DATA=69206016 # fdisk -l xxx.img (data partition offset ) * 512
TMP_DIR="$(mktemp -d)"
IMG_DIR="$2"

mkdir -p "$IMG_DIR/image/"
IMG_DIR="$IMG_DIR/image/"

# Copy data
echo "Mounting rootfs"
sudo mount -o loop,offset=$OFFSET_DATA "$1" "$TMP_DIR"
sudo cp -R "$TMP_DIR/." "$IMG_DIR/"
sudo umount "$TMP_DIR"

# Copy boot data
echo "Mounting boot"
sudo mount -o loop,offset=$OFFSET_BOOT "$1" "$TMP_DIR"
sudo cp -R "$TMP_DIR/." "$IMG_DIR/boot"
sudo umount "$TMP_DIR"

# Remove not needed TMP_DIR
echo "Remove temp folder"
sudo rmdir "$TMP_DIR"

# Remove data to shrink final image
echo "Cleaning"
sudo rm -rf "$IMG_DIR/var/backup/"**
sudo rm -rf "$IMG_DIR/var/cache/"**
sudo rm -rf "$IMG_DIR/var/lib/apt/lists/"**
sudo rm -rf "$IMG_DIR/var/log/"**
sudo rm -rf "$IMG_DIR/var/tmp/"**
sudo rm -rf "$IMG_DIR/usr/share/doc/"**
sudo rm -rf "$IMG_DIR/usr/share/man/"**

# Add nand bootloader
echo "Adding bootloader"
sudo cp "./resources/boot-nand.cmd" "$IMG_DIR/boot/"
sudo cp "./resources/boot-nand.scr" "$IMG_DIR/boot/"

# Remove old bootloaders
echo "More cleaning"
sudo rm -f "$IMG_DIR/boot/boot.cmd"
sudo rm -f "$IMG_DIR/boot/boot.scr"

# Copying custom fstab
echo "New fstab"
sudo cp "./resources/fstab" "$IMG_DIR/etc/"

# Setting root password to orangepi
TMP_SHADOW="$(mktemp)"
sudo perl -pe 's|root:(.*?):(.*)|root:\$5\$AlaMaKot\$HEDfK0ic3HjOhU5vGuoteUmGvS7\.rBP0o.eGqQCYvh9:::::::|' \
		"$IMG_DIR/etc/shadow" > "$TMP_SHADOW"
sudo mv "$TMP_SHADOW" "$IMG_DIR/etc/shadow"

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
