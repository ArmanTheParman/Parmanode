function check_rpc_bitcoin {
unset rpcuser

source $pc
if [[ $bitcoin_choice_with_lnd == remote ]] ; then return 0 ; fi

source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
if [ -z $rpcuser ] ; then
set_terminal ; echo -e "
########################################################################################    

    The program won't work unless Bitcoin Core has a username and password set.

    Would you like to set that now?    
    
                      $green           y$orange   or $red   n $orange

######################################################################################## 
"    
read choice

    case $choice in 
    y|Y|YES|Yes|yes) 
    please_wait ; set_rpc_authentication "s" && return 0
    return 1
    ;;
    esac
fi
return 0
}