function import_drive_options {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please choose the type of external drive you wish to use for Parmanode:


                      pp)  Pre-existing Parmanode drive 

                      u)   Umbrel drive

                      rb)  RaspiBlitz drive

                      my)  MyNode drive

########################################################################################                
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit ;; q|P) return 1 ;;
m|M) back2main ;;
pp|Pp|PP)
export importdrive="true"
export make_label=dont
if [[ $OS == Mac ]] ; then add_drive || return 1 ; fi

if [[ $OS == "Linux" ]] ; then

        detect_parmanode_drive #gets disk variable and ensures only one parmanode label drive connected.

        # The following function is redundant, but added in case the dd function (which
        # calls this function earlier is discarded). 
        remove_parmanode_fstab

        get_UUID #gets UUID of parmanode label drive
        parmanode_conf_add "UUID=$UUID"
        write_to_fstab "$UUID"
        sudo mount $disk $parmanode_drive 
        sudo chown -R $USER:$(id -gn) $parmanode_drive 

fi
return 0
;;
u|U)
export importdrive="true"
export skip_formatting="true"
log "importdrive" "umbrel import"
umbrel_import || return 1
#if parmanode was in fstab, option already to replace with new drive done.
if ! grep -q "parmanode" < /etc/fstab ; then
        get_UUID "$disk" 
        parmanode_conf_add "UUID=$UUID"
        write_to_fstab "$UUID"
        
fi
return 0
;;
rb|Rb|RB)
export importdrive="true"
export skip_formatting="true"
log "importdrive" "rpb import"
raspiblitz_import || return 1
#if parmanode was in fstab, option already to replace with new drive done.
if ! grep -q "parmanode" < /etc/fstab ; then
        get_UUID "$disk" 
        parmanode_conf_add "UUID=$UUID"
        write_to_fstab "$UUID"
fi
return 0
;;
MY|My|my)
export importdrive="true"
export skip_formatting="true"
log "importdrive" "mynode import"
mynode_import || return 1
#if parmanode was in fstab, option already to replace with new drive done.
if ! grep -q "parmanode" < /etc/fstab ; then
        get_UUID 
        parmanode_conf_add "UUID=$UUID"
        write_to_fstab "$UUID"
fi
return 0
;;
*) invalid
;;
esac
done
}

function detect_parmanode_drive {
#for linux only

while true ; do
clear
sudo partprobe
if ! sudo blkid | grep -q "parmanode"  ; then
yesorno "Please connect the Parmanode drive you wish to use. If it's already connected,
    Parmanode didn't detect it.

    Try again?" && continue || return 1
fi
return 0
done

[[ $(sudo blkid | grep "parmanode" | wc | awk '{print $1}') == 1 ]] || {
    announce "There either is more than one parmanode drived connected or some other error
    with detecting the drive. Aborting."
    return 1
    }

export disk=$(sudo blkid | grep "parmanode" | cut -d : -f 1)
return 0

}