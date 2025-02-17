function do_RAID_stop_loop {
sudo partprobe
if [[ $(sudo mdadm --detail --scan | wc -l) == 0 ]] ; then
announce "No RAID processes detected"
return 1
fi

set_terminal

for i in $(sudo mdadm --detail --scan | awk '{print $2}') ; do
set_terminal ; echo -e "$blue
########################################################################################

    Stop this RAID process?   $green y$orange or$red n$orange
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
sudo umount $i >$dn
sudo mdadm --stop $i && installed_conf_remove "$i" \
&& debug "should be stopped. i is $i. lsblk...
$(sudo partprobe  2>/dev/null; lsblk)" \
&& success "RAID process stopped"
unset this_device
sudo partprobe 2>/dev/null
continue 
;;
*)
continue ;;
esac
done

}