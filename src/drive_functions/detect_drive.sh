#used by add_drive function.
#use by umbrel_import_mac - $1 menu skips initial warning. $2 umbrelmac used for text customisation
function detect_drive {
unset disk
if [[ $1 != menu ]] ; then
if ! echo $@ | grep -q brief ; then
set_terminal ; echo -e "$pink
########################################################################################

    Please pay careful attention here, otherwise you could get drive errors.

########################################################################################
$orange"
enter_continue 
fi
fi

while true ; do


if [[ $1 != menu2 ]] ; then
if [[ $log == "umbrel-mac" ]] ; then umbrel=Umbrel ;fi

if ! echo $@ | grep -q brief ; then
set_terminal ; echo -e "$pink
########################################################################################
    
    Now, please make sure the $umbrel drive you wish to add to Parmanode is 
    ${cyan}DISCONNECTED.$pink Do not disconnect any of your other drives at this time. 
    
    This is important to make sure the drive is detected in the list of drives before 
    and after the connection.
   $cyan 
    Hit <enter> only once this is done.
$pink
########################################################################################
$orange"
read
fi


if [[ $(uname) == Linux ]] ; then
    if sudo lsblk -o LABEL | grep parmanode ; then
    announce "Sorry, but Parmanode detects that a drive with a label parmanode is" \
    "still physically connected to the computer. Aborting." 
    return 1
    fi
elif [[ $(uname) == Darwin ]] ; then
    if diskutil list | grep parmanode ; then
    announce "Sorry, but Parmanode detects that a drive with a label parmanode is" \
    "still physically connected to the computer. Aborting." 
    return 1
    fi
fi

fi #end != menu2

#DETECT BEFORE AND AFTER...

if [[ $(uname) == "Linux" ]] ; then 
    sudo blkid -g >/dev/null
    sudo blkid > $HOME/.parmanode/before
    fi

if [[ $(uname) == "Darwin" ]] ; then
    diskutil list > $HOME/.parmanode/before
    fi


set_terminal ; echo -e "
########################################################################################

    Now go ahead and ${pink}CONNECT$orange the $umbrel drive you wish to use for 
    Parmanode. Do not connect any other drive.

    If a window pops up, a file explorer, you can safely close that.
$cyan
    Wait a few seconds, and if you get a drive error pop-up, click IGNORE 
    before hitting <enter> here.
    $orange
    
    GIVE THE COMPUTER A FEW SECONDS TO NOTICE THE DRIVE BEFORE HITTING ENTER

########################################################################################
"
enter_continue
set_terminal
sleep 2.5

if [[ $(uname) == "Linux" ]] ; then
    sudo blkid -g >/dev/null
    sudo blkid > $HOME/.parmanode/after
    fi

if [[ $(uname) == "Darwin" ]] ; then
    diskutil list > $HOME/.parmanode/after
    fi

if diff -q $HOME/.parmanode/before $HOME/.parmanode/after  >/dev/null 2>&1 ; then
    echo "No new drive detected. DISCONNECT DRIVE and try again. Hit <enter>."
    read ; continue 
fi


if [[ $OS == Mac ]] ; then
    export disk=$(diff -U0 $HOME/.parmanode/before $HOME/.parmanode/after | tail -n2 | grep -Eo disk.+$| tr -d '[:space:]') 
    if [[ -z $disk ]] ; then announce "Error detecting Linux drive. Aborting." ; rm_after_before ; return 1 ; fi
    break
fi

if [[ $OS == Linux ]] ; then
    export disk=$(diff -y $HOME/.parmanode/before $HOME/.parmanode/after | tail -n1 | grep -E '^\s' | grep -oE '/dev/\S+' | cut -d : -f 1 | tr -d '[:space:]')
    if [[ -z $disk ]] ; then announce "Error detecting Linux drive. Aborting." ; rm_after_before ; return 1 ; fi
    break
fi
    
done
rm_after_before
}

