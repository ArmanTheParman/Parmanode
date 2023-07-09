function choose_and_prepare_drive_parmanode {
# Expect argument, either Bitcoin or Fulcrum for $1
# chooses between internal and external drive

while true
do
set_terminal
echo "
########################################################################################

    You have the option to use an external or internal hard drive for the $1
    block data.

    Please choose an option:

                           (e) - Use an EXTERNAL drive

                           (i) - Use an INTERNAL drive:

########################################################################################
"
choose "xpq"

read choice

case $choice in
e | E)    #External drive setup

if [[ $1 == "Bitcoin" ]] ; then export hdd="external" ; fi
if [[ $1 == "Fulcrum" ]] ; then export drive_fulcrum="external"
        parmanode_conf_add "drive_fulcrum=external"
        
        #check if drive prepared with Bitcoin install...
        if grep "drive=external" $HOME/.parmanode/parmanode.conf ; then
        return 0
        fi
fi

set_terminal
echo "
########################################################################################

    Note, it is strongly recommended that you use a solid state drive (SSD) as your
    external drive, otherwise you're going to have a bad time, mkay?
" ; if [[ $1 == "bitcoin" ]] ; then echo "
    Also note, there will be some directories on the internal drive with symlinks 
    ("shortcut links") to the external drive once you install Bitcoin Core. 
    Do not delete these." ; fi 
echo "
    Go ahead and connect the drive to the computer if you haven't done so.

########################################################################################
"
enter_continue

set_terminal

format_ext_drive "$1"
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
        if [[ $1 == "Bitcoin" ]] ; then export hdd="internal" ; fi
        if [[ $1 == "Fulcrum" ]] ; then export drive_fulcrum="internal" 
               parmanode_conf_add "drive_fulcrum=internal"
               fi

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
