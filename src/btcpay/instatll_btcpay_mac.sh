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
announce "To install BTCPay on a Mac, you need to first uninstall Bitcoin." \
"You don't need to delete the data directory. Parmanode will reinstall Bitcoin
    when you install BTCPay, together in a Docker container."
return 1
fi

install_btcpay_mac_child
success "Both BTCPay and Bitcoin have been installed"
}