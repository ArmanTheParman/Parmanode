function install_btcpay_linux {

# Install checks...

    install_check "btcpay" ; if [ $? == 1 ] ; then return 1 ; fi

    if ! command -v bitcoin-cli ; then
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
    
make_btcpay_directories # .btcpayserver and .nbxplorer
    if [ $? == 1 ] ; then return 1 ; fi

btcpay_config
    if [ $? == 1 ] ; then return 1 ; fi

nbxplorer_config
    if [ $? == 1 ] ; then return 1 ; fi

build_btcpay 
    if [ $? == 1 ] ; then return 1 ; fi

run_btcpay_docker
    if [ $? == 1 ] ; then return 1 ; fi

}


# 3. make_postgress_database
    # user to put password (find interactive command,


# message to user; confirmation

# check if docker is installed and install if needed.






run_btcpay_docker

start_postgres && create_pg_databases
}