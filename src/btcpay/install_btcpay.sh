
# 2. Populate config files
#       ~/.nbxplorer/Main/settings.config
#       ~/.btcpayserver/Main/settings.config

# 3. make_postgress_database
    # user to put password (find interactive command,

function install_btcpay {

# message to user; confirmation

# check if docker is installed and install if needed.

user_pass_check_exists 
    if [ $? = 1 ] ; then return 1 ; fi

make_btcpay_directories

build_btcpay 

run_btcpay_docker



start_postgres && create_pg_databases
}