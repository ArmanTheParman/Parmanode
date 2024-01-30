function import_drive_options {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please choose the type of external drive you wish to use for Parmanode:


                      pp)  Parmanode drive from another or previous installation

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
export importdrive=true
add_drive || return 1

if [[ $OS == "Linux" ]] ; then
        # The following function is redundant, but added in case the dd function (which
        # calls this function earlier is discarded). 
        remove_parmanode_fstab

        #Extract the *NEW* UUID of the disk and write to config file.
        sudo e2label $disk parmanode || sudo exfatlabel $disk parmanode >/dev/null 2>&1
        get_UUID #gets UUID of parmanode label drive
        parmanode_conf_add "UUID=$UUID"
        write_to_fstab "$UUID"
fi
return 0
;;
u|U)
export importdrive=true
export skip_formatting=true
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
export importdrive=true
export skip_formatting=true
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
export importdrive=true
export skip_formatting=true
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