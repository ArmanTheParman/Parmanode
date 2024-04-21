function do_raid_0 {

if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

if ! which mdadm ; then
sudo apt-get update -y
sudo apt-get install mdadm -y
fi

get_raid_drive_count || return 1   #gets $drive_count
drive_count_do=0

#detects drive in /dev/sdx format, and counts the number of
#times it's looped (number of drives added),
#then populates a file to make a list of the raid drive dev names...

while [[ $drive_count_do -lt $drive_count ]] ; then
detect_raid_drive || return 1
echo "$drive_count_do $disk" >> $dp/raid_list.conf
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
choose emq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
"") break ;;
*) invalid ;;
esac
done



}