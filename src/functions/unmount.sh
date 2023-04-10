function unmount {
set_terminal
echo " 
Please wait a few seconds for the drive to unmount ... 
"
for i in $(sudo lsblk -nrpo NAME /dev/sdb) ; do sudo umount $i >/dev/null 2>&1 ; done

#redunant but harmless...
sudo umount /dev/$disk >/dev/null 2>&1

sleep 3
set_terminal
return 0
}