function detect_raid_drive {

#BEFORE STATE, CAPTURE...
    sudo blkid -g > $dp/before
    sudo lsblk > $dp/before_lsblk

set_terminal ; echo -e "
########################################################################################

    Go ahead and ${pink}CONNECT$orange a RAID drive you wish to use.

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

while true ; do

#AFTER STATE, CAPTURE...
    sudo blkid -g > $dp/after
    sudo lsblk > $dp/after_lsblk

if diff -q $dp/before $dp/after >/dev/null 2>&1 && \
   diff -q $dp/before_lsblk $dp/after_lsblk >/dev/null 2>&1
then
set_terminal
echo -e "
########################################################################################

    No new drive detected.$red DISCONNECT DRIVE$orange and hit $green<enter>$orange try again. 

    If you keep getting this error, try different ports
$green
    To abort, hit a and <enter> 
$orange
########################################################################################
"
read choice
rm_after_before
case $choice in a) back2main ;; esac
continue 
fi

# COMPARE...

if  [[ -e $dp/before ]] && ! diff -q $dp/before $dp/after >/dev/null 2>&1 ; then

    export disk=$(diff -y $HOME/.parmanode/before $HOME/.parmanode/after | tail -n1 | grep -E '^\s' | grep -oE '/dev/\S+' | cut -d : -f 1 | tr -d '[:space:]')
    debug "disk blkid diff is $disk"

    if [[ -z $disk ]] ; then
        export disk="/dev/$(diff $dp/before $dp/after | grep 'dev' | cut -d : -f 1 | grep -Eo 'dev/.+$' | cut -d / -f 2)"
    fi

else
    get_unique_line "$dp/before_lsblk" "$dp/after_lsblk"
    export disk="/dev/$(cat $dp/.unique_line | awk '{print $1}' | tr -d '[:space:]')"
    debug "disk lsblk diff is $disk"
    #deprecated as it gives unexpected results...
    # export disk="/dev/$(diff $HOME/.parmanode/before_lsblk $HOME/.parmanode/after_lsblk | tail -n1 | awk '{print $2}' | tr -d '[:space:]')"
    # debug "disk lsblk diff is $disk"
fi

if [[ -z $disk ]] ; then 
    aannounce "Error detecting Linux drive. Aborting." ; rm_after_before ; return 1
fi

break
done
rm_after_before

#CONFIRMATION...

while true ; do
set_terminal ; echo -e "
########################################################################################

    The drive detected is: $green$disk$orange

    $(lsblk $disk)

    $(blkid $disk)

########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"") break ;;
esac
done
drive_count_do=$((drive_count_do +1))
}