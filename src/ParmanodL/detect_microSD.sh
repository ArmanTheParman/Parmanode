function detect_microSD {
if [ -z $1 ] ; then name=ParmanodL 
else name=${1}
fi

set_terminal ; echo -e "$pink
########################################################################################

    Please pay careful attention here, otherwise you could get drive errors.

########################################################################################
$orange"
enter_continue 

while true ; do
rm_after_before #just removes files
set_terminal ; echo -e "$pink
########################################################################################

    Please make sure the microSD card for $name is ${cyan}DISCONNECTED.$pink Do not 
    disconnect any of your other drives at this time.
    
    Hit <enter> only once this is done.

########################################################################################
$orange"
read

if [[ $(uname) == "Linux" ]] ; then 
    sudo blkid -g >/dev/null
    sudo blkid > $HOME/.parmanode/before
    fi

if [[ $(uname) == "Darwin" ]] ; then
    diskutil list > $HOME/.parmanode/before
    fi

set_terminal ; echo -e "
########################################################################################

    Now go ahead and ${pink}CONNECT$orange the microSD you wish to use for $name. Do not 
    connect any other drive/device.

    If a window pops up, a file explorer, you can safely close that.
$cyan
    Wait a few seconds if on a Mac, and if you get a drive error pop-up, click IGNORE 
    before hitting <enter> here.
    $orange
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
    echo "No new drive detected. Try again. Hit <enter>."
    read ; continue 
fi

if [[ $OS == Mac ]] ; then
    export disk=$(diff -U0 $HOME/.parmanode/before $HOME/.parmanode/after | tail -n2 | grep -Eo disk.+$)
    if [[ -z $disk ]] ; then announce "Error detecting Linux drive. Aborting." ; rm_after_before ; return 1 ; fi
    break
fi

if [[ $OS == Linux ]] ; then
    export disk=$(diff -y $HOME/.parmanode/before $HOME/.parmanode/after | tail -n1 | grep -E '^\s' | grep -oE '/dev/\S+' | cut -d : -f 1 | tr -d '[:space:]')
    if [[ -z $disk ]] ; then announce "Error detecting Linux drive. Aborting." ; rm_after_before ; return 1 ; fi
    break
fi
    
done

if [[ $OS == Linux ]] ; then
export disk_no_part=$(echo $disk | grep -oE '/dev/[^0-9]+' | tr -d '[:space:]')
fi

if [[ $OS == Mac ]] ; then
export disk_no_part=$(echo $disk | grep -oE 'disk[0-9]+' | tr -d '[:space:]')
fi

rm_after_before

debug "disk is $disk, disk_no_part is $disk_no_part"
}
