function format_warnings {
while true ; do
set_terminal
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################

    YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased.

                         (y)     Format drive

                         (s)     Skip formatting


    If skipping, make sure your drive is correctly configured, and mounts to: 
			 
	                      /media/$(whoami)/parmanode

                          
    The easiest way to configure a existing drive is to use...

               main menu --> tools --> Bring in a Parmanode drive


########################################################################################
"
fi
if [[ $OS == "Mac" ]] ; then
echo "
########################################################################################

    YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased.

                             (y)     Format drive

                             (s)     Skip formatting
    
    If skipping, make sure your drive is formatted and mounted.
    
########################################################################################

"
fi
choose "xq" ; read choice
case $choice in 
    s|S)
        export skip_formatting="true"
        return 0 ;;
    q|Q)
        exit 0 ;;
    y|Y)
        export skip_formatting="false"
        break ;; # proceed to format drive below
    *)
        invalid ;;
    esac
done


# # Later, "I'll need to improve this so that the drive is detected without as much user
# # input needed"

# set_terminal "pink"
# echo "
# ########################################################################################
# ########################################################################################
#                 IT IS EXTREMELY IMPORTANT TO PAY ATTENTIONS HERE...
# ########################################################################################
# ########################################################################################

#     You must make sure you select the correct drive from the following list. One way
#     to determine which drive is the one you need to select is knowing the size of the
#     drive (and matching it to what is stated in the list). 

#     That clue can help, but is not always the case, eg. if you have two drives with 
#     the same size.

#     THE WORST THING THAT CAN HAPPEN IS YOU CHOOSE THE WRONG DRIVE AND IT GETS 
#     FORMATTED, AND YOU LOSE YOUR DATA. YOU COULD EVEN WIPE ALL THE DATA FROM YOUR 
#     COMPUTER IF YOU SELECT THE WRONG DRIVE. IF YOU ARE UNSURE, STOP, AND HIT Control-c

# ########################################################################################
# ########################################################################################

# "
# read -p "Hit <enter> to see the list..."
# set_terminal

# return 0
}