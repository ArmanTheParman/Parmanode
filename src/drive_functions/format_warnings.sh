function format_warnings {
while true ; do
set_terminal
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################

    YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased. You will
    be asked to confirm exactly which drive is to be formatted.

    If you skip formatting, make sure there is enough free capacity on the drive 
    before running Bitcoin.
                
                         (y)     Format drive

                         (s)     Skip formatting
    
    If skipping, make sure your drive is formatted and mounts to: 
			 
	                      /media/$(whoami)/parmanode
    
########################################################################################

"
fi
if [[ $OS == "Mac" ]] ; then
echo "
########################################################################################

    YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased.

    If you skip formatting, make sure there is enough free capacity on the drive 
    before running Bitcoin.
                
                             (y)     format drive

                             (s)     skip formatting
    
    If skipping, make sure your drive is formatted and mounted.
    
########################################################################################

"
fi
choose "xq" ; read choice
case $choice in 
    s|S)
        return 1 ;;
    q|Q)
        exit 0 ;;
    y|Y)
        break ;; # proceed to format drive below
    *)
        invalid ;;
    esac
done

set_terminal "pink"
echo "
########################################################################################
########################################################################################
                IT IS EXTREMELY IMPORTANT TO PAY ATTENTIONS HERE...
########################################################################################
########################################################################################

    You must make sure you select the correct drive from the following list. One way
    to determine which drive is the one you need to select is knowing the size of the
    drive (and matching it to what is stated in the list). 

    That clue can help, but is not always the case, eg. if you have two drives with 
    the same size.

    THE WORST THING THAT CAN HAPPEN IS YOU CHOOSE THE WRONG DRIVE AND IT GETS 
    FORMATTED, AND YOU LOSE YOUR DATA. YOU COULD EVEN WIPE ALL THE DATA FROM YOUR 
    COMPUTER IF YOU SELECT THE WRONG DRIVE. IF YOU ARE UNSURE, STOP, AND HIT Control-c

########################################################################################
########################################################################################

"
read -p "Hit <enter> to see the list..."
set_terminal

return 0
}