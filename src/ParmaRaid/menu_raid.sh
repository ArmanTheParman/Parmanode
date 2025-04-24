function menu_raid {
# FOR LATER, to detect errors. zenity --info --title="RAID Alert" --text="Drive failed in RAID1. Check /proc/mdstat." --width=400 --height=100
while true ; do
if grep -Eq '\[.*_.*\]' /proc/mdstat ; then issuedetected="$blinkon${red}RAID ISSUE DETECTED$blinkoff$orange" ; else unset issuedetected ; fi
set_terminal ; echo -e "$blue
########################################################################################$orange
                                 R A I D - menu$blue
########################################################################################
$issuedetected$orange
                      dt)$blue         Inspect RAID details $orange
                      lr)$blue         List running RAIDs $orange
                      lm)$blue         List mounted RAIDs $orange
                      lc)$blue         List physically connected RAID drives
$orange
                      mm)$blue         Mount RAID$orange
                       u)$blue         Unmount (option to select which) 
$orange
                      aa)$green         Assemble RAIDs $orange
                    stop)$red         Stop Raid
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

i)
raid_info
;;

u)
unmount_raids
continue
;;
stop)
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
"")
continue ;;
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

function mdadm_detect_errors {
true
#mdadm --monitor --scan --oneshot 2> output.txt

#mdadm --monitor --scan --daemonise --program=/path/to/alert.sh

#grep -E 'DegradedArray|Fail|removed|RebuildStarted|RebuildFinished'


#make a service file to keep mdadm_detect running, and restart within parmanode and desired moments.


}