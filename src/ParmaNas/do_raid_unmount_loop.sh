function do_RAID_unmount_loop {

mount | grep -q '/dev/md' || { announce "No RAIDs mounted" ; return 1 ; }

for i in $(mount | grep '/dev/md') ; do
set_terminal ; echo -e "
########################################################################################

    Unmount this RAID?     $green y$orange or$red n$orange
$bright_blue    
$i
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) continue ;;
y)
sudo umount $(echo $i | awk '{print $1}') && success "RAID unmounted"
;;
*)
continue ;;
esac
done
}

