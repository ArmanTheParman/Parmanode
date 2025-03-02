function menu_raid {
while true ; do
set_terminal ; echo -e "$blue
########################################################################################$orange
                                R A I D - menu$blue
########################################################################################
$orange
                          dt)$blue         Inspect RAID details
$orange
                          lr)$blue         List running RAIDs
$orange
                          lm)$blue         List mounted RAIDs
$orange
                          lc)$blue         List physically connected RAID drives
$orange
                          i)$blue          info about RAIDs
$blue
########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; M|m) back2main ;;

lr)
set_terminal
sudo mdadm --detail --scan
enter_continue

;;
lm)
set_terminal
mount | grep /dev/md | cat #cat removes the grep colour
enter_continue
;;

lc)
set_terminal
sudo blkid | grep /dev/md | cat
enter_continue
;;

dt)
set_terminal
device=$(sudo mdadm --detail --scan | awk '{print $2}') #space separated list
count=0
for i in $device ; do
count=$((count + 1))
clear
echo -ne "${blue}################################# RAID number $count ########################################$orange

"
sudo mdadm --detail $i
echo -e "$blue
########################################################################################"
enter_continue
done
;;

# ums)
# unmount_and_stop_raid_menu || return 1
# ;;

i)
raid_info
;;

*)
invalid
;;
esac
done

}


#$orange
#                          ums)$blue        Unmount/Mount/Stop menu ...