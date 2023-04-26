function install_btcpay_linux {

# Install checks...

    install_check "btcpay" ; if [ $? == 1 ] ; then return 1 ; fi

    if ! command -v bitcoin-cli ; then
    set_terminal
    echo "Bitcoin doesn't seem to be installed. Please do that first before installing BTCPay Server."
    enter_continue
    return 1
    fi

user_pass_check_exists 
    return_status=$?
    if [ $return_status == 1 ] ; then return 1 ;

    


}
# 2. Populate config files
#       ~/.nbxplorer/Main/settings.config
#       ~/.btcpayserver/Main/settings.config

# 3. make_postgress_database
    # user to put password (find interactive command,

function install_btcpay {

# message to user; confirmation

# check if docker is installed and install if needed.



make_btcpay_directories

build_btcpay 

run_btcpay_docker

start_postgres && create_pg_databases
}