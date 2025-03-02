function unmount_raids {
sudo partprobe 2>/dev/null #necessary to remove GPT table error (no partition on disk is intentional)
mount | grep -q '/dev/md' || { announce_blue "No RAIDs mounted" ; return 1 ; }

for i in $(mount | grep '/dev/md' | awk '{print $1}') ; do
yesorno_blue "Unmount this RAID?

$orange
$i
$blue
" && sudo umount $i >$dn && success_blue "RAID unmounted" && return 0
continue
done
}

