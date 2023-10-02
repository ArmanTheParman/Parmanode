function ParmanodL_write {
# dd the image to microSD 

sudo umount -f ${disk}* >/dev/null 2>&1

if [[ $OS == Linux ]] ; then
sudo dd if="${image_path}" of="${disk}" bs=2000000 status=progress 
fi

if [[ $OS == Mac ]] ; then
clear
echo "
Flashing the drive with Parmanode OS. This can take a weirdly long
time with no screen feedback, probably more than 10 minutes. 

Let this be a lesson that you should have been using Linux :P

Please wait...

"
sudo dd if="${image_path}" of="${disk}" bs=2000000 
fi

sync
}
