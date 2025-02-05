function menu_bitcoin_tor {

if ! which tor >$dn 2>&1 ; then set_terminal
install_tor
fi

if ! which tor >$dn 2>&1 ; then set_terminal
enter_continue "
    You need to install Tor first. Aborting.
    "
    return 0
fi

while true ; do
unset tortext
source $dp/parmanode.conf >$dn 2>&1 

if [[ $bitcoin_tor_status == t ]] ; then
    local status_print="Tor enabled (option 2)"

elif [[ $bitcoin_tor_status == c ]] ; then
    local status_print="Clearnet (option 4)"

elif [[ $bitcoin_tor_status == tc ]] ; then
    local status_print="Clearnet & Tor (option 1)"

elif [[ $bitcoin_tor_status == tonlyout ]] ; then
    local status_print="Strict Tor, only out (option 3)"

fi


if sudo cat $macprefix/var/lib/tor/bitcoin-service/hostname >$dn && [[ $bitcoin_tor_status != c ]] ; then 
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

$cyan                        Tor options for Bitcoin (Linux only)   $orange


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


$bright_magenta    Current Status: $status_print$orange
$tortext"

choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; Q|q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
"1")
    bitcoin_tor "torandclearnet" 
    check_bitcoin_tor_status #sets status in parmanode.conf
    menu_bitcoin ;; #refreshes above while loop 
"2")
    bitcoin_tor "toronly" 
    check_bitcoin_tor_status
    menu_bitcoin ;; #refreshes above while loop
"3")
    bitcoin_tor "toronly" "onlyout" 
    check_bitcoin_tor_status
    menu_bitcoin ;; #refreshes above while loop
"4")
    bitcoin_tor_remove 
    check_bitcoin_tor_status    
    menu_bitcoin ;; #refreshes above while loop
*)
    invalid ;;
esac

done
}

