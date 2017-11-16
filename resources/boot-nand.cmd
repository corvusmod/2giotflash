setenv ubiargs "ubi.mtd=1"
setenv rootdev "ubi0:nandroot"
setenv rootfstype "ubifs"

setenv bootargs "${ubiargs} ${mtdparts} root=${rootdev} rootwait rootfstype=${rootfstype} console=ttyS0,921600 panic=10 consoleblank=0 loglevel=8 ${extraargs} ${extraboardargs}"

ubifsload ${initrd_addr} "/boot/uInitrd"
ubifsload ${kernel_addr} "/boot/zImage"
ubifsload ${modem_addr} "/boot/modem.bin"

mdcom_loadm ${modem_addr}
mdcom_check 1

bootz ${kernel_addr} ${initrd_addr}

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot-nand.cmd /boot/boot-nand.scr
