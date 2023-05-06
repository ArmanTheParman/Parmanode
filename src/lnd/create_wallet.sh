function create_wallet {

if ! sudo systemctl status lnd.service >/dev/null ; then
    set_terminal ; echo "LND is not running. Start LND first."
    enter_continue ; return 1 ; 
fi

lncli create
}
