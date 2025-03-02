function unmount_and_stop_raid_menu {
while true ; do
sudo partprobe 2>/dev/null
set_terminal ; echo -e "$blue
########################################################################################$orange
                                    RAID MENU$blue
########################################################################################

$orange
                        mm) $blue   Mount RAID (mounts all connected)
$orange
                        u)$blue     Unmount (option to select which) 
$red
                        s)     Stop RAID (also unmounts)
$green
                        aa)    Assemble RAID (opposite to stop RAID)

$blue
########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
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
