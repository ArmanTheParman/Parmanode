function unmount_and_stop_raid_menu {
while true ; do
sudo partprobe
set_terminal ; echo -e "
########################################################################################

    You can select which RAIDs to act on in the next screen...
$green
                             u)$orange     Unmount (option to select which) $green

                             s) $orange    Stop RAID (also unmounts)$green 

                             aa)  $orange  Assemble RAID (opposite to stop RAID)$green

                             mm) $orange   Mount RAID (mounts all connected)

########################################################################################
"
choose xpmq ; read choice ; set_terminal
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
