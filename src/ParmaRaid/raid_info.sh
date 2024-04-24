function raid_info {
set_terminal ; echo -e "
########################################################################################$cyan
                             R A I D - info $orange
########################################################################################

    It's easy to look up what RAIDs are and do, so this is not meant to be exhaustive,
    but rather, some extra information that might not be obvious.

          Not only is a RAID mounted, but there is also a RAID process (program) 
          that needs to be running. This is why there is are 'stop' and 'assemble'
          options available in the menu.
          
          You can't just mount the RAID drives without having the RAID 
          process running. 
          
          You also can't stop the process unless you unmount the drives.

          The drives are formatted, but also there is another layer of format that
          happens at a higher level, across all the drives.

########################################################################################
"
enter_continue
return 0
}