#!/bin/bash
if [ $# -lt 2 ]; then
	echo 'Usage: ./flashImage.sh imageFile.img imageDirectory'
	exit
fi

#Init image to nandroot directory
./initImg.sh "$1" "$2"

# Make ubifs
./mkubifs.sh "$2"

# Create UBI image
./mkubi.sh "$2"

# Flash to device
python3 opi2g_nand_write.py \
-p "/dev/ttyACM0" \
--format-flash \
--pdl1 "./resources/pdl1.bin" \
--pdl2 "./resources/pdl2.bin" \
bootloader:"./resources/u-boot.rda" \
nandroot:"$2/ubi.img"

# Clearing

