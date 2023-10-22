function safe_unmount_parmanode {

if [[ $(uname) == Darwin ]] ; then no_mac ; return 1 ; fi

if ! mount | grep parmanode ; then
    if [[ $1 == menu ]] ; then
    announce "Drive already seems to not be unmounted."
    fi
return 0
fi

source $HOME/.parmanode/parmanode.conf

if [[ $drive == external ]] ; then
stop_bitcoind
fi
if [[ $drive_fulcrum == external ]] ; then
stop_fulcrum
fi
if [[ $drive_electrs == external ]] ; then
stop_electrs
fi

stop_lnd >/dev/null 2>&1

#Needed to first stop all parmanode programs that might be using the drive
# unmount after everything stopped.

cd ~ ; cd $original_dir
if [[ $OS == Linux ]] ; then sudo umount /media/$USER/parmanode* >/dev/null 2>&1 ; fi
if [[ $OS == Mac ]] ; then diskutil unmountdisk /Volumes/parmanode >/dev/null    ; fi

#TEST 1
if mount | grep parmanode ; then

while true ; do
echo -e "
########################################################################################
    
    Unable to unmount Parmanode drive. What would you like to do?

             a)     Abort and try to unmount the drive yourself.

             f)     Allow Parmanode to attempt to do a \"Force\" unmount.

             s)     Send all your bitcoin to Parman :P

########################################################################################                        
"
choose "xpq" ; read choice ; set_terminal

case $choice in

a|A|p|P) return 1 ;; q|Q) exit ;; 

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