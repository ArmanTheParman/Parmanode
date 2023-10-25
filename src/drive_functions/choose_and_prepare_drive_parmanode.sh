function choose_and_prepare_drive_parmanode {
# Expect argument, either Bitcoin or Fulcrum or Electrs for $1
# chooses between internal and external drive
# Should have called the function "choose_and_prepare_drive, without "parmanode" - fix later"

local text="   NOTE: 

    If you wish to use a drive from a different installation, like Umbrel, Mynode
    RaspiBlitz, or even a different ParmanodL, then please choose INTERNAL drive for
    now, and later opt to migrate an external drive in (from the Bitcoin menu). After
    that, choose to swap the internal/external drive choice from the Bitcoin menu.
"

while true
do
set_terminal
echo -e "
########################################################################################

    You have the option to use an external or internal hard drive for the $1
    data.

    Please choose an option:

                           (e) - Use an EXTERNAL drive

                           (i) - Use an INTERNAL drive:
"
if [[ $1 == Bitcoin ]] ; then
echo -e "$green" "$text" "$orange" ; fi 
echo "########################################################################################
"
choose "xpq" #echo statment about above options, previous menu, or quit.

read choice #user's choice stored in variable, choice

case $choice in
e | E)    #External drive setup

if [[ $1 == "Bitcoin" ]] ; then export drive="external"; parmanode_conf_add "drive=external" ; fi

if [[ $1 == "Fulcrum" ]] ; then export drive_fulcrum="external"
        parmanode_conf_add "drive_fulcrum=external"
fi

if [[ $1 == "Electrs" ]] ; then export drive_electrs="external"

        parmanode_conf_add "drive_electrs=external"
        
fi


return 0
;;

i | I)
        if [[ $1 == "Bitcoin" ]] ; then export drive="internal" ; parmanode_conf_add "drive=internal" ; fi

        if [[ $1 == "Fulcrum" ]] ; then export drive_fulcrum="internal" 
               parmanode_conf_add "drive_fulcrum=internal"
               fi
        if [[ $1 == "Electrs" ]] ; then export drive_electrs="internal" 
               parmanode_conf_add "drive_electrs=internal"
               fi

        return 0 
        ;;

q|Q|quit|QUIT|Quit)
        exit 0
        ;;
p|P)
        return 1 
        ;;
*)
        set_terminal
	invalid
        ;;  
esac
done
return 0
}
