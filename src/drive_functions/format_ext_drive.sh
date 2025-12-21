function format_ext_drive {
debug " in format_ext_drive, sf = $skip_formatting"

if [[ $drive == "custom" || $skip_formatting == "true" || $bitcoin_drive_import == "true" ]] ; then return 0 ; fi
debug "bypassed skip_formatting exit"

#quit if internal drive chosen
if [[ $1 == "Bitcoin" && $drive == "internal" ]] ; then return 0 ; fi
if [[ $1 == "Fulcrum" && $drive_fulcrum == "internal" ]] ; then return 0 ; fi
if [[ $1 == "electrs" && $drive_electrs == "internal" ]] ; then return 0 ; fi
if [[ $1 == "electrumx" && $drive_electrumx == "internal" ]] ; then return 0 ; fi
if [[ $1 == "nostr" && $drive_nostr == "internal" ]] ; then return 0 ; fi
debug "passed internal drive choice"


#Check if external drive selected for other programs, and warn user.
if ! [[ $justFormat == "true" ]] ; then
    [[ $parmaview != 1 ]] && format_warnings #skip_formatting can be changed here
    if [[ $skip_formatting == "true" ]] ; then return 0 ; fi
fi ; unset justFormat



if [[ $raid != "true" ]] ; then
    [[ $parmaview != 1 ]] &&  { detect_drive || return 1 ; } #alternative (better) way to get $disk variable, and exported.
else
announce "Please make sure the RAID drive you want to use is mounted now.
    Open a new terminal to do that if you need, and$pink ONLY proceed here
    once it is mounted, or you'll get errors.$orange"
confirm_raid_device || return 1
fi

unmount   # Need drive not to be mounted in order to wipe and format.
          # Should unmount RAID too

if [[ $1 != "Bitcoin" && $1 != "justFormat" && $parmaview != 1 ]] ; then
    dd_wipe_drive  
fi


#Format the drive
if [[ $OS == "Mac" ]] ; then
        export disk_no_s=$(echo $disk | grep -oE 'disk[0-9]+' | xargs)
        set_terminal

        log "bitcoin" "eraseDisk $disk ..."

        if [[ $MacOSVersion_major -gt 10 || ($MacOSVersion_major == 10 && $MacOSVersion_minor -gt 12 ) ]] ; then 
        diskutil eraseDisk APFS "parmanode" /dev/$disk_no_s || log "bitcoin" "failed to eraseDisk"
        else
        diskutil eraseDisk exFAT "parmanode" /dev/$disk_no_s || log "bitcoin" "failed to eraseDisk"   
        fi

        set_terminal ; echo -e "
#######################################################################################

    If you saw no errors, then the $disk drive has been wiped, formatted, mounted, 
    and labelled as \"parmanode\".

#######################################################################################
    "
    enter_continue
    return 0
fi

if [[ $OS == "Linux" ]] ; then

        if [[ $raid != "true" ]] ; then 
        partition_drive 
        debug "after partition drive"
        fi

        remove_parmanode_fstab #(parmaview handled inside function)
        
        # Remove partition number (order of these two lines matters)
            disk=${disk%%[0-9]*} #remove partition number
            debug "disk is now $disk, after removing partition number"

        # Formats the drive and labels it "parmanode" - uses standard linux type, ext4
        if [[ $parmaview != 1 ]] ; then
            sudo mkfs.ext4 -F -L "parmanode" $disk || sww "(\$disk is $disk)"
            sudo tune2fs -m 1 $disk >$dn 2>&1
            sudo e2label $disk parmanode >$dn || sudo exfatlabel $disk parmanode >$dn 2>&1
        else
            sudo /usr/local/parmanode/p4run "format_ext_drive" #also labels
        fi

        blkid >$dn ; sleep 1 ; partprobe #need to refresh

        #Extract the *NEW* UUID of the disk and write to config file.
        get_UUID || return 1
        parmanode_conf_add "UUID=$UUID"
        write_to_fstab "$UUID"
        debug "after write_to_fstab"

        # Mounting... Make the mount directory, mount the drive, set the permissions,
        if [[ ! -e $parmanode_drive ]] ; then sudo mkdir -p $parmanode_drive ; fi

        if [[ $parmaview == 1 ]] ; then
            sudo /usr/local/parmanode/p4run "mount_parmanode" #anticipates that fstab entry exists
        else 
            #sudo mount $disk $parmanode_drive 
            sudo mount /media/$USER/parmanode # anticipates that fstab entry exists
        fi

        if ! mountpoint $parmanode_drive >$dn ; then announce "Drive didn't mount. There may be problems." ; fi
        sudo chown -R $USER:$(id -gn) $parmanode_drive 
        sudo partprobe 2>$dn

        debug 
        announce "If you saw no errors, then the new $green$disk$orange drive has been prepared and is 
        \r    labelled as \"parmanode\".
    
        \r    The drive's UUID, for reference only, is $green$UUID$orange."

fi
return 0
}