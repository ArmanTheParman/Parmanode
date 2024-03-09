function parmanode1_fix {

if [[ -d /media/$USER/parmanode1 ]] ; then

sudo umount /media/$USER/parmanode1 && sudo rm -rf /media/$USER/parmanode1

set_terminal ; echo -e "
########################################################################################

    Parmanode has detected a$cyan drive mounting glitch$orange. 

    Let me I help you fix it, my ferend...
    
    Follow the prompts.

    Hit$cyan <enter>$orange to continue...

########################################################################################
"
sudo systemctl stop $drive_programs >/dev/null 2>&1
sudo umount $dp >/dev/null 2>&1
sudo umount /media/$USER/parmanode1 >/dev/null 2>&1
set_terminal ; echo -e "
########################################################################################

    The drive should be unmounted. Now physically disconnected the drive, then
    hit$cyan <enter>$orange to continue...

########################################################################################
"
sudo rm -rf /media/$USER/parmanode* >/dev/null 2>&1
sudo mkdir /media/$USER/parmanode >/dev/null 2>&1
sudo chown -R $USER /media/$USER/parmanode >/dev/null 2>&1
set_terminal ; echo -e "
########################################################################################

    Now connect the drive.

########################################################################################
"
enter_continue

sudo mount -a >/dev/null 2>&1
sleep 1.5

set_terminal ; echo -e "
########################################################################################

    The drive should be mounted now. Carry on...

########################################################################################
"
enter_continue
fi
}