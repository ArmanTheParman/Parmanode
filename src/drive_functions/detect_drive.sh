#used by add_drive function.
function detect_drive {
if [[ $1 == umbrelmac ]] ; then 
unset disk
if [[ $1 != menu ]] ; then
set_terminal pink ; echo "
########################################################################################

    Please pay careful attention here, otherwise you could get drive errors.

########################################################################################
"
enter_continue 
fi

while true ; do
set_terminal ; echo -e "$pink
########################################################################################
    
    Now, please make sure the drive you wish to$cyan add$orange to Parmanode is 
    ${cyan}DISCONNECTED.$pink Do not disconnect any of your other drives at this time. 
    
    This is important to make sure the drive is detected in the list of drives before 
    and after the connection.
    
    DO NOT JUST YANK OUT THE DRIVE - IF YOU CAN, IT'S BEST TO PROPERLY UNMOUNT IT.
   $cyan 
    Hit <enter> only once this is done.
$pink
########################################################################################
"
read

if sudo lsblk -o LABEL | grep parmanode ; then
announce "Sorry, but Parmanode detects that a drive with a label parmanode is" \
"still physically connected to the computer. Aborting." 
return 1
fi

if [[ $(uname) == "Linux" ]] ; then 
    sudo blkid -g >/dev/null
    sudo blkid > $HOME/.parmanode/before
    fi

if [[ $(uname) == "Darwin" ]] ; then
    diskutil list > $HOME/.parmanode/before
    fi

set_terminal ; echo -e "
########################################################################################

    Now go ahead and ${cyan}CONNECT$orange the drive you wish to use for Parmanode. Do not 
    connect any other drive.

    If a window pops up, a file explorer, you can safely close that.

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
}