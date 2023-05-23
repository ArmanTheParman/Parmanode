function info_add_drive {
while true ; do
set_terminal ; echo " 
########################################################################################

    Using a second drive for Parmanode is possible, but there are many scenarios  
    where things could go wrong. I have tried to anticipate what I can, and as things
    pop up (from user feedback), I will make improvements.

    Currently, you should never attach two Parmanode external drives to the computer
    at the same time. Unpredictable things can happen.

    If you add your own drive, the label will be changed to "parmanode" as Parmanode
    expects this label - the poor thing gets a little confused if it's not labelled 
    right.

    The mount point must be /home/$(whoami)/parmanode. If the directory does not exist
    it will be created.

    Make sure that if you have an old Parmanode drive, to disconnect it now.

########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 0 ;;
"") break ;; *) invlid ;; esac ; done

}