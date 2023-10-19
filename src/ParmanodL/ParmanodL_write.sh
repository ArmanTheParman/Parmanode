function ParmanodL_write {
# dd the image to microSD 

sudo umount -f ${disk}* >/dev/null 2>&1

if [[ $OS == Linux ]] ; then
please_wait
sudo dd if="${image_path}" of="${disk}" bs=2000000 status=progress 
fi

if [[ $OS == Mac ]] ; then
clear
echo "
Flashing the drive with Parmanode OS. This can take a weirdly long
time with no screen feedback, probably more than 10 minutes. 

Let this be a lesson that you should have been using Linux :P

To get a status snapshot, you can hit <control> T, as many times
as you like.

Please wait...

"
sudo dd if="${image_path}" of="${disk}" bs=2000000 
fi
# will change to dcfldd soon
sync
}
