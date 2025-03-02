function do_RAID_unmount_loop {
sudo partprobe 2>/dev/null #necessary to remove GPT table error (no partition on disk is intentional)
mount | grep -q '/dev/md' || { announce_blue "No RAIDs mounted" ; return 1 ; }

for i in $(mount | grep '/dev/md' | awk '{print $1}') ; do
set_terminal ; echo -e "$blue
########################################################################################

    Unmount this RAID?     $green y$orange or$red n$orange
$orange
$i
$blue
########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) continue ;;
y)
sudo umount $i >$dn && success_blue "RAID unmounted"
;;
*)
continue ;;
esac
done
}

