function detect_microSD {
rm_after_before
clear
if [ -z $1 ] ; then name=ParmanodL 
else name=${1}
fi

set_terminal ; echo -e "$pink
########################################################################################

    Please pay careful attention here, otherwise you could get drive errors.

########################################################################################
$orange"
enter_continue 
jump $enter_cont

while true ; do
rm_after_before #just removes files
set_terminal ; echo -e "$pink
########################################################################################

    Please make sure the microSD card for $name is ${cyan}DISCONNECTED.$pink Do not 
    disconnect any of your other drives at this time.
    
    Hit <enter> only once this is done. (q to quit)

########################################################################################
$orange"
read choice

case $choice in 
q|Q) exit ;;
esac

if [[ $(uname) == "Linux" ]] ; then 
    sudo blkid -g >$dn #refreshes
    sleep 1
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
jump $enter_cont
set_terminal
sleep 2.5

if [[ $(uname) == "Linux" ]] ; then
    sudo blkid -g >$dn #refreshes
    sleep 1
    sudo blkid > $HOME/.parmanode/after
    fi

if [[ $(uname) == "Darwin" ]] ; then
    diskutil list > $HOME/.parmanode/after
    fi

if diff -q $HOME/.parmanode/before $HOME/.parmanode/after  >$dn 2>&1 ; then
    echo -e "No new drive detected. Try again. Hit$cyan <enter>.$orange"
    read ; continue 
fi

if [[ $OS == Mac ]] ; then
    export disk=$(diff -U0 $HOME/.parmanode/before $HOME/.parmanode/after | grep -v 'synthesized' | grep -Eo 'dev/disk.+' |  cut -d ' ' -f1) 
    if [[ -z $disk ]] ; then enter_continue "Error detecting Linux drive. Aborting." ; return 1 ; fi
    break
fi

if [[ $OS == Linux ]] ; then
    export disk=$(diff -y $HOME/.parmanode/before $HOME/.parmanode/after | tail -n1 | grep -E '^\s' | grep -oE '/dev/\S+' | cut -d : -f 1 | xargs)
    if [[ -z $disk ]] ; then enter_continue "Error detecting Linux drive. Aborting." ; return 1 ; fi
    break
fi
enter_continue "Something went wrong. Please report to Parman. Error code: 420" && return 1
done

if [[ $OS == Linux ]] ; then
export disk_no_part=$(echo $disk | grep -oE '/dev/[^0-9]+' | xargs)
fi

if [[ $OS == Mac ]] ; then
export disk_no_part=/dev/$(echo $disk | grep -oE 'disk[0-9]+' | xargs)
fi

debug "disk is $disk, disk_no_part is $disk_no_part"
}
