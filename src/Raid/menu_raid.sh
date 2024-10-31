function menu_raid {
while true ; do
set_terminal ; echo -e "
########################################################################################$cyan
                                R A I D - menu$orange
########################################################################################
$cyan
                          dt)$orange         Inspect RAID details$cyan

                          lr)$orange         List running RAIDs$cyan

                          lm)$orange         List mounted RAIDs$cyan

                          lc)$orange         List physically connected RAID drives$cyan

                          ums)$orange        Unmount/Mount/Stop menu ...$cyan

                          i)$orange          info about RAIDs

########################################################################################
"
choose xpmq ; read choice ; set_terminal
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
blkid | grep /dev/md | cat
enter_continue
;;

dt)
set_terminal
device=$(sudo mdadm --detail --scan | awk '{print $2}') #space separated list
count=0
for i in $device ; do
count=$((count + 1))
clear
echo -ne "${green}################################# RAID number $count########################################$orange"
sudo mdadm --detail $i
enter_continue
done
;;

ums)
unmount_and_stop_raid_menu || return 1
;;

i)
raid_info
;;

*)
invalid
;;
esac
done

}

