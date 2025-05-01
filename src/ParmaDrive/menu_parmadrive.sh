function menu_parmadrive {
[[ $OS == "Mac" ]] && no_mac && return 1

source $pdc

while true ; do
set_terminal 44

if lsblk | grep -q ParmaDrive ; then #works as long as the internal drive is called ParmanodL not Parmadrive
parmadrive_lockstatus="${green}UNLOCKED" 
locked="unlocked"
else
parmadrive_lockstatus="${red}LOCKED"
locked="locked"
fi

if [[ -n $PARMADRIVE2DEVUUID ]] ; then #if there is a config entry, then it's a 2, not 1 drive system.
    if  lsblk | grep -q ParmaDrive2 ; then 
        parmadrive2_lockstatus="${green}UNLOCKED" 
        locked2="unlocked"
    else
        parmadrive2_lockstatus="${red}LOCKED"
        locked2="locked"
    fi
    encryption_menu="Encryption2:$parmadrive2_lockstatus $blue" #stays even if there is RAID. Other 2-drive variables will be unset with RAID present.


    if sudo mountpoint /srv/parmadrive2 >/dev/null 2>&1 ; then #test 2nd mountpoint for 2 drive system, but unset if a raid.
        mount2="${green}MOUNTED" 
        mounted2="mounted" 
    else 
        mount2="${red}NOT MOUNTED" 
        mounted2="not mounted"
    fi
    mountmenu="\nMountpoint:$cyan /srv/parmadrive2 $mount2 $blue" #unsets if raid exists, code later.
fi

if sudo mountpoint /srv/parmadrive >/dev/null 2>&1 ; then
    mount="${green}MOUNTED" 
    mounted="mounted" 
else 
    mount="${red}NOT MOUNTED" 
    mounted="not mounted"
fi

if grep -q parmaraid-end $ic ; then
    if sudo blkid | grep -q $RAIDUUID ; then
    raid="${green}assembled${blue}"
    raidstatus=assembled
    else
    raid="${green}disassembled${blue}"
    raidstatus=disassembled
    fi
raidmenu="\nRAID is: $raid\n"
unset mountmenu mount2 mounted2
else
unset raidmenu raid raidstatus
fi

if mountpoint /srv/proton_drive ; then proton="${cyan}Proton Drive$green MOUNTED$blue"
else
proton="Proton Drive$red NOT MOUNTED$blue"
fi

clear
echo -e "$blue
########################################################################################$orange
                              EXTERNAL DRIVE MENU$blue
########################################################################################

Mountpoint:$cyan /srv/parmadrive $mount $blue $mountmenu

Encryption: $parmadrive_lockstatus $blue$encryption_menu
$raidmenu
$orange
                       pr)$cyan              ParmaRaid menu
$orange
                   unlock)$cyan              Unlock drive(s)
$orange 
                      key) $cyan             Unlock with USD drive key
$orange
                    mount)           $cyan   Mount Drive
$orange
                  unmount)          $cyan    Unmount Drive 
$orange
                     lock)             $cyan Lock drive(s)
$blue
########################################################################################$orange
                                  Proton Drive$blue
########################################################################################
$proton  

$orange
                        1)$cyan              Mount Proton
$orange
                        2)$cyan              Unmount Proton
$blue
########################################################################################
"
choose xpmq ; read choice ; clear
jump $choice
case $choice in q|Q|exit) exit ;; p|P) return 1 ;; m|M) back2main ;;

pr)
[[ -z $raid ]] && invalid && continue

menu_parmaraid
;;

unlock)
if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive" "2" "ParmaDrive2" ; then
! sudo blkid | grep -q $PARMADRIVE1DEVUUID && announce_blue "Expected drive not detected, trying to unlock anyway..."
clear
sudo cryptsetup open UUID=$PARMADRIVE1DEVUUID ParmaDrive || sww
else
! sudo blkid | grep -q $PARMADRIVE2DEVUUID && announce_blue "Expected drive not detected, trying to unlock anyway..."
clear
sudo cryptsetup open UUID=$PARMADRIVE2DEVUUID ParmaDrive2 || sww

fi
;;
key)
keydev=$(readlink -f /dev/disk/by-id/$USBKEYBYID)
! sudo blkid | grep -q $keydev && announce_blue "Expected USB Key device not detected. Trying anyway."

if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive" "2" "ParmaDrive2" ; then
clear ; echo -e "${blue}Attempting to unlock ParmaDrive...\n"
sudo blkid | grep -q "$PARMADRIVE1DEVUUID" && {
    sudo dd if=$keydev count=4096 bs=1 | sudo cryptsetup open --key-file=- UUID=$PARMADRIVE1DEVUUID ParmaDrive || sww ; } 
echo ""
else
clear ; echo -e "${blue}Attempting to unlock ParmaDrive2...\n"
sudo blkid | grep -q "$PARMADRIVE2DEVUUID" && {
    sudo dd if=$keydev count=4096 bs=1 | sudo cryptsetup open --key-file=- UUID=$PARMADRIVE2DEVUUID ParmaDrive2 || sww ; } 
echo ""

fi
;;

mount|m)
if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive" "2" "ParmaDrive2" ; then
    [[ $mounted == "mounted" ]] && announce_blue "Already mounted" && continue
    [[ $locked == "locked" ]] && announce_blue "Can't mount a locked drive" && continue
    sudo mount /srv/parmadrive || sww #specify the mountpoint only as it is in fstab
else
    [[ $mounted2 == "mounted" ]] && announce_blue "Already mounted" && continue
    [[ $locked2 == "locked" ]] && announce_blue "Can't mount a locked drive" && continue
    sudo mount /srv/parmadrive2 || sww #specify the mountpoint only as it is in fstab
fi
;;

unmount)
yesorno_blue "Be mindful that unmount won't work if docker is running or if Bitcoin is running.
    Because normally their directories exist on the external hard drive. 
    You need to stop them first.

    If all you want to do is detach the drive safely, it's easier to shut down the computer,
    and then detach the drive.
    
    Continue with unmount now?" || continue

if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive" "2" "ParmaDrive2" ; then
[[ $mounted != "mounted" ]] && announce_blue "Can't unmount a drive that isn't mounted." && continue
sudo umount /srv/parmadrive || sww
else
[[ $mounted2 != "mounted" ]] && announce_blue "Can't unmount a drive that isn't mounted." && continue
sudo umount /srv/parmadrive2 || sww
fi
;;

lock)
[[ $raidstatus == "assembled" ]] && { yesorno_blue "Can't lock a RAID drive if it's assembled. Try anyway?" || continue ; }

if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive" "2" "ParmaDrive2" ; then
[[ $mounted == "mounted" ]] && announce_blue "Can't lock the drive if it's mounted" && continue
sudo cryptsetup luksClose /dev/mapper/ParmaDrive || sww
else
[[ $mounted2 == "mounted" ]] && announce_blue "Can't lock the drive if it's mounted" && continue
sudo cryptsetup luksClose /dev/mapper/ParmaDrive2 || sww
fi
;;

1) 
sudo systemctl start rclone.service
success_blue "Proton Mounted"
;;
2)
sudo systemctl stop rclone.service
success_blue "Proton Unmounted"
;;

"")
continue ;;

*)
invalid
;;
esac
done

}