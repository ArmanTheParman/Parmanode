function menu_log_config {
unset message_menu_log_config
# the "." below at the start of the line is another way to write "source"
# source will "run" the file specified.
# sourcing is necessary to see if the variable below is set, hiding the message.
. $HOME/.parmanode/hide_messages.conf >$dn

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
    the file of your choice using the \"less\" command. You can scroll up and down
    with the arrows, and press (q) to exit back to the menu.

    You could also just view them directly yourself if you're comfortable navigating
    your computer's file system. Most are located in$cyan $HOME/.parmanode/ $orange
    (Note the \".\", that's not an accident)

    Hit$cyan <enter>$orange to continue 

    or 

    Type (${red}EndTheFed$orange) then hit$cyan <enter>$orange to hide only this message next time    

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "menu_log_config" "1" ; break ;;
# The above function results in a variable message_menu_log_config=1 set in a config file.
# Which results in hiding the message next time, because of the if statement at the start.
q|Q) exit ;; p|P) return ;; m|M) back2main ;;
'') break ;;
*) invalid ;;
esac
done
fi

while true ; do set_terminal ; echo -en "
########################################################################################$cyan

                      PARMANODE LOG AND CONFIGURATION FILES $orange

########################################################################################

$cyan
                     pa)$orange            parmanode_all.log
$cyan
                     ic)$orange            installed.conf                    
$cyan
                     pc)$orange            parmanode.conf
$cyan
                     delete)$orange        DELETE ALL LOGS (not conf)
$cyan
                     uh)$orange            Unhide messages (if you hid them with 'EndTheFed'
$orange

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
m|M) back2main ;;
q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 1 ;;

ic) less $HOME/.parmanode/installed.conf ;;
pc) less $HOME/.parmanode/parmanode.conf ;;
pa) set_terminal 38 110 ; less $HOME/.parmanode/parmanode_all.log ; set_terminal ;;
delete|DELETE|Delete) 
rm $HOME/.parmanode/*.log >$dn 2>&1 ; echo "" ; echo "Deleting" ; sleep 0.5 ; return 0 ;;
uh) rm $HOME/.parmanode/hide_messages.conf >$dn 2>&1 ; return 0 
;;
*) invalid ;;
esac
done

return 0 
}
