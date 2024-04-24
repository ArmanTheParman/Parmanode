function confirm_raid_device {

#### if there is no RAID detected...    
set_terminal 
if [[ $(sudo mdadm --detail --scan | wc -l ) == 0 ]] ; then

announce "No RAID device detected. Hit$green r$orange and $cyan <enter>$orange to try
    again, or just$cyan <enter>$orange to abort."

if [[ $enter_cont == r ]] ; then confirm_raid_device && return 0 ; return 1
else
return 1
fi

else #### Raid detected, at least 1

for i in $(sudo mdadm --detail --scan | awk '{print $2}' ) ; do
while true ; do
set_terminal
echo -e "
########################################################################################

    Use this drive?   $green y$orange or$red n$orange

        $i

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; M|m) back2main ;;
n) 
continue ;;
y) 
export disk=$i ; break ;;
*) 
invalid ;;
esac
done #while
done #for
fi # if raid detected

debug "disk RAID is $disk"
return 0

}