function choose_and_prepare_drive_parmanode {
# Expect argument, either Bitcoin or Fulcrum or Electrs for $1
# chooses between internal and external drive
# Should have called the function "choose_and_prepare_drive, without "parmanode" - fix later"

while true
do
set_terminal
echo "
########################################################################################

    You have the option to use an external or internal hard drive for the $1
    data.

    Please choose an option:

                           (e) - Use an EXTERNAL drive

                           (i) - Use an INTERNAL drive:

########################################################################################
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
