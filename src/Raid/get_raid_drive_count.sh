function get_raid_drive_count {
while true ; do

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please enter a$cyan number$orange to indicate the number of drives you want to combine in
    a RAID-0 configuration (it is limited by the number of drives you can 
    simultaneously connect to the computer).

########################################################################################
"
choose "xpmq" read drive_number ; set_terminal
jump $drive_number || { invalid ; continue ; } ; set_terminal
case $drive_number in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
0|1)
announce "Cannot be zero or one. You chose $drive_number" 
continue
;;
*)
if grep -qE '[a-zA-Z]' <<< $drive_number ||\
 ! grep -qE '^[0-9]+$' <<< $drive_number ; then
announce "Numbers only. Hit <enter> to try again."
continue
fi
break 
;;
esac
done

set_terminal ; echo -e "
########################################################################################

    Number of drives chosen: $drive_number

    Hit$cyan <enter>$orange to accept

    or

    Type$cyan x$orange and$cyan <enter>$orange to try again.

########################################################################################
"  
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"") break ;;
x) continue ;;
*) 
invalid ;;
esac
done

set_terminal ; echo -e "
########################################################################################

    Each drive chosen needs to be formatted, one after the other.$cyan Disconnect$orange all
    of them for now, very important. 
    
    Parmanode will then ask you to add the drives and will build a list of their 
    device names. 
    
    Once connected, don't disconnect unless asked to. If you accidentally disconnect a 
    drive, it's best to abandon the procedure becuase the device names might get mixed 
    up. 

########################################################################################
"
enter_continue ; jump $enter_cont
}