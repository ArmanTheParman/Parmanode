function install_btcpay_mac {

#make sure docker installed
grep -q "docker-end" $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

#start docker if it is not running 
if ! docker ps >/dev/null 2>&1 ; then 
    announce "Please make sure Docker is running, then try again. Aborting."
    return 1
fi

#preambles
btcpay_install_preamble  || return 1
btcpay_install_preamble2 || return 1

if grep -q "bitcoin-end" < $ic ; then
while true ; do
set_terminal ; echo -e "
########################################################################################


    To install BTCPay on a Mac,$red you need to first uninstall Bitcoin.$orange You don't need 
    to delete the data directory. Parmanode will reinstall Bitcoin when you install 
    BTCPay, together in a Docker container.


    Initiate Bitcoin uninstallation for you now?

$green
                        y)$orange      Yes, uninstall Bitcoin
$green
                        n)$orange      No, abort


########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) uninstall_bitcoin || return 1 ; break ;;
n) return 1 ;;
*) invalid ;;
esac 
done
fi

export btcpay_combo="true"
install_bitcoin #btcpay_combo unset at the end of function 
install_btcpay_mac_child

unset btcdockerchoice btcpay_combo

if ! docker exec btcpay ps | grep -q bitcoind ; then docker exec btcpay bitcoind ; fi

installed_config_add "bitcoin-end"
installed_config_add "btcpay-end"
installed_config_add "btccombo-end"
success "Both BTCPay and Bitcoin have been installed"
}