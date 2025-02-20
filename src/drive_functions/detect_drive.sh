#used by add_drive function --> detect_drive --> back to add_drive
#use by umbrel_import_mac - $1 menu skips initial warning. $2 umbrelmac used for text customisation
function detect_drive {
rm_after_before
unset disk
if [[ $1 != menu ]] ; then
if ! echo $@ | grep -q brief ; then
set_terminal ; echo -e "$pink
########################################################################################

    Please pay careful attention here, otherwise you could get drive errors.

########################################################################################
$orange"
enter_continue 
jump $enter_cont
fi
fi

while true ; do


if [[ $log == "umbrel-mac" ]] ; then umbrel=" Umbrel" ;fi

if ! echo $@ | grep -q brief ; then
set_terminal ; echo -en "$pink
########################################################################################
    
    Now, please make sure the$umbrel drive you wish to add to Parmanode is 
    ${cyan}DISCONNECTED.$pink Do not disconnect any of your other drives at this time. 
    
    This is important to make sure the drive is detected in the list of drives before 
    and after the connection.
   $cyan 
    Hit <enter> only once this is done. (q to quit)
$pink
########################################################################################
$orange"
read choice
case $choice in
q|Q) exit ;;
esac

fi

while true ; do
if [[ $(uname) == Linux ]] ; then
    if sudo lsblk -o LABEL | grep parmanode ; then
    announce "Sorry, but Parmanode detects that a drive with a label parmanode is" \
    "still physically connected to the computer. Please remove it and try again.
    hit$cyan control-c to quit.$orange" 
    continue 
    else break ; fi 
elif [[ $(uname) == Darwin ]] ; then
    if diskutil list | grep parmanode ; then
    announce "Sorry, but Parmanode detects that a drive with a label parmanode is" \
    "still physically connected to the computer. Please remove it and try again.
    hit$cyan control-c to quit.$orange" 
    continue 
    else break ; fi 
fi
done

#DETECT BEFORE AND AFTER...
#For some drives blkid detects a difference.
#For other drives only lsblk detects a difference.
#Making a before and after file, but two different ones to check for blkid and lsblk differnces.
#Extra coplication - mac has its own detection; diskutil list.

########################################################################################
#BEFORE STATE, CAPTURE...
if [[ $(uname) == "Linux" ]] ; then 
    sudo blkid -g >$dn #refreshes
    sleep 1
    sudo blkid > $dp/before
    sudo lsblk > $dp/before_lsblk
    fi

if [[ $(uname) == "Darwin" ]] ; then
    diskutil list > $HOME/.parmanode/before
    fi


set_terminal ; echo -e "
########################################################################################

    Now go ahead and ${pink}CONNECT$orange the$umbrel drive you wish to use for 
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
jump $enter_cont
set_terminal
sleep 2.5

if [[ $check_if_parmanode_drive == "true" ]] && ! lsblk -o LABEL | grep -q parmanode ; then
set_terminal ; echo -e "
########################################################################################
    This does not seem to be a drive with a$cyan parmanode$orange Label. Aborting.
########################################################################################
"
enter_continue
jump $enter_cont
return 1
fi

########################################################################################
#AFTER STATE, CAPTURE...

if [[ $(uname) == "Linux" ]] ; then
    sudo blkid -g >$dn #refreshes
    sleep 1
    sudo blkid > $dp/after
    sudo lsblk > $dp/after_lsblk
    fi

if [[ $(uname) == "Darwin" ]] ; then
    diskutil list > $HOME/.parmanode/after
    fi

########################################################################################
# check for difference between before and after

if { [[ $OS == Linux ]] && \
      diff -q $dp/before $dp/after >$dn 2>&1 && \
      diff -q $dp/before_lsblk $dp/after_lsblk >$dn 2>&1 ; } || \
   { [[ $OS == Mac ]] && diff -q $dp/before $dp/after 2>&1 ; } 
then
echo -e "
########################################################################################

    No new drive detected.$red DISCONNECT DRIVE$orange and hit $green<enter>$orange try again. 

    If you keep getting this error, try different ports, or try the assisted drive 
    format function in the Parmanode --> Tools menu. 
$green
    To abort, hit a and <enter> 
$orange
########################################################################################
"
read choice
case $choice in a) back2main ;; esac
continue 
fi

if [[ $OS == Mac ]] ; then
    export disk=$(diff -U0 $HOME/.parmanode/before $HOME/.parmanode/after | grep -v 'synthesized'| grep -Eo 'dev/disk.+' | cut -d ' ' -f1) 
    if [[ -z $disk ]] ; then announce "Error detecting drive. Aborting." ; return 1 ; fi
    break
fi

if [[ $OS == Linux ]] ; then

    if [[ -e $dp/before ]] && ! diff -q $dp/before $dp/after >$dn 2>&1 ; then
      export disk=$(diff -y $HOME/.parmanode/before $HOME/.parmanode/after | tail -n1 | grep -E '^\s' | grep -oE '/dev/\S+' | cut -d : -f 1 | xargs)
      debug "disk blkid diff is $disk"
      if [[ -z $disk ]] ; then
          export disk="/dev/$(diff $dp/before $dp/after | grep 'dev' | cut -d : -f 1 | grep -Eo 'dev/.+$' | cut -d / -f 2)"
      fi
    else
      get_unique_line2 "$dp/before_lsblk" "$dp/after_lsblk"
      export disk="/dev/$(tail -n1 $dp/.unique_line | awk '{print $1}' | grep -oE '[a-z]+.*')"
      debug "disk lsblk diff is $disk"
      #deprecated as it gives unexpected results...
      # export disk="/dev/$(diff $HOME/.parmanode/before_lsblk $HOME/.parmanode/after_lsblk | tail -n1 | awk '{print $2}' | tr -d '[:space:]')"
      # debug "disk lsblk diff is $disk"
    fi

    if [[ -z $disk ]] ; then announce "Error detecting Linux drive. Aborting." ; rm_after_before ; return 1 ; fi

    break
fi
enter_continue "Something went wrong. Please report to Parman. Error code: 420" && return 1
done
}

