function mount_RAID {

for i in $(sudo mdadm --detail --scan | awk '{print $2}') ; do
mount | grep -q "$i" && { set_terminal ; echo "$1 is already mounted" ; sleep 1.5 ; continue ; }
set_terminal
echo "mounting $i ..."
sleep 1
debug "1"
sudo mkdir -p "/media/$USER/RAID$(echo $i | sed 's!/dev/md/!!')" >/dev/null
debug "2"
sudo mount $i "/media/$USER/RAID$(echo $i | sed 's!/dev/md/!!')" #mounts /dev/md/xxx to /media/$USER/RAIDxxx
debug "mounted?"
done
}