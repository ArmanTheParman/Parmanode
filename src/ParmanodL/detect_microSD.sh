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
debug "starting"

while true ; do
set_terminal "pink" ; echo -e "
########################################################################################

    Please make sure the microSD card for $name is ${cyan}DISCONNECTED.$pink Do not 
    disconnect any of your other drives at this time.
    
    Hit <enter> only once this is done.

########################################################################################
"
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

disk_after=$(grep . $HOME/.parmanode/after | tail -n1 ) 
# grep . filters out empty lines
disk_before=$(grep . $HOME/.parmanode/before | tail -n1 )

    if [[ "$disk_after" == "$disk_before" ]] ; then 
        echo "No new drive detected. Try again. Hit <enter>."
            read ; continue 
        else
            if [[ $(uname) == "Linux" ]] ; then
                sed -i s/://g $HOME/.parmanode/after
                export disk=$(grep . $HOME/.parmanode/after | tail -n1 | awk '{print $1}')
                echo "disk=\"$disk\"" > $HOME/.parmanode/var
                debug "disk is $disk"
                break
                fi
            
            if [[ $(uname) == "Darwin" ]] ; then
                Ddiff=$(($(cat $HOME/.parmanode/after | wc -l)-$(cat $HOME/.parmanode/before |wc -l))) #visualstudo code shows last ) as an error but it's not.
                export disk=$(grep . $HOME/.parmanode/after | tail -n $Ddiff | grep "dev" | awk '{print $1}')
                echo "$(cat $HOME/.parmanode/after | tail -n $Ddiff)" > $HOME/.parmanode/difference
                echo "disk=\"$disk\"" > $HOME/.parmanode/var
                debug "disk is $disk"
                break 
                fi

            break
    fi
done
debug "disk is $disk"
if [[ $debug == 1 ]] ; then echo "disk is $disk" ; enter_continue ; fi

if [ -z "$disk" ] ; then announce "Error getting microSD card device name. Aborting." ; return 1 ; fi

log "parmanodl" "disk is $disk"
}