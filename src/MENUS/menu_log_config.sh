function menu_log_config {

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
set_terminal ; echo "
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
choose "xpq" ; read choice
case $choice in 
"Free Ross"|"free ross"|"free Ross") hide_messages_add "menu_log_config" "1" ;;
# The above function results in a variable message_menu_log_config=1 set in a config file.
# Which results in hiding the message next time, because of the if statement at the start.
esac
fi

while true ; do set_terminal ; echo -e "
########################################################################################

$cyan                         Parmanode log and configuration files $orange

                        bc)            bitcoin.conf
                        bl)            bitcoin.log
                        btcpc)         settings.conf (for BTCPay)
                        btcpl)         btcpay.log
                        fc)            fulcrum.conf
                        fl)            fulcrum.log
                        ic)            installed.conf                    
                        nbxpc)         settings.conf (for NBXplorer)
                        pc)            parmanode.conf
                        pl)            parmanode.log

                        pa)            parmanode_all.log

                        delete)        DELETE ALL LOGS (not conf)

########################################################################################
"
choose "xpq" ; read choice
case $choice in
q|Q|Quit|QUIT|quit) exit 0 ;;
p|P) return 1 ;;

bc) less $HOME/.bitcoin/bitcoin.conf ;;
bl) less $HOME/.parmanode/bitcoin.log ;;
btcpc) less $HOME/.btcpayserver/Main/settings.config ;;
btcpl) less $HOME/.parmanode/btcpay.log ;;
fc) less $HOME/parmanode/fulcrum/fulcrum.conf ;;
fl) less $HOME/.parmanode/fulcrum.log ;;
ic) less $HOME/.parmanode/installed.conf ;;
nbxpc) less $HOME/.nbxplorer/Main/settings.config ;;
pc) less $HOME/.parmanode/parmanode.conf ;;
pl) less $HOME/.parmanode/parmanode.log ;;
pa) less $HOME/.parmanode/parmanode_all.log ;;
delete|DELETE|Delete) rm $HOME/.parmanode/*.log >/dev/null 2>&1 ; echo "" ; echo "Deleting" ; sleep 0.5 ; return 0 ;;
*) invalid ;;
esac
done

return 0 
}