function ParmanodL_write {
# dd the image to microSD 

sudo umount -f ${disk}* || sudo umount -f /dev/${disk}* 
debug "after umount"

if [[ $OS == Linux ]] ; then
please_wait
sudo dd if="${image_path}" of="${disk_no_part}" bs=2000000 status=progress 
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
sudo dd if="${image_path}" of="${disk_no_part}" bs=2000000 
fi
# will change to dcfldd soon
sync

echo -e "
If there was an error, this is a chance to do stuff in a different
terminal to fix it, then try again.

Options
    $cyan <enter>$orange to continue (everything seems to have worked)
    $cyan r$orange then$cyan <enter>$orange to repeat the 'dd' command 
    $cyan x$orange then$cyan <enter>$orange to abort"
read choice ; set_terminal
case $choice in
r) ParmanodL_write ;;
x) return 1 ;;
*) return 0 ;;
esac
}
