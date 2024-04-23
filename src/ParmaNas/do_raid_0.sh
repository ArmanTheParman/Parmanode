function do_raid_0 {

if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

if ! which mdadm ; then
set_terminal
echo -e "${green}Just gotta install mdadm...$orange"
sudo apt-get update -y
sudo apt-get install mdadm -y
fi

get_raid_drive_count || return 1   #gets $drive_count
drive_count_do=0

#detects drive in /dev/sdx format, and counts the number of
#times it's looped (number of drives added),
#then populates a file to make a list of the raid drive dev names...
debug "drive_number=$drive_number drive_count_do=$drive_count_do"
rm $dp/raid_list.conf >/dev/null 2>&1
while [[ $drive_count_do -lt $drive_number ]] ; do
detect_raid_drive || return 1
echo "$disk" >> $dp/raid_list.conf
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
done < $dp/raid_list.conf

#RAID...
set_terminal ; echo -e "${green}Preparing RAID ...$orange" ; sleep 1.5
echo ""
echo "$drive_number drives will be formed into a RAID."
enter_or_quit 
echo ""

get_device_list

if lsblk | grep -q md0 >/dev/null 2>&1 ; then
announce "You need to unmount any pre-existing RAID drives or this procedure will fail.
    I'll wait. After unmounting, you can carry on."
fi

if lsblk | grep -q md0 >/dev/null 2>&1 ; then
set_terminal ; echo -e "
########################################################################################

    A current RAID drive still seems to exist based on a search command:
$cyan
    lsblk | grep md0
$orange
    You can have more than one RAID system going.

    It could be the drive you're preparing was once a RAID drive, which is fine.

    If I'm wrong, type$cyan 'wrong'$orange and$cyan <enter>$orange to continue.

    Otherwise, aborting.

########################################################################################
"
read choice

    if [[ $choice != wrong ]] ; then
    return 1
    fi
fi

debug "device list string: $device_list"

md_num=0
check_raid_exists || return 1
sudo umount $device_list
sudo umount /media/$USER/RAID
sudo mdadm --create --verbose /dev/md${md_num} --level=0 --raid-devices=$drive_number $device_list
debug "pause after create raid
$device_list"

if [[ ! -e /media/$USER/RAID ]] ; then
    sudo mkdir -p /media/$USER/RAID 2>/dev/null
    sudo chown -R $USER:$USER /media/$USER/RAID >/dev/null 2>&1
fi

#Format the array
sudo umount $device_list
sudo umount /media/$USER/RAID
sudo mkfs.ext4 /dev/md0

#Mount it
sudo mount /dev/md${md_num} /media/$USER/RAID || { announce "Parmanode couldn't mount your RAID. Please try yourself." ; return 1 ; }
sudo chown -R $USER:$USER /media/$USER/RAID >/dev/null 2>&1

success "The RAID drive was created, and mounted to$cyan /media/$USER/RAID/$orange

    You can check the details of the RAID with the command: $cyan

        sudo mdadm --detail /dev/md${md_num}
$orange
    To see your connected devices and device names you can do any of ...$cyan

        df -h   
        lsblk
        blkik 
$orange
    Enjoy."

}

function get_device_list {
# Initialize an empty string to hold the device names
device_list=""

# Read each line in the raid_list.conf file
while IFS= read -r line; do
    # Append each device name to the string
    device_list+="$line "
done < "$dp/raid_list.conf"
}


