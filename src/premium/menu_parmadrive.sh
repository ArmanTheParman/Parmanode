function menu_parmadrive {
[[ $OS == "Mac" ]] && no_mac && return 1
source $pdc

#Newer versions of Parmadrive have Raid first, then encrypt the Raid. This directs them to a different menu
#and those with older version can continue to use this  menu
if [[ -n $RAIDLUKSUUID ]] ; then
    menu_parmadrive_raid || return 1
    return 0
fi

if [[ $DOCKERMOUNT == "external" ]] ; then
makesuredocker="Make sure all docker containers are stopped"
fi

function swwd {
echo -e "    ${blue}Something went wrong. If you keep getting errors, sometimes you just need to
    switch it off an on again.
	
$1	
"
enter_continue
}

while true ; do
set_terminal 42

if [[ -n $PARMADRIVE1LUKSUUID ]] && lsblk -o UUID | grep -qE "$PARMADRIVE1LUKSUUID" ; then  #at least one drive exists, so check it
parmadrive1_lockstatus="${green}UNLOCKED" 
locked1="unlocked"
else
parmadrive1_lockstatus="${red}LOCKED"
locked1="locked"
fi

if [[ -n $PARMADRIVE2DEVUUID ]] ; then #if there is a config entry, then it's a 2 drive, not 1 drive system.
    if  lsblk -o UUID | grep -q $PARMADRIVE2LUKSUUID ; then 
        parmadrive2_lockstatus="${green}UNLOCKED" 
        locked2="unlocked"
    else
        parmadrive2_lockstatus="${red}LOCKED"
        locked2="locked"
    fi
    #extra text for the menu if there is a second drive...
    encryption_menu="Encryption2:$parmadrive2_lockstatus $blue" #stays even if there is RAID. Other 2-drive variables will be unset with RAID present.

    #test 2nd mountpoint for 2 drive system, but later unset if a raid.
    if sudo mountpoint -q /srv/parmadrive2 >/dev/null 2>&1 ; then 
        mount2="${green}MOUNTED" 
        mounted2="mounted" 
    else 
        mount2="${red}NOT MOUNTED" 
        mounted2="not mounted"
    fi

    mountmenu="\nMountpoint:$cyan /srv/parmadrive2 $mount2 $blue" #unsets if raid exists, code later.
fi

if sudo mountpoint -q /srv/parmadrive >/dev/null 2>&1 ; then
    mount="${green}MOUNTED" 
    mounted="mounted" 
else 
    mount="${red}NOT MOUNTED" 
    mounted="not mounted"
fi

if grep -q parmaraid-end $ic ; then

    raidmenuchoice="$orange
                          pr)$cyan           ParmaRaid Menu"

    if sudo blkid | grep -q $RAIDUUID ; then
    raid="${green}assembled${blue}"
    raidstatus=assembled
    else
    raid="${green}disassembled${blue}"
    raidstatus=disassembled
    fi
raidmenu="\n            RAID is:      $raid"
unset mountmenu mount2 mounted2
else
unset raidmenu raid raidstatus
fi

if mountpoint -q /srv/proton_drive ; then proton="Proton Drive:$green MOUNTED$yellow  \033[40G /srv/proton_drive"
else
proton="Proton Drive:$red NOT MOUNTED$blue"
fi

#### delete later
# if [[ $debug == 1 ]] ; then
#     raidmenuchoice="$orange
#                           pr)$cyan           ParmaRaid Menu"
# raidmenu="\n            RAID is: $raid"
# fi

clear
echo -e "$blue
########################################################################################$orange
                                EXTERNAL DRIVE MENU$blue
########################################################################################


            Encryption:   $parmadrive1_lockstatus $blue$encryption_menu $raidmenu
            Mountpoint:   $mount$yellow  \033[40G /srv/parmadrive $blue $mountmenu 
            $proton  

$raidmenuchoice
$orange
                      unlock)$cyan           Unlock drive(s)
$orange 
                         key)$cyan           Unlock with USB drive key
$orange
                       mount)$cyan           Mount Drive
$orange
                     unmount)$cyan           Unmount Drive 
$orange
                        lock)$cyan           Lock drive(s)
$orange
                          db)$cyan           Why stop Docker and bitcoin?...
$orange
                          mp)$cyan           Mount Proton
$orange
                          up)$cyan           Unmount Proton

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

ul|unlock)
#if no d2, then single drive
[[ -z $PARMADRIVE2DEVUUID ]] && { 
    sudo cryptsetup open UUID=$PARMADRIVE1DEVUUID ParmaDrive1 || swwd 
    continue
}


