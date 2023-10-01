function ParmanodL_write {
# dd the image to microSD 

sudo umount -f ${disk}* >/dev/null 2>&1

if [[ $OS == Linux ]] ; then
sudo dd if="${image_path}" of="${disk}" bs=4194304 status=progress 
fi

if [[ $OS == Mac ]] ; then
sudo dd if="${image_path}" of="${disk}" bs=4194304 
fi

sync
}