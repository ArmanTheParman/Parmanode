return 0
#doesn't work - issues connecting ext4 drive to mac Docker.
function umbrel_import_mac {
# Variables 
    export local log="umbrel-drive" 
    export mount_point="/tmp/umbrel"
set_terminal ; echo -e "
########################################################################################

  $cyan 
              P A R M A N O D E - Umbrel drive import tool for Macs.
$orange
    This program will convert your Linux Umbrel external drive to make it compatible 
    with Parmanode (Linux), preserving any Bitcoin block data that you may have 
    already sync'd up.

    Note, you can use this Mac to set it up, but the drive will not be available 
    on the Mac for use with Parmanode (That feature is coming soon).

########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q) exit ;; p|P) return 1 ;; esac

set_terminal ; echo "
########################################################################################

    You'll also be asked to remove/insert the Umbrel drive to assist with drive 
    detection.
$cyan
            MAKE SURE TO BEGIN WITH, THE UMBREL DRIVE IS NOT CONNECTED.
   $orange 
########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q) exit ;; p|P) return 1 ;; esac


# Need UID and GID

    UIDGID

# Part 2 dependencies - Macs need Docker
    Macs_need_docker || exit


# Make necessary directories

    sudo mkdir -p $mount_point >/dev/null 2>&1

#GET UMBREL DISK ID...
    
    detect_drive menu || return 1
    # $disk variable (drive ID) extracted
    # drive can't be mounted, it's ext4, but should be connected.

#Mount
# Need Docker functionality here for mounting ext4 drives
    
    ParmanodL_docker_run umbrelmac || { log "$log" "failed at docker_run" ; exit ; }
    ParmanodL_docker_get_binaries || { log "$log" "failed at docker_get_binaries" ; exit ; }
    
# Template from umbrel_import.sh 
########################################################################################################################
cd

umbrel_drive_mods_with_docker || return 1

#Clean-up
########################################################################################
sudo rm -rf /tmp/umbrel
########################################################################################
########################################################################################

# Finished. Info.
set_terminal ; echo -e "
########################################################################################
         $cyan 
                               S U C C E S S !!
             $orange                  
    The drive data has been adjusted such that it can be used by Parmanode. It's
    label has been changed from$cyan umbrel to parmanode${orange}.

    The drive can still be used by Umbrel - swap over at your leisure. 

########################################################################################
" ; enter_continue ; set_terminal

success "Umbrel Drive" "being imported to Parmanode."
}