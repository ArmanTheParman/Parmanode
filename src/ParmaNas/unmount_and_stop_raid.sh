function unmount_and_stop_raid {
while true ; do
set_terminal ; echo "
########################################################################################

    Parmanode can unmount the RAID drive and stop the RAID process too.

                             u)     Unmount 

                             s)     Stop RAID (also unmounts) 

                             a)     Assemble RAID (opposite to stop RAID)

                             mm)    Mount RAID

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
*)
invalid
;;
mm)
mount_RAID
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
