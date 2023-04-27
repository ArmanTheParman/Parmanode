function install_btcpay_linux {

if [ -z $1 ] ; then
{
    # Install checks...
    install_check "btcpay"
        if [ $? == 1 ] ; then return 1 ; fi

    if ! command -v docker >dev/null 2>&1 ; then

        need_docker_for_btcpay || return 1 

        install_docker_linux "btcpay" || return 1

        fi
}
else
installed_config_remove "btcpay-half"
fi

    if ! command -v bitcoin-cli >/dev/null 2>&1 ; then
    set_terminal
    echo "Bitcoin doesn't seem to be installed. Please do that first before installing BTCPay Server."
    enter_continue
    return 1
    fi

while true ; do user_pass_check_exists 
    return_status=$?
    if [ $return_status == 1 ] ; then return 1 ; fi
    if [ $return_status == 2 ] ; then continue ; fi
    if [ $return_status == 0 ] ; then break ; fi 
    done
    
log "btcpay" "entering make_btcpay_directories..."
make_btcpay_directories 
    # installed config modifications done
    # .btcpayserver and .nbxplorer
    if [ $? == 1 ] ; then return 1 ; fi

log "btcpay" "entering btcpay_config..."
btcpay_config
    if [ $? == 1 ] ; then return 1 ; fi

log "btcpay" "entering nbxplorer_config..."
nbxplorer_config
    if [ $? == 1 ] ; then return 1 ; fi

log "btcpay" "entering build_btcpay..."
build_btcpay 
    if [ $? == 1 ] ; then return 1 ; fi

log "btcpay" "entering run_btcpay_docker..."
run_btcpay_docker
    if [ $? == 1 ] ; then return 1 ; fi

log "btcpay" "entering start_postgress..."
start_postgres && create_pg_databases

log "btcpay" "entering run_nbxplorer.."
run_nbxplorer
    if [ $? == 1 ] ; then return 1 ; fi

log "btcpay" "entering run_btcpay..."
run_btcpay
    if [ $? == 1 ] ; then return 1 ; fi

installed_config_add "btcpay-end"
success "BTCPay Server" "installed."
return 0
}