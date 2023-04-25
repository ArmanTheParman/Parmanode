
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

}

function make_btcpay_directories {
#delete existing; check with user.
mkdir -p ~/.btcpayserver/Main ~/.nbxplorer/Main && \
  log "btcpay" ".btcpayserver mkdir success" && return 0 \
  || return 1 && log "btcpay" "mkdir .bitpayserver & .nbxploerer failed"
}

function build_btcpay {

docker build -t btcpay ./src/btcpay && \
    log "btcpay" "build succes" && return 0 || log "btcpay" "build failure" && \
    return 1
}


function user_pass_check_exists {
if ! cat $SHOME/.bitcoin/bitcoin.conf | grep "rpcuser=" ; then
    set_terminal ; echo "
########################################################################################    
    A Bitcoin username and password has not been set. Please do that through the
    Parmanode Bitcoin menu and come back and attempt to install BTCpay Server again.
########################################################################################    
"
enter_continue ; return 1
else 
return 0
fi
}



function create_pg_database { #probably need to run from inside the container

docker exec -d -u postgres btcpay /bin/bash -c "createdb -O parman btcpayserver && \
                                                createdb -O parman nbxplorer" && \
log "btcpay" "2 databases created" || \
log "btcpay" "2 databases failed to be created" 

function postgres_create { #create database user
docker exec -d 
}

function start_postgres {
/usr/bin/pg_ctlcluster 13 main start
}