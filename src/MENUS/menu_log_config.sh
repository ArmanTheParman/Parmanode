function menu_log_config {
unset message_menu_log_config
# the "." below at the start of the line is another way to write "source"
# source will "run" the file specified.
# sourcing is necessary to see if the variable below is set, hiding the message.
. $HOME/.parmanode/hide_messages.conf >/dev/null

# The variable $message_menu_log_config can't be found with a simple search becuase it
# is created in the function, hide_message_add, by concatinating "message_" with 
# "menu_log_config" which is passed as a different variable.
# It's a bit ugly, and I'd do it better next time. To fix one day.
``
if [[ $message_menu_log_config != "1" ]] ; then 
while true ; do
set_terminal ; echo -e "
########################################################################################

    Various log and configuration files are available to view. Parmanode will open
    the file of your choise using the \"less\" command. You can scroll up and down
    with the arrows, and press (q) to exit back to the menu.

    You could also just view them directly yourself if you're comfortable navigating
    your computer's file system. Most are located in $HOME/.parmanode/
    (Note the \".\", that's not an accident)

    Hit <enter> to continue 

    or 

    Type (Free Ross) then hit <enter> to hide this message next time    

########################################################################################
"
choose "xpmq" ; read choice
case $choice in 
"Free Ross"|"free ross"|"free Ross") hide_messages_add "menu_log_config" "1" ; break ;;
# The above function results in a variable message_menu_log_config=1 set in a config file.
# Which results in hiding the message next time, because of the if statement at the start.
q|Q) exit ;; p|P) return ;; 
m|M) back2main ;;
'') break ;;
*) invalid ;;
esac
done
fi

while true ; do set_terminal ; echo -e "
########################################################################################
$cyan
                      PARMANODE LOG AND CONFIGURATION FILES $orange


                        pa)            parmanode_all.log

                        ic)            installed.conf                    

                        pc)            parmanode.conf

$pink
                        delete)        DELETE ALL LOGS (not conf)

                        uh)            Unhide messages (you hid them with \"FREE ROSS\")
$orange
########################################################################################
"
choose "xpmq" ; read choice
case $choice in
m|M) back2main ;;
q|Q|Quit|QUIT|quit) exit 0 ;;
p|P) return 1 ;;

ic) less $HOME/.parmanode/installed.conf ;;
pc) less $HOME/.parmanode/parmanode.conf ;;
pa) less $HOME/.parmanode/parmanode_all.log ;;
delete|DELETE|Delete) 
rm $HOME/.parmanode/*.log >/dev/null 2>&1 ; echo "" ; echo "Deleting" ; sleep 0.5 ; return 0 ;;
uh) rm $HOME/.parmanode/hide_messages.conf >/dev/null 2>&1 ; return 0 
;;
*) invalid ;;
esac
done

return 0 
}