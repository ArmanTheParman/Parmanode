function unmount_microSD {
sudo umount -f ${disk}* >$dn 2>&1
}