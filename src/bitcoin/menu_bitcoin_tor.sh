function menu_bitcoin_tor {

if ! which tor >$dn 2>&1 ; then set_terminal
install_tor
fi

if ! which tor >$dn 2>&1 ; then set_terminal
enter_continue "
    You need to install Tor first. Aborting.
    "
    return 1
fi

while true ; do
unset tortext
source $pc >$dn 2>&1 

if [[ $bitcoin_tor_status == "torandclearnet" ]] ; then
    local status_print="Clearnet & Tor (option 1)"
    local showtor="true"
elif [[ $bitcoin_tor_status == "toronly" ]] ; then
    local status_print="Tor enabled (option 2)"
    local showtor="true"
elif [[ $bitcoin_tor_status == "clearnet" ]] ; then
    local status_print="Clearnet (option 4)"
    unset  showtor
elif [[ $bitcoin_tor_status == "onlyout" ]] ; then
    local status_print="Strict Tor, Stealth (option 3)"
    local showtor="true"

elif [[ $bitcoin_tor_status == "tori2p" ]] ; then
    local status_print="Strict Tor and I2P (option 5)"
    local showtor="true"

elif [[ $bitcoin_tor_status == "i2p" ]] ; then
    local status_print="Strict I2P only (option 6)"
    unset showtor
elif [[ $bitcoin_tor_status == "i2ponlyout" ]] ; then
    local status_print="Strict I2P Stealth (option 7)"
    unset showtor
fi


if sudo cat $macprefix/var/lib/tor/bitcoin-service/hostname >$dn && [[ $showtor == "true" ]] ; then 
get_onion_address_variable bitcoin 
tortext="
$bright_blue    Onion adress: $ONION_ADDR
$orange
########################################################################################
"
else tortext="
########################################################################################
"
fi
set_terminal ; echo -e "
########################################################################################

$cyan                        Tor/I2P options for Bitcoin (Linux only)   $orange


    Option to change Bitcoin Tor Settings. Note if you use LND, it may stop running 
    and require some thinking time (minutes) before you can succesfully manually 
    restart it.

$cyan
    1)$orange    Allow Tor connections AND clearnet connections
                 - Helps you and the network overall
$cyan
    2)$orange    Force Tor only connections
                 - Extra private but only helps the Tor network of nodes
   $cyan 
    3)$orange    Force Tor only OUTWARD connections
                 - Only helps yourself but most private of all options
                 - You can connect to tor nodes, they can't connect to you
$cyan
    4)$orange    Make Bitcoin public (Remove Tor usage and stick to clearnet)
                 - Generally faster and more reliable
$cyan
    5)$orange    I2P and Tor (no clearnet)
$cyan
    6)$orange    I2P only (no clearnet, no Tor)
$cyan
    7)$orange    Stealth I2P, only OUTWARD connections


$bright_magenta    Current Status: $status_print$orange
$tortext"

choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; Q|q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
"1")
    bitcoin_tor "torandclearnet" 
#    check_bitcoin_tor_status #sets status in parmanode.conf #delete this function later
    remove_bitcoin_i2p
    if [[ $install == "bitcoin" ]] ; then return 0 ; fi
    continue ;;

"2")
    bitcoin_tor "toronly" 
#    check_bitcoin_tor_status
    remove_bitcoin_i2p
    if [[ $install == "bitcoin" ]] ; then return 0 ; fi
    continue ;;

"3")
    bitcoin_tor "toronly" "onlyout" #both $1 and $2 needed
#    check_bitcoin_tor_status
    remove_bitcoin_i2p
    if [[ $install == "bitcoin" ]] ; then return 0 ; fi
    continue ;;

"4")
    bitcoin_tor_remove 
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=clearnet"
#    check_bitcoin_tor_status    
    remove_bitcoin_i2p
    if [[ $install == "bitcoin" ]] ; then return 0 ; fi
    continue ;;
"5")
    bitcoin_tor "toronly"
#    check_bitcoin_tor_status
    bitcoin_i2p
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=tori2p"
    if [[ $install == "bitcoin" ]] ; then return 0 ; fi
    continue ;;
"6") 
    if ! grep -q "i2p-end" $ic ; then install_i2p || { sww ; continue ; } ; fi
    bitcoin_tor_remove
    parmanode_conf_remove "bitcoin_tor_status"
#    check_bitcoin_tor_status
    bitcoin_i2p 
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=i2p"
    if [[ $install == "bitcoin" ]] ; then return 0 ; fi
    continue ;;
"7") 
    if ! grep -q "i2p-end" $ic ; then install_i2p || { sww ; continue ; } ; fi
    bitcoin_tor_remove
    parmanode_conf_remove "bitcoin_tor_status"
#    check_bitcoin_tor_status
    bitcoin_i2p 
    sudo gsed -i "/discover=/d" $bc >$dn 2>&1
    echo "discover=0" | sudo tee -a $bc >$dn 2>&1
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=i2ponlyout"
    if [[ $install == "bitcoin" ]] ; then return 0 ; fi
    continue ;;


"")
break ;;
*)
    invalid ;;
esac

done
}


function bitcoin_i2p {
    echo "onlynet=i2p" | sudo tee -a $bc >$dn 2>&1
    echo "i2psam=127.0.0.1:7656" | sudo tee -a $bc >$dn 2>&1
    echo "i2pacceptincoming=1" | sudo tee -a $bc >$dn 2>&1
    echo "proxy=127.0.0.1:9050" | sudo tee -a $bc >$dn 2>&1 #always need it, settings don't need it, so always remove when removing i2p
}

function remove_bitcoin_i2p {
    sudo gsed -i "/onlynet=i2p/d" $bc  > $dn 2>&1
    sudo gsed -i "/i2psam=/d" $bc  > $dn 2>&1
    sudo gsed -i "/i2pacceptincoming=/d" $bc > $dn 2>&1
    sudo gsed -i "/proxy=127/d" $bc > $dn 2>&1
}