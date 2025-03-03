function do_RAID_stop_loop {

if [[ $(sudo mdadm --detail --scan | wc -l) == 0 ]] ; then
announce_blue "No RAID processes detected"
return 1
fi
set_terminal


for i in $(sudo mdadm --detail --scan | awk '{print $2}') ; do
yesorno_blue "Stop this RAID process?

   $green y$orange or$red n$orange

$i
$blue
########################################################################################
" && {
sudo umount $i >$dn 2>&1
sleep 1
sudo mdadm --stop $i 
success_blue "RAID process stopped"
unset this_device
}
done
}