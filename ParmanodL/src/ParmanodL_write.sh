function ParmanodL_write {
# dd the image to microSD 

sudo umount -f ${disk}* >/dev/null 2>&1

if [[ $OS == Linux ]] ; then
sudo dd if="${image_path}" of="${disk}" bs=8000000 status=progress 
fi

if [[ $OS == Mac ]] ; then
echo "Flashing the drive with Parmanode OS, please wait..."
sudo dd if="${image_path}" of="${disk}" bs=8000000 
fi

sync
}