function info_add_drive {
while true ; do
set_terminal ; echo " 
########################################################################################

    Using a second drive for Parmanode is possible, but there are many scenarios  
    where things could go wrong. I have tried to anticipate what I can, and as things
    pop up (from user feedback), I will make improvements.

    Currently, you shouldn't attach two Parmanode external drives to the computer
    simultaneously. Unpredictable things can happen.

    If you add your own drive, the label will be changed to "parmanode" (as Parmanode
    expects this label) - the poor thing gets a little confused if it's not labelled 
    this way.

    The mount point must be /home/$(whoami)/parmanode for Linux, and
    /Volumes/parmanode for Mac. If the directory does not exist it will be created.

    MAKE SURE THAT IF YOU HAVE AN OLD PARMANODE DRIVE, TO DISCONNECT IT NOW.

########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 0 ;;
"") break ;; *) invlid ;; esac ; done

}