function choose_and_prepare_drive_parmanode {

# chooses between internal and external drive

while true
do
set_terminal
echo "
########################################################################################

    You have the option to use an external or internal hard drive. There will always 
    be a:

                               $HOME/parmanode 

    ... directory on the internal drive, but you can keep the Bitcoin blockchain data, 
    and other programs' data on the external drive.

    Please choose an option:

                           (e) - Use an EXTERNAL drive

                           (i) - Use an INTERNAL drive:

########################################################################################
"
choose "xpq"

read choice

case $choice in
e | E)    #External drive setup

hdd="external" #variable needed for other functions being used later

set_terminal
echo "
########################################################################################

    Note, it is strongly recommended that you use a solid state drive (SSD) as your
    external drive, otherwise you're going to have a bad time, mkay?

    Also note, there will be some directories on the internal drive with symlinks 
    ("shortcut links") to the external drive once you install Bitcoin Core. 
    Do not delete these. 

    Go ahead and connect the drive to the computer if you haven't done so.

########################################################################################
"
enter_continue

set_terminal

format_ext_drive
	return_value=$?
        if  [[ $return_value == 1 ]] ; then
		set_terminal
                echo "External drive setup has been skipped. Proceed with caution."
                enter_continue
	        return 0 ; fi
        
        if [[ $return_value == "0" ]] ; then
                return 0 ; fi #success 

        if [[ $return_value == "2" ]] ; then 
                return 1 ; fi #go back to main menu. 
        ;;

i | I)
        hdd="internal"
        return 0 
        ;;

q|Q|quit|QUIT|Quit)
        exit 0
        ;;
p|P)
        return 2
        ;;
*)
        clear
	invalid
        ;;  
esac
done
return 0
}
