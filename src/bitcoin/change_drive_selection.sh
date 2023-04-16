# CHECK CONFIG FOR DRIVE CHOICE, AND OFFER USER TO SWAP CHOICE.

function change_drive_selection {
source $HOME/.parmanode/parmanode.conf

while true
do
set_terminal
if [[ -z "$drive" ]] ; then set_terminal ; echo "No drive choice. Something went wrong. Please re-install Parmanande." ; return 2 ; fi
echo "
########################################################################################
    
         You have chosen an $drive drive to run the Bitcoin blockchain data.

                            (a) to accept and continue

                            (c) to change

########################################################################################
"
choose "xpq"
read choice

    case $choice in

    a|A)        #user accepts previous drive choice
        delete_line "$HOME/.parmanode/parmanode.conf" "drive="  >/dev/null  #clean up potential multiple entries before writing.
        echo "drive=$drive" >> "$HOME/.parmanode/parmanode.conf" 2>/dev/null
        break ;;
    c|C)        #user wishes to change previous drive choice
        set_terminal
        echo "Please choose internal (i) or external (e), then <enter>.
        "
        read drive_swap_choice
        #check for valid choice and rename value.
            if [[ $drive_swap_choice != "i" && $drive_swap_choice != "e" ]] ; then invalid ; continue ; fi
            if [[ $drive_swap_choice == "i" ]] ; then drive_swap_choice="internal" ; fi # saves user from typing "internal" and reduce risk of typo in value.
            if [[ $drive_swap_choice == "e" ]] ; then drive_swap_choice="external" ; fi
            if [[ $drive_swap_choice == "$drive" ]] # if user ended up choosing what they had already chose before.
		    then
			echo "No change made, continuing. Hit <enter>." ; read ; break
		    else
			delete_line "$HOME/.parmanode/parmanode.conf" "drive="  >/dev/null  #clean up potential multiple entries before writing.
			echo "drive=$drive_swap_choice" >> "$HOME/.parmanode/parmanode.conf" 2>/dev/null
			source $HOME/.parmanode/parmanode.conf #updates drive variable for this shell session.
            fi
            ;;
        p|P)
        return 1 ;;
        q|Q|quit|QUIT)
        exit 0 ;;
        *)
        invalid
        ;;
        esac
done
return 0
}
