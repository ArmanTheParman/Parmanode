function install_btcpay_linux {

if [[ $1 != "resume" ]] ; then #btcpay-half flag triggers run_parmanode to start this function with "resume" flag
{
    # Install checks...
    install_check "btcpay"
        if [ $? == 1 ] ; then return 1 ; fi

    if ! command -v docker >dev/null 2>&1 ; then

        need_docker_for_btcpay || return 1  #docker="no" or docker="yes" set

        if [[ $docker == "yes" ]] ; then install_docker_linux "btcpay" || return 1 ; fi

    fi
}
else
installed_config_remove "btcpay-half"
set_terminal ; echo "Resuming BTCPay install" ; enter_continue
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
startup_postgres \
&& log "btcpay" "startup postgress function completed" \
|| log "btcpay" "startup postgress function failed"

sleep 4
log "btcpay" "entering run_nbxplorer.."
run_nbxplorer >> $HOME/parmanode/nbx_extra_log.log
    if [ $? == 1 ] ; then return 1 ; fi

sleep 4
log "btcpay" "entering run_btcpay..."
run_btcpay
    if [ $? == 1 ] ; then return 1 ; fi

installed_config_add "btcpay-end"
success "BTCPay Server" "being installed."
log "btcpay" "Btcpay install success"
return 0
}