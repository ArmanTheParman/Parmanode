function menu_btcpay_tor {

no_mac || return 1

btcpay_onion="$(sudo cat /var/lib/tor/btcpayTOR-server/hostname)"

set_terminal ; echo -e "
########################################################################################
                         $cyan BTCPay over Tor Menu$orange 
########################################################################################

    To access your BTCPay Server over Tor, you need to enter the onion address below
    (and port) into a Tor browser. You can do this from any computer, on any
    operating system.   

    Onion address: 
    
    http://${btcpay_onion}:7003

########################################################################################
"
enter_continue
return 0
}