function detect_raid_drive {
rm_after_before
while true ; do
sudo partprobe
#BEFORE STATE, CAPTURE...
    sudo blkid -g >$dn #refreshes
    sleep 1
    sudo blkid > $dp/before
    sudo lsblk > $dp/before_lsblk

#increments at the end of the function. This function is called in a loop
if [[ $drive_count_do == 0 ]] ; then 
set_terminal ; echo -e "
########################################################################################

    Go ahead and ${pink}CONNECT$orange the first drive you wish to use for RAID.

    If a window pops up, a file explorer, you can safely close that.
$cyan
    Wait a few seconds, and if you get a drive error pop-up, click IGNORE 
    before hitting <enter> here.
    $orange
    
    GIVE THE COMPUTER A FEW SECONDS TO NOTICE THE DRIVE BEFORE HITTING ENTER

########################################################################################
"
enter_continue ; jump $enter_cont
else
set_terminal ; echo -e "
########################################################################################

    Go ahead and ${pink}CONNECT$orange the next RAID drive you wish to add.

    If a window pops up, a file explorer, you can safely close that.
$cyan
    Wait a few seconds, and if you get a drive error pop-up, click IGNORE 
    before hitting <enter> here.
    $orange
    
    GIVE THE COMPUTER A FEW SECONDS TO NOTICE THE DRIVE BEFORE HITTING ENTER

########################################################################################
"
enter_continue ; jump $enter_cont
fi
set_terminal
sleep 2.5

#AFTER STATE, CAPTURE...
    sudo blkid -g >$dn #refreshes
    sleep 1
    sudo blkid > $dp/after
    sudo lsblk > $dp/after_lsblk

if diff -q $dp/before $dp/after >$dn 2>&1 && \
   diff -q $dp/before_lsblk $dp/after_lsblk >$dn 2>&1
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
case $choice in a) back2main ;; esac
continue 
fi

# COMPARE...

if  [[ -e $dp/before ]] && ! diff -q $dp/before $dp/after >$dn 2>&1 ; then

    export disk=$(diff -y $HOME/.parmanode/before $HOME/.parmanode/after | tail -n1 | grep -E '^\s' | grep -oE '/dev/\S+' | cut -d : -f 1 | xargs)
    debug "disk blkid diff is $disk"

    if [[ -z $disk ]] ; then
        export disk="/dev/$(diff $dp/before $dp/after | grep 'dev' | cut -d : -f 1 | grep -Eo 'dev/.+$' | cut -d / -f 2)"
    fi

else
    get_unique_line2 "$dp/before_lsblk" "$dp/after_lsblk"
    export disk="/dev/$(tail -n1 $dp/.unique_line | awk '{print $1}' | xargs)"
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

#CONFIRMATION...

while true ; do
set_terminal ; echo -e "
########################################################################################

    The drive detected is: $green$disk$orange

$pink
    $(lsblk $disk)

    $(blkid $disk)
$orange
########################################################################################
"
choose epmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"") break ;;
esac
done
drive_count_do=$((drive_count_do +1))
}