function user_pass_check_exists {
if ! cat $HOME/.bitcoin/bitcoin.conf | grep "rpcuser=" >$dn 2>&1 ; then

while true ; do set_terminal ; echo -e "
########################################################################################    

    A Bitcoin username and password have not been set. Please do that through the
    Parmanode Bitcoin menu and come back and attempt to install BTCpay Server again.
$cyan
                           now)$orange   Or, do it now
$cyan                           
                           L)$orange     Later (exiting BTCPay install)
 
########################################################################################    
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 1 ;;
m|M) back2main ;;
now|Now|NOW|n|N) return 2 ;;
l|L|later|LATER|Later) return 1 ;;
*) invalid ;;
esac
done

else 
return 0
fi
}
