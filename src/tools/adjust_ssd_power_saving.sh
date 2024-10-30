function adjust_ssd_power_saving {

while true ; do
set_terminal ; echo -e "
########################################################################################

    You can set power saving for your ssd from 1 to 255. 255 completely turns off
    any power saving features.    

    Your SSDs connected...
$green
$(lsblk | grep sd[a-z][^0-9])
$orange

    Please type in a drive to manage, eg 'sda'

########################################################################################
"
choose xpmq
read sddrive ; set_terminal
case $sddrive in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
esac

if ! lsblk | grep sd[a-z][^0-9] | grep -q $sddrive ; then
announce "invalid choice"
continue
fi

if sudo hdparm -B /dev/$sddrive | grep APM_level | grep -q "not supported" ; then
announce "Power management for this drive is not supported"
continue
fi

hdparmvalue=$(sudo hdparm -B /dev/$sddrive | grep = | cut -d = -f 2 | tr -d ' ')
set_terminal ; echo -e "
########################################################################################

    The value set for power management for your device is:
    $cyan
    $hdparmvalue
    $orange

    Hit <enter> to return, or

    Type a value between 1 - 255 inclusive to set a new value

########################################################################################
"
choose xpmq
read value
case $value in
q|Q) exit ;;  m|M) back2main ;; p|P|"") return 0 ;;
esac

[[ $value -gt 255 ]] || {
    invalid 
    continue
}

sudo hdparm -B $value /dev/$sddrive
enter_continue
break
done
return 0
}

    
