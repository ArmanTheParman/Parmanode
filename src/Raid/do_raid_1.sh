function do_raid_1 {

if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

if ! which mdadm ; then
set_terminal
echo -e "${green}Just gotta install mdadm...$orange"
sudo apt-get update -y
sudo apt-get install mdadm -y
fi

bitcoin_raid_info

#stop running raids
stop_raids || return 1

get_raid_drive_count || return 1   #gets selected $drive_count
drive_count_do=0

#detects drive in /dev/sdx format, and counts the number of
#times it's looped (number of drives added),
#then populates a file to make a list of the raid drive dev names...
debug "drive_number=$drive_number drive_count_do=$drive_count_do"
rm $dp/device_list.conf >/dev/null 2>&1

while [[ $drive_count_do -lt $drive_number ]] ; do
detect_raid_drive || return 1
echo "$disk" >> $dp/device_list.conf
debug "drive count do is: $drive_count_do
disk is $disk"
done

while true ; do
set_terminal ; echo -e "
########################################################################################
$green
    Nice job.$orange Assuming all the drives are attached, parmanode will not format each
    one. Please let it do it's thing, it'll take some time.

########################################################################################
"
choose eq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
"") break ;;
*) invalid ;;
esac
done

# unmount, partition, format, make raid, ?make nas

while read device ; do
set_terminal ; echo -e "${green}Preparing $device ...$orange" ; sleep 1.5
#partition...
debug "in loop, device is $device"
sudo fdisk "$device" <<EOF >/dev/null
g
w
EOF
#format...
sudo mkfs.ext4 $device
done < $dp/device_list.conf

#RAID...
set_terminal ; echo -e "${green}Preparing RAID ...$orange" ; sleep 1.5
echo ""
echo "$drive_number drives will be formed into a RAID."
enter_or_quit 
echo ""

#fetch /dev/... list
get_device_list 

debug "device list string: $device_list"

#set variable based on running raids. If non running, md_num will be 0
md_num=0
for i in $(sudo mdadm --detail --scan) ; do
echo $i | awk '{print $2}' | grep -q "md${md_num}" && md_num=$((md_num + 1))
done
debug "md_num is $md_num"

sudo umount $device_list >/dev/null
sudo umount /media/$USER/RAID >/dev/null
sudo mdadm --create --verbose /dev/md${md_num} --level=1 --raid-devices=$drive_number $device_list
debug "pause after create raid
$device_list"

if [[ ! -e /media/$USER/RAID${md_num} ]] ; then
    sudo mkdir -p /media/$USER/RAID${md_num} 2>/dev/null
    sudo chown -R $USER:$USER /media/$USER/RAID${md_num} >/dev/null 2>&1
fi

#Format the array
sudo umount $device_list >/dev/null
sudo umount /media/$USER/RAID${md_num} >/dev/null
sudo mkfs.ext4 /dev/md${md_num}

#Mount it
sudo mount /dev/md${md_num} /media/$USER/RAID${md_num} || { announce "Parmanode couldn't mount your RAID. Please try yourself." ; return 1 ; }
sudo chown -R $USER:$USER /media/$USER/RAID${md_num} >/dev/null 2>&1

installed_conf_add "/dev/md${md_num}"

success "The RAID drive was created. Manage from the$green use --> raid$orange menu.

    PLEASE NOTE FOR RAID1 TYPE ARRAYS, THE DRIVES WILL SYNC INITIALLY EVEN THOUGH THEY 
    START EMPTY AND THE PROCESS CAN BE VERY SLOW, EVEN DAYS, ESPECIALLY IF THE DRIVES 
    ARE THROUGH USB 2.0. 
    
    RAID1 DRIVES WILL ALSO PERIODICALLY SYNC.

    IT IS PROBABLY OK TO USE IT BUT MIGHT BE SAFEST TO WAIT FOR IT TO FINISH SYNCING
    BEFORE USING IT.

    THE SYNC STATUS CAN BE SEEN IN THE 'DETAILS' MENU."
}