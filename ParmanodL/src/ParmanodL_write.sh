function ParmanodL_write {
#Write image
if [[ $debug == true ]] ; then
	read -p "about to write. y or n" choice
	case $choice in y) write_image ;;
	esac
else
    write_image 
fi
}

function write_image {
#dd the drive
# umount first
detect_microSD #result will be in the form /dev/xxx with no number at the end and stored in disk variable
cd $HOME/ParmanodL
sudo umount ${disk}* >/dev/null 2>&1

# * doesn't work in dd command
file=$(ls 2*.img)
sudo dd if=$file of=/dev/sdb bs=4M status=progress 
sync
}