function raid_info {
set_terminal ; echo -e "$blue
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

    The drives are formatted, but also there is another layer of format that happens 
    at a higher level, across all the drives.

########################################################################################
"
enter_continue ; jump $enter_cont
return 0
}

function bitcoin_raid_info {
set_terminal ; echo -e "$blue
########################################################################################

    Please note that the RAID being set up will be configured to mount to:
$orange
        /media/$USER/RAIDx$blue, where x is a number.

    If you decide to use this RAID for a Bitcoin node with the help of Parmanode,
    the RAID mountpoint will be shifted to$orange /media/$USER/parmanode.$blue

    Some of the Parmanode RAID menu options may then not work as expected, but that 
    shouldn't particularly be a problem, just something to be aware of.

########################################################################################
"
enter_continue ; jump $enter_cont
}