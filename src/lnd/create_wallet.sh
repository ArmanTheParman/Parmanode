function create_wallet {

if ! sudo systemctl status lnd.service >/dev/null ; then
    set_terminal ; echo "LND is not running. Start LND first."
    enter_continue ; return 1 ; 
fi

if lncli walletbalance >/dev/null 2>&1 ; then 
announce "You already have an LND wallet, and it's unlocked. Please delete the 
    wallet first if you want to create a new one."
return 1
fi

set_terminal
lnd_wallet_info
set_terminal
echo -e "$cyan You will be asked to create a password - this is for your LND password, not passphrase.$orange
"
lncli create
enter_continue
}