if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive1" "2" "ParmaDrive2" ; then
! sudo blkid | grep -q $PARMADRIVE1DEVUUID && announce_blue "Expected drive not detected, trying to unlock anyway..."
clear
sudo cryptsetup open UUID=$PARMADRIVE1DEVUUID ParmaDrive1 || swwd
else
! sudo blkid | grep -q $PARMADRIVE2DEVUUID && announce_blue "Expected drive not detected, trying to unlock anyway..."
clear
sudo cryptsetup open UUID=$PARMADRIVE2DEVUUID ParmaDrive2 || swwd
fi

;;
key)
keydev=$(readlink -f /dev/disk/by-id/$USBKEYBYID)
! lsblk -o  path | grep -q $keydev && announce_blue "Expected USB Key device not detected. Trying anyway."

[[ -z $PARMADRIVE2DEVUUID ]] && {
    clear 
    echo -e "${blue}Attempting to unlock ParmaDrive1...\n"
    sudo dd if=$keydev count=4096 bs=1 | sudo cryptsetup open --key-file=- UUID=$PARMADRIVE1DEVUUID ParmaDrive1 || swwd 
    echo ""
    continue
}


if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive1" "2" "ParmaDrive2" ; then
clear ; echo -e "${blue}Attempting to unlock ParmaDrive1...\n"
sudo blkid | grep -q "$PARMADRIVE1DEVUUID" && {
    sudo dd if=$keydev count=4096 bs=1 | sudo cryptsetup open --key-file=- UUID=$PARMADRIVE1DEVUUID ParmaDrive1 || swwd ; } 
echo ""
else
clear ; echo -e "${blue}Attempting to unlock ParmaDrive2...\n"
sudo blkid | grep -q "$PARMADRIVE2DEVUUID" && {
    sudo dd if=$keydev count=4096 bs=1 | sudo cryptsetup open --key-file=- UUID=$PARMADRIVE2DEVUUID ParmaDrive2 || swwd ; } 
echo ""

fi
;;

mount|mm)
[[ -n $raidmenu ]] &&  { 
    [[ $(docker ps | wc -l) -gt 1 ]] && { sww "Make sure that Docker is fully stopped before mounting" ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    sudo mount /srv/parmadrive || { swwd ; continue ;}
    sudo mount /var/lib/docker 
    continue
}

[[ -z $PARMADRIVE2DEVUUID ]] && {
    [[ $mounted == "mounted" ]] && announce_blue "Already mounted" && continue
    [[ $locked1 == "locked" ]] && announce_blue "Can't mount a locked drive" && continue
    [[ $(docker ps | wc -l) -gt 1 ]] && { sww "Make sure that Docker is fully stopped before mounting" ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    sudo mount /srv/parmadrive || swwd #specify the mountpoint only as it is in fstab
    continue
}

if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive1" "2" "ParmaDrive2" ; then
    [[ $mounted == "mounted" ]] && announce_blue "Already mounted" && continue
    [[ $locked1 == "locked" ]] && announce_blue "Can't mount a locked drive" && continue
    [[ $(docker ps | wc -l) -gt 1 ]] && { sww "Make sure that Docker is fully stopped before mounting" ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    sudo mount /srv/parmadrive || swwd #specify the mountpoint only as it is in fstab
else
    [[ $mounted2 == "mounted" ]] && announce_blue "Already mounted" && continue
    [[ $locked2 == "locked" ]] && announce_blue "Can't mount a locked drive" && continue
    sudo mount /srv/parmadrive2 || swwd #specify the mountpoint only as it is in fstab
fi
;;

unmount|um|umm)
if docker ps >$dn 2>&1 || bitcoin-cli --version ; then 
    yesorno_blue "Be mindful that unmount won't work if Docker is running or if Bitcoin is running.
    Because normally their directories exist on the external hard drive. 
    You need to stop them first.

    If all you want to do is detach the drive safely, it's easier to shut down the 
    computer, and then detach the drive.
    
    Continue with unmount now?" || continue
fi

[[ -n $raidmenu ]] && { 
    [[ $(docker ps 2>$dn | wc -l) -gt 1 ]] && docker ps >$dn 2>&1 && { sww "Make sure that Docker is fully stopped before unmounting. yolo to ignore." ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    pgrep bitcoin >$dn && { sww "Make sure that bitcoin is fully stopped before unmounting"             ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    sudo unmount /var/lib/docker
    sudo umount /srv/parmadrive || { swwd ; continue ; } 
    continue
}
    
[[ -z $PARMADRIVE2DEVUUID ]] && {
    [[ $mounted != "mounted" ]] && announce_blue "Can't unmount a drive that isn't mounted." && continue
    [[ $(docker ps 2>$dn | wc -l) -gt 1 ]] && { sww "Make sure that Docker is fully stopped before unmounting. yolo to ignore." ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    pgrep bitcoin >$dn && { sww "Make sure that bitcoin is fully stopped before unmounting"             ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    sudo umount /srv/parmadrive || swwd
    continue
}

if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive1" "2" "ParmaDrive2" ; then
[[ $mounted != "mounted" ]] && announce_blue "Can't unmount a drive that isn't mounted." && continue
    [[ $(docker ps 2>$dn | wc -l) -gt 1 ]] && { sww "Make sure that Docker is fully stopped before unmounting. yolo to ignore." ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    pgrep bitcoin >$dn && { sww "Make sure that bitcoin is fully stopped before unmounting"             ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
    sudo umount /srv/parmadrive || swwd
else
[[ $mounted2 != "mounted" ]] && announce_blue "Can't unmount a drive that isn't mounted." && continue
    sudo umount /srv/parmadrive2 || swwd
fi
;;

lock)
[[ $raidstatus == "assembled" ]] && { yesorno_blue "Can't lock a RAID drive if it's assembled. Try anyway?" || continue ; }

[[ -z $PARMADRIVE2DEVUUID ]] && {
    [[ $mounted == "mounted" ]] && announce_blue "Can't lock the drive if it's mounted" && continue
    sudo cryptsetup luksClose /dev/mapper/ParmaDrive1 || swwd
    continue
}

if yesorno_blue "Drive 1 or 2" "1" "ParmaDrive1" "2" "ParmaDrive2" ; then
[[ $mounted == "mounted" ]] && announce_blue "Can't lock the drive if it's mounted" && continue
sudo cryptsetup luksClose /dev/mapper/ParmaDrive1 || swwd
else
[[ $mounted2 == "mounted" ]] && announce_blue "Can't lock the drive if it's mounted" && continue
sudo cryptsetup luksClose /dev/mapper/ParmaDrive2 || swwd
fi
;;

db)
announce_blue "Docker's directory,$cyan /var/lib/docker$blue, is actually a mountpoint to a directory on 
    the external drive. The default location is$cyan /srv/parmadrive/.docker$blue

    If you disconnect the drive and then start Docker, the original directory
    $cyan/var/lib/docker$blue no longer is a mountpoint and continues as data on the internal
    drive. Docker will think it is a fresh install and will not find any of your 
    containers, but it will still run. You will then have 2 copies of /var/lib/docker, 
    one on the internal drive and on on the external drive. If you then mount the 
    external drive's Docker directory to the internal one, then the contents of the 
    internal drive's /var/lib/docker temporarily disappears, with the external drive's
    version mounted on top of it. This all gets confusing.

    This is why the ParmaDrive menu prevents you from making these mistakes, but does
    allow you to yolo override, in case you know better. ParmaDrive cannont anticipate
    every possible scenario so a manual override is possible.
    
    Why was this done? It's to move potentally massive amounts of data off the 
    internal drive and on to the larger external drive, particularly for your 
    NextCloud backups.

    Next, about Bitcoin..."

announce_blue "Similarly with Bitcoin, the internal location is$cyan $HOME/.bitcoin/$blue and within 
    there, there is a massive directory called 'blocks'. This has been moved to

    $cyan/srv/parmadrive/.bitcoin/blocks$blue.

    'blocks' exists as a symplink, not a mountpoint (not the same, but similar):
   $cyan 
        $HOME/.bitcoin/blocks --> /srv/parmadrive/.bitcoin/blocks
$blue
    One difference between mounting and symlinks is that with Docker is that Bitcoin
    won't be able to start without the drive being mounted, because bitcoin will fail
    to write to 'blocks'. It remains pointing to the drive even if the drive is not
    connected."
;;

mp) 
sudo systemctl start rclone-proton.service || { sww && continue ; } 
sleep 3
if mountpoint -q /srv/proton_drive ; then
    success_blue "Proton Mounted"
else
    sww "Type$red force$blue to try a forceful unmount, then try mounting again."
    case $enter_cont in force) fuserumount -u /srv/proton_drive ; sleep 1 ; esac
fi
;;

up)
sudo systemctl stop rclone-proton.service || { sww && continue ; }
sleep 2
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