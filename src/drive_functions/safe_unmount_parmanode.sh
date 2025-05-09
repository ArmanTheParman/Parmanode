function safe_unmount_parmanode {

if ! mount | grep parmanode ; then
    if [[ $1 == menu ]] ; then
    announce "Drive already seems to not be mounted."
    fi
export wasntmounted="true"
return 0
fi

source $HOME/.parmanode/parmanode.conf

if [[ $drive == external ]] ; then
stop_bitcoin
fi
if [[ $drive_fulcrum == external ]] ; then
stop_fulcrum
fi
if [[ $drive_electrs == external ]] ; then
stop_electrs
fi

stop_lnd 

#Needed to first stop all parmanode programs that might be using the drive
# unmount after everything stopped.

cd ~ ; cd $pn
if [[ $OS == Linux ]] ; then sudo umount /media/$USER/parmanode* >$dn 2>&1 ; fi
if [[ $OS == Mac ]] ; then diskutil unmountdisk /Volumes/parmanode* >$dn 2>&1  ; fi

#TEST 1
if mount | grep parmanode ; then

while true ; do
echo -e "
########################################################################################
    
    Unable to unmount Parmanode drive. What would you like to do?
$cyan
             a)$orange     Abort and try to unmount the drive yourself.
$cyan
             f)$orange     Allow Parmanode to attempt to do a 'Force' unmount.
$cyan
             s)$orange     Send all your bitcoin to Parman :P $green (recommended)$orange

########################################################################################                        
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
a|A|p|P) return 1 ;; 
f|F) 
sudo umount -F $parmanode_drive ; break ;; #exit test 1 , works on mac too

s|S) set_terminal ; announce "Parman's great great grandchildren will thank you in advance." \
"Donations here: https://armantheparman.com/donations" 
continue
;;
*) invalid ;;
esac
done

else
announce "Drive unmounted."
return 0
fi

# TEST 2
if mount | grep parmanode ; then
announce "Force unmount failed too. Sorry mate, I'm out of ideas."
return 1
else
announce "Drive unmounted."
return 0
fi
}