function ParmanodL_write {
# dd the image to microSD 

sudo umount -f ${disk}* >/dev/null 2>&1

sudo dd if="${image_path}" of="${disk}" bs=4194304 status=progress 
sync
}