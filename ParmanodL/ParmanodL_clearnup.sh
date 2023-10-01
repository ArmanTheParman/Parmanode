function ParmanodL_cleanup {

sudo rm -rf /tmp/mnt
sudo rm -rf $HOME/.parmanodl  #was this needed?
sudo umount -f ${disk}* >/dev/null 2>&1

return 0
}