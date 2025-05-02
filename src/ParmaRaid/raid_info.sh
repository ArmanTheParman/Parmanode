function raid_info {
set_terminal 42 ; echo -e "$blue
########################################################################################$orange
                             R A I D - info $blue
########################################################################################

    It's easy to look up what RAIDs are and do, so this is not meant to be exhaustive,
    but rather, some extra information that might not be obvious.

    Not only is a RAID mounted, but there is also a RAID process (program) that needs 
    to be running. This is why there is are 'stop' and 'assemble' options available 
    in the menu.
    
    You can't just mount the RAID drives without having the RAID process running. 
          
    You also can't stop the process unless you unmount the drives.

    Some useful commands to do manually if the menus aren't doing the trick for you... 

    If a drive is missing from a RAID array (you might see that when inspecting RAID
    details, you can add it like this, where /dev/sdX is the device name of the 
    drive...
$cyan
       sudo mdadm --add /dev/md0 /dev/sdX
$blue
    Note, if the drive is encrypted, you will need a different device naming format
    that goes like this (use the decrypted name, eg ParmaDrive):
$cyan
       sudo mdadm --add /dev/md0 /dev/mapper/ParmaDrive
$blue
    You can remove too, just change '--add' to '--remove'

    Other information gathering commands...
$cyan       
       cat /proc/mdstat
       sudo mdadm --detail --scan
       sudo mdadm --detail /dev/md0
$blue
########################################################################################
"
enter_continue ; jump $enter_cont
return 0
}