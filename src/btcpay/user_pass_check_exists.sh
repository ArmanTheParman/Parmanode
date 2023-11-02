function user_pass_check_exists {
if ! cat $HOME/.bitcoin/bitcoin.conf | grep "rpcuser=" >/dev/null 2>&1 ; then

while true ; do set_terminal ; echo -e "
########################################################################################    

    A Bitcoin username and password has not been set. Please do that through the
    Parmanode Bitcoin menu and come back and attempt to install BTCpay Server again.

                           now)   Or, do it now
                           
                           L)     Later (exiting BTCPay install)
 
########################################################################################    
"
choose "xpmq" ; read choice
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 1 ;;
m) back2main ;;
now|Now|NOW|n|N) return 2 ;;
l|L|later|LATER|Later) return 1 ;;
*) invalid ;;
esac
done

else 
return 0
fi
}