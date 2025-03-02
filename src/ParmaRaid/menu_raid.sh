function menu_raid {
while true ; do
sudo partprobe 2>/dev/null
set_terminal ; echo -e "$blue
########################################################################################$orange
                                R A I D - menu$blue
########################################################################################
$orange
                      dt)$blue         Inspect RAID details $orange
                      lr)$blue         List running RAIDs $orange
                      lm)$blue         List mounted RAIDs $orange
                      lc)$blue         List physically connected RAID drives
$orange
                      mm)$blue         Mount RAIDs (mounts all connected) $orange
                       u)$blue         Unmount (option to select which) 
$orange
                      aa)$green         Assemble RAIDs $orange
                       s)$red         Stop RAID ('disassemble')
$orange
                       i)$blue         Info about RAIDs

$blue########################################################################################
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
echo -ne "${blue}#################################$pink RAID number $count $blue########################################$orange

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
aa)
assemble_RAID
;;

i)
raid_info
;;

u)
do_RAID_unmount_loop
continue
;;
s)
do_RAID_stop_loop
continue
;;
aa)
assemble_RAID
;;

mm)
mount_RAID
debug "after mm"
;;
*)
invalid
;;
esac
done

}



#assemble raid disks
# sudo mdadm --assemble --scan

#add --name when moving to a new system to avoid name confilicts.
# sudo mdadm --assemble --name=/dev/md1 /dev/sda /dev/sdb

#update mdadm.conf
# sudo mdadm --detail --scan | grep '/dev/md1' | sudo tee -a /etc/mdadm/mdadm.conf
# sudo update-initramfs -u
