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
read
sudo systemctl stop bitcoind fulcrum electrs electrumx >$dn 2>&1
sudo umount $dp >$dn 2>&1
sudo umount /media/$USER/parmanode1 >$dn 2>&1
set_terminal ; echo -e "
########################################################################################

    The drive should be unmounted. Now physically disconnected the drive, then
    hit$cyan <enter>$orange to continue...

########################################################################################
" 
read
sudo rm -rf /media/$USER/parmanode* >$dn 2>&1
sudo mkdir /media/$USER/parmanode >$dn 2>&1
sudo chown -R $USER /media/$USER/parmanode >$dn 2>&1
set_terminal ; echo -e "
########################################################################################

    Now connect the drive.

########################################################################################
"
enter_continue

sudo mount -a >$dn 2>&1
sleep 1.5

set_terminal ; echo -e "
########################################################################################

    The drive should be mounted now. Carry on...

########################################################################################
"
enter_continue
fi
}