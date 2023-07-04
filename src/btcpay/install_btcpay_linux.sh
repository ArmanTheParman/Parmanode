function install_btcpay_linux {
set_terminal
if [[ $dockerexitbtcpay != 1 ]] ; then
if [[ "$1" != "resume" ]] ; then #btcpay-half flag triggers run_parmanode to start this function with "resume" flag
{
    # Install checks...
    install_check "btcpay"
        if [ $? == 1 ] ; then return 1 ; fi

    if ! command -v docker >/dev/null 2>&1 ; then

        need_docker_for_btcpay || return 1  #docker="no" or docker="yes" set

        if [[ $docker == "yes" ]] ; then install_docker_linux "btcpay" || return 1 ; fi

    fi
}
else
installed_config_remove "btcpay-half"
set_terminal ; echo "Resuming BTCPay install" ; enter_continue
fi


    if ! id | grep docker ; then 
        add_docker_group
            if ! id | grep docker ; then
            docker_troubleshooting
            fi
        fi
else
set_terminal
echo " Resuming BTCPay install. Type x to do this later and reach main menu."
echo " You'll need to exit Parmanode and return to install BTCPay, or you"
echo " could attempt to install it again from the menu, it should pick up"
echo " where it left off."
read choice
case $choice in x|X) return 0 ;; esac
parmanode_conf_remove "dockerexitbtcpay"
unset dockerexitbtcpay
fi # end if dockerexit !=1 -- ie resume here if program exited during docker install.

    if ! command -v bitcoin-cli >/dev/null 2>&1 ; then
    set_terminal
    echo "Bitcoin doesn't seem to be installed. Please do that first before installing BTCPay Server."
    echo "If you wish to ignore this advice at your own risk, type yolo and <enter>"
    echo "Otherwise, hit <enter> to exit"
    read choice

    if [[ $choice != "yolo" ]] ; then
    export bitcoin="yolo"
    return 1
    fi

    fi

while true ; do user_pass_check_exists 
    return_status=$?
    if [ $return_status == 1 ] ; then return 1 ; fi
    if [ $return_status == 2 ] ; then set_rpc_authentication ; break ; fi
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
{ startup_postgres "install" \
&& log "btcpay" "startup postgress function completed" ; } \
|| { log "btcpay" "startup postgress function failed" && return 1 ; }

sleep 4
log "btcpay" "entering run_nbxplorer.."
run_nbxplorer >> $HOME/parmanode/nbx_extra_log.log
    if [ $? == 1 ] ; then return 1 ; fi

sleep 4
log "btcpay" "entering run_btcpay..."
run_btcpay
    if [ $? == 1 ] ; then return 1 ; fi


installed_config_add "btcpay-end"
mkdir $HOME/parmanode/startup_scripts/ >/dev/null 2>&1
make_btcpay_startup_script
success "BTCPay Server" "being installed."
log "btcpay" "Btcpay install success"
return 0
}