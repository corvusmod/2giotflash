#!/bin/bash
set -euo pipefail
set -x

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

DEST_ROOT="$1/image"
DEST_FS_IMG="$1/nandroot.img"
MAX_LEB=2000

sudo mkfs.ubifs -e 248KiB -m 4096 -c $MAX_LEB -r "$DEST_ROOT" -o "$DEST_FS_IMG"
