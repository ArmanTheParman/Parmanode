function do_RAID_stop_loop {
sudo partprobe

if [[ $(sudo mdadm --detail --scan | wc -l) == 0 ]] ; then
announce "No RAID processes detected"
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
sudo umount $i >$dn
sudo mdadm --stop $i 
success "RAID process stopped"
unset this_device
sudo partprobe 2>/dev/null
}
done
}