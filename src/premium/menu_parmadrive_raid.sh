function menu_parmadrive_raid {
[[ $OS == "Mac" ]] && no_mac && return 1
source $pdc

if [[ $DOCKERMOUNT == "external" ]] ; then
makesuredocker="Make sure all docker containers are stopped"

dockerstopmenu="$orange \n\n                          db)$cyan           Why stop Docker and bitcoin?..."
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

if lsblk -o UUID | grep -q "$RAIDLUKSUUID" ; then  
parmadrive1_lockstatus="${green}UNLOCKED" 
locked1="unlocked"
else
parmadrive1_lockstatus="${red}LOCKED"
locked1="locked"
fi

if sudo mountpoint /srv/parmadrive >/dev/null 2>&1 ; then
    mount="${green}MOUNTED" 
    mounted="mounted" 
else 
    mount="${red}NOT MOUNTED" 
    mounted="not mounted"
fi



#RAID assembly
if sudo blkid | grep -q $RAIDUUID ; then
raid="${green}assembled${blue}"
raidstatus=assembled
else
raid="${green}disassembled${blue}"
raidstatus=disassembled
fi
raidmenu="\n            RAID is:      $raid"
unset mountmenu mount2 mounted2

#Protron
if mountpoint /srv/proton_drive ; then proton="Proton Drive:$green MOUNTED$yellow   /srv/proton_drive"
else
proton="Proton Drive:$red NOT MOUNTED$blue"
fi


clear
echo -e "$blue
########################################################################################$orange
                                EXTERNAL DRIVE MENU$blue
########################################################################################


            Encryption:   $parmadrive1_lockstatus $blue$encryption_menu $raidmenu
            Mountpoint:   $mount$yellow   /srv/parmadrive $blue $mountmenu 
            $proton  

$orange
                          pr)$cyan           ParmaRaid Menu...
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
                          mp)$cyan           Mount Proton
$orange
                          up)$cyan           Unmount Proton$dockerstopmenu

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
sudo cryptsetup open UUID=$PARMADRIVE1DEVUUID ParmaDrive1 || swwd 
;;

key)
keydev=$(readlink -f /dev/disk/by-id/$USBKEYBYID)
! lsblk -o  path | grep -q $keydev && announce_blue "Expected USB Key device not detected. Trying anyway."

clear 
echo -e "${blue}Attempting to unlock ParmaDrive1...\n"
sudo dd if=$keydev count=4096 bs=1 | sudo cryptsetup open --key-file=- UUID=$PARMADRIVE1DEVUUID ParmaDrive1 || swwd 
echo ""
;;

mount|mm)

[[ $mounted == "mounted" ]] && announce_blue "Already mounted" && continue
[[ $locked1 == "locked" ]] && announce_blue "Can't mount a locked drive" && continue

if [[ $DOCKERMOUNT == "external" ]] ; then
[[ $(docker ps | wc -l) -gt 1 ]] && { sww "Make sure that Docker is fully stopped before mounting" ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
sudo mount /srv/parmadrive || swwd #specify the mountpoint only as it is in fstab
fi
;;

unmount|um|umm)
[[ $DOCKERMOUNT == "external" ]] && { yesorno_blue "Be mindful that unmount won't work if Docker is running or if Bitcoin is running.
    Because normally their directories exist on the external hard drive. 
    You need to stop them first.

    If all you want to do is detach the drive safely, it's easier to shut down the 
    computer, and then detach the drive.
    
    Continue with unmount now?" || continue ; }

if [[ $DOCKERMOUNT == "external" ]] ; then
[[ $(docker ps 2>$dn | wc -l) -gt 1 ]] && docker ps >$dn 2>&1 && { sww "Make sure that Docker is fully stopped before unmounting. yolo to ignore." ; case $enter_cont in yolo) true ;; *) continue ;; esac ; }
fi

pgrep bitcoin >$dn && { sww "Make sure that bitcoin is fully stopped before unmounting"             
                        case $enter_cont in yolo) true ;; *) continue ;; esac ; }

[[ $DOCKERMOUNT == "external" ]] && sudo unmount /var/lib/docker
sudo umount /srv/parmadrive || { swwd ; continue ; } 
;;

lock)

[[ $mounted == "mounted" ]] && announce_blue "Can't lock the drive if it's mounted" && continue
sudo cryptsetup luksClose /dev/mapper/ParmaDrive1 || swwd
continue
;;

db)
[[ $DOCKERMOUNT == "internal" ]] && continue
 
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
success_blue "Proton Mounted"
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