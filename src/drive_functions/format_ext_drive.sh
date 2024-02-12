function format_ext_drive {
debug "skip formatting variable = $skip_formatting"
if [[ $skip_formatting == true ]] ; then return 0 ; fi

#quit if internal drive chosen
if [[ $1 == "Bitcoin" && $drive == "internal" ]] ; then return 0 ; fi
if [[ $1 == "Fulcrum" && $drive_fulcrum == "internal" ]] ; then return 0 ; fi
if [[ $1 == "electrs" && $drive_electrs == "internal" ]] ; then return 0 ; fi
debug "passed internal drive choice"


#Check if external drive selected for other programs, and warn user.
if [[ $justFormat != true ]] ; then
debug "in not justFormat"

#parenteses added once for readability, but not required as && takes precedence over || ,so logic doesn't change
if [[ ( $1 == "Bitcoin" && $drive == "external" ) && ( $drive_fulcrum == "external" || $drive_electrs == "external" ) ]] ; then 
debug "confirm format, if, #1"
confirm_format "Bitcoin" || skip_formatting=true
fi

if [[ ( $1 == "Fulcrum" && $drive_fulcrum == "external" ) && ( $drive == "external" || $drive_electrs == "external" ) ]] ; then 
debug "confirm format, if, #2"
confirm_format "Fulcrum" || skip_formatting=true
fi

if [[ ( $1 == "electrs" && $drive_electrs == "external" ) && ( $drive == "external" || $drive_fulcrum == "external" ) ]] ; then 
debug "confirm format, if, #3"
confirm_format "electrs" || skip_formatting=true
fi

debug "check external drive selected for other programs done.
skip formatting is = $skip_formatting"

if [[ $skip_formatting == true || $bitcoin_drive_import == true ]] ; then 
    return 0 
    else
    format_warnings #skip_formatting can be changed here

    if [[ $install_bitcoin_variable == true && $skip_formatting == true ]] ; then
        if [[ $OS == Mac ]] ; then
            if ! diskutil list | grep -q parmanode ; then 
            driveproblem=true
            fi
        elif [[ $OS == Linux ]] ; then
            if ! sudo lsblk -o label | grep -q "parmanode" || ! sudo blkid | grep -q "parmanode" ; then
            driveproblem=true
            fi
        fi
        if [[ $driveproblem == true ]] ; then
            unset driveproblem
            non_parmanode_drive_warning "Bitcoin" || return 1 #quit installtion
            return 0 #if skip formatting, and drive not parmanode, continue on with installation even though problems.
        fi
    fi
    # Skipping formatting, and a parmanode drive exists.
    if [[ $skip_formatting == true ]] ; then
    return 0
    fi
    # Skip formatting  must be false - carry on with format...
fi



fi #end not justFormat
unset justFormat


detect_drive || return 1 #alternative (better) way to get $disk variable, and exported.

unmount   #Need drive not to be mounted in order to wipe and format.

if [[ $1 != Bitcoin ]] ; then #cancelling dd for bitcoin installation. To slow and not necessary.
if [[ $1 != justFormat ]] ; then
    dd_wipe_drive  
fi
fi



#Format the drive
if [[ $OS == "Mac" ]] ; then
        export disk_no_s=$(echo $disk | grep -oE 'disk[0-9]+' | tr -d '[:space:]') 
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

        partition_drive 
        debug "after partition drive"

        # The following function is redundant, but added in case the dd function (which
        # calls this function earlier is discarded). 
        remove_parmanode_fstab
        
        # Formats the drive and labels it "parmanode" - uses standard linux type, ext4
        sudo mkfs.ext4 -F -L "parmanode" $disk 
        sudo blkid >/dev/null ; sleep 1 #need to refresh
        debug "pause. after format. check label made."

        #Extract the *NEW* UUID of the disk and write to config file.
        get_UUID || return 1
        parmanode_conf_add "UUID=$UUID"
        write_to_fstab "$UUID"
        debug "after write_to_fstab"

        # Mounting... Make the mount directory, mount the drive, set the permissions,
        # and label drive (Last bit is redundant)
        if [[ ! -e $parmanode_drive ]] ; then sudo mkdir -p $parmanode_drive ; fi
        sudo mount $disk $parmanode_drive 
        if ! mountpoint $parmanode_drive >/dev/null ; then announce "Drive didn't mount. There may be problems." ; fi
        sudo chown -R $USER:$(id -gn) $parmanode_drive 
        sudo e2label $disk parmanode >/dev/null || sudo exfatlabel $disk parmanode >/dev/null 2>&1

        debug "label done"
        set_terminal
        echo -e "
#######################################################################################

    If you saw no errors, then the new $green$disk$orange drive has been prepared and is 
    labelled as \"parmanode\".
    
    The drive's UUID, for reference only, is $green$UUID$orange.

########################################################################################
        "
        enter_continue
fi
return 0
}


function confirm_format {
#return 1 necessary because function failure sets skip_formatting variable to true in calling  function
if [[ $importdrive == true ]] ; then return 1 ; fi

while true ; do
clear ; echo -e "
########################################################################################

    Parmanode has detected that you previously have chosen this external drive for
    programs other than $1 

    Please confirm if you want to format the drive?
$red
            y)      Yes, format it. Format it good.
$green
            n)      Nooooo. Skip formating
$orange
            a)      Abort everything

########################################################################################
"
choose "xpmq"
read choice
case $choice in
q|Q) exit 0 ;; a|A|p|P|m|M) back2main ;;  
y|Y) return 0 ;;
n|N) return 1 ;;
*) invalid ;;
esac
done
}


function non_parmanode_drive_warning {
while true ; do
set_terminal ; echo -e "
########################################################################################

    You have selected an internal drive for $1 and then to not format a drive.

    Parmanode has not detected any Parmanode configured drive connected to the
    computer. If you proceed, Bitcoin will be installed, but it won't be able to
    start. You can still go head and 'import' a parmanode drive later, or choose
    to bring in a new drive later from the Parmanode Bitcoin menu.

    Keep going with installation?
$red
                         y)   Yeah, I know what I'm doing
$green 
                         n)   No, abort.

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; n|N|No|NO|p|P|a|A) return 1 ;; m|M) back2main ;; y|Y|yes|YES) break ;;
*) invalid ;;
esac
done

}