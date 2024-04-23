function mount_RAID {
for i in $(sudo mdadm --detail --scan | awk '{print $2}') ; do
mount | grep -q "$i" && { set_terminal ; echo "$1 is already mounted" ; sleep 1.5 ; continue ; }
set_terminal
echo "mounting $i ..."
sleep 1
sudo mount $i /media/$USER/RAID$(echo $1 | grep -oE '[0-9]+') #mounts /dev/md[num] to /media/$USER/RAID[num]
done
}