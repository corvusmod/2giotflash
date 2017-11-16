#!/bin/bash
set -euo pipefail
set -x

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

SRC="$SCRIPT_DIR"
DEST_UBI_IMG="$1/ubi.img"

TMP_UBINIZE="$(mktemp)"
echo -e '[nandroot-volume]\n' \
	'mode=ubi\n' \
	'image='"$1"'/nandroot.img\n' \
	'vol_id=0\n' \
	'vol_name=nandroot\n' \
	'vol_size=480MiB\n' \
	'vol_type=dynamic\n' \
	'vol_alignment=1' > "$TMP_UBINIZE"

ubinize -p 256KiB -m 4096 "$TMP_UBINIZE" -o "$DEST_UBI_IMG"
rm "$TMP_UBINIZE"
