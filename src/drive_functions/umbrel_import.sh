function umbrel_import {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

set_terminal ; echo -e "
########################################################################################
$cyan
                            UMBREL DRIVE IMPORT TOOL
$orange
    This program will convert your Umbrel external drive to a Parmanode drive,
    preserving any Bitcoin block data that you may have already sync'd up.

    The ancillary Umbrel data will be preserved so you can use Parmanode to revert
    the drive back, but no promises are made that it will work. Use reversion at
    your own risk.
$pink
    It's safest to assume the Umbrel data will be lost${orange}. If you have funds in 
    lightning, please make sure all relevant data is backed up.

########################################################################################
"
choose "eq" ; read choice
case $choice in q|Q|P|p) return 1 ;; *) true ;; esac

while true ; do
set_terminal ; echo -e "$pink
########################################################################################

    ARE YOU SURE YOU WANT TO CONTINUE?    y   or   n

########################################################################################
"
read choice
case $choice in n|N) return 1 ;; y|Y) break ;; *) invalid ;; esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please insert the Umbrel drive you wish to import, then hit <enter>.

########################################################################################
"
read 
clear
sync

if [[ $(sudo lsblk | grep umbrel | wc -l) == 1 ]] ; then
export mount_point=$(lsblk | grep umbrel | grep -o /.*$)
mounted=true
break
else
announce "Umbrel drive not detected. <enter> to try again."
continue
mounted=false
fi
done

if [[ $(sudo blkid | grep umbrel | wc -l) == 1 ]] ; then
unset disk 
export disk=$(sudo blkid | grep umbrel | cut -d : -f 1) 
fi

if [[ $mounted == false ]] ; then 
sudo mkdir -p /media/$USER/umbrel
sudo mount $disk /media/$USER/umbrel
export mount_point="/media/$USER/umbrel"
fi

#Mounting should be done.


# Move files

sudo mkdir -p $mount_point/.bitcoin
sudo chown -$ $USER:$USER $mount_point/.bitcoin
cd $mount_point/umbrel/app-data/bitcoin/data/bitcoin/
mv blocks chainstate indexes $mount_point/.bitcoin
sudo chown -R $USER:$USER $mount_point/.bitcoin

# label
sudo e2label $disk parmanode 2>&1

# fstab configuration
if sudo cat /etc/fstab | grep parmanode ; then
while true ; do
set_terminal ; echo "
########################################################################################

    There already seems to be a Parmanode drive configured to auto-mount at system
    boot. You can only have one at a time. Would you like to replace the old one with
    the new drive from Umbrel?

                          y        or        n

########################################################################################
"
choose "x" ; read choice
case $choice in y|Y)
export $(sudo blkid -o export $disk) >/dev/null
delete_line "/etc/fstab" "parmanode"
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >/dev/null 2>&1
break
;;
n|N)
export fstab_setting=wrong
break
;;
*)
invalid ;;
esac
done
fi

# Done

set_terminal ; echo -e "
########################################################################################
$cyan
                                  S U C C E S S ! !    
$orange
    The drive data has been rearranged such that it can be used by Parmanode. It's
    label has been changed from umbrel to parmanode.

    The data can no longer be used by Umbrel - if you reconnect now to Umbrel, it may
    get automatically formated. Be warned.

    If you want to reverse the changes and go back to Umbrel, you can do that from
    the Parmanode Tools menu. Like I said before, no gaurantees.

########################################################################################
" ; enter_continue ; set_terminal

# Info

unset drive ; soucre $HOME/.parmanode/parmanode.conf
if [[ $drive == internal ]] ; then
echo -e "
########################################################################################
$pink
    In order to use this drive with Parmanode, you need to uninstall Bitcoin using
    Parmanode first. You can save any data on the internal drive that you've sync'd.
    
    Then, during the Bitcoin install process, you should choose \"external\" for the 
    drive when prompted. DO NOT choose format. This will ensure the correct symlinks 
    to the drive get set up. 
$orange    
########################################################################################
" ; enter_continue ; set_terminal
fi

if [[ -z $drive ]] ; then
echo -e "
########################################################################################

    In order to user this drive imported form Umbrel, simply installed Bitcoin using
    Parmanode, and select \"external\" drive when prompted. If asked, make sure you 
    choose NOT to format.

########################################################################################
" ; enter_continue ; set_terminal
fi

if [[ $drive == external && $fstab_setting == wrong ]] ; then
while true ; do
echo -e "
########################################################################################

    When you replace the old Parmanode drive with this one, Bitcoin will sync up 
    with the data on this new drive. However, because you chose to not remove the
    old auto-mount configuration for the old drive, when the system boots up, the
    old drive will be expected and Bitcoin will fail to auto start.

    Last chance, remove the old auto-mount setting and use the current drive?

                    y          or          n 

########################################################################################
"
choose "x" ; read choice
set_terminal
case $choice in y|Y)
export $(sudo blkid -o export $disk) >/dev/null
delete_line "/etc/fstab" "parmanode"
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >/dev/null 2>&1
break
;;
n|N)
export fstab_setting=wrong
break
;;
*)
invalid ;;
esac
done
fi

set_terminal ; echo -e "
########################################################################################

    Please note, if you wish to use this new Parmanode drive on a computer different
    to this one, you should \"import\" it again so the auto-mount feature can be
    configured.

    Also if that computer is already syncing to an internal drive, then you'll need
    to uninstall Bitcoin (keep the block data if you want) and re-install with the
    new drive.

########################################################################################
" ; enter_continue

break
done

}