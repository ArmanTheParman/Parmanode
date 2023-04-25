function user_pass_check_exists {
if ! cat $SHOME/.bitcoin/bitcoin.conf | grep "rpcuser=" ; then
    set_terminal ; echo "
########################################################################################    
    A Bitcoin username and password has not been set. Please do that through the
    Parmanode Bitcoin menu and come back and attempt to install BTCpay Server again.
########################################################################################    
"
enter_continue ; return 1
else 
return 0
fi
}