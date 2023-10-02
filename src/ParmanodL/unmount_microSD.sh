function unmount_microSD {
sudo umount -f ${disk}* >/dev/null 2>&1
}