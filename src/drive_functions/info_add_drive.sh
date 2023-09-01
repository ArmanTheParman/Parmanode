function info_add_drive {
while true ; do
set_terminal ; echo " 
########################################################################################

    Using a second drive for Parmanode is possible but only between operating systems.
    For example, you can't import a Parmanode drive used on a Mac to a Linux computer.

    Also, you shouldn't attach two Parmanode external drives to the computer
    simultaneously. Unpredictable things can happen.

    If you add your own drive, the label will be changed to "parmanode" (as Parmanode
    expects this label) - the poor thing gets a little confused if it's not labelled 
    this way!

    The mount point must be /home/$(whoami)/parmanode for Linux, and
    /Volumes/parmanode for Mac. If the directory does not exist it will be created.

    If you use an internal drive with Bitcoin Core and you want to switch to a new
    or imported external drive, the easiest way to accomplish this is to uninstall
    Bitcoin Core using Parmanode, then re-install it again, but choose external drive
    when prompted. If an external drive was prepared earlier, make sue you select not
    to format it during the Bitcoin Core installation.

########################################################################################

            IF YOU HAVE AN OLD PARMANODE DRIVE, TO DISCONNECT IT NOW.

########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 0 ;;
"") break ;; *) invlid ;; esac ; done

}