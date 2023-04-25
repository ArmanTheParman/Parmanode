
# 2. Populate config files
#       ~/.nbxplorer/Main/settings.config
#       ~/.btcpayserver/Main/settings.config

# 3. make_postgress_database
    # user to put password (find interactive command,

function install_btcpay {

# message to user; confirmation

# check if docker is installed and install if needed.

user_pass_check 
    if [ $? = 1 ] ; then return 1 ; fi

make_btcpay_directories

# make config files
    touch ~/.btcpayserver/Main/settings.config && touch ~/.nbxplorer/Main/settings.config && \
    log "btcpay" "config files made on host" || log "btcpay" "failed to make config files on host" && \
    return 1

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

function run_btcpay_docker {

docker run -d 
           --name btcpay 
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
          
           btcpay
    
    # Notes:
    # make sure the 8080 port is not duplicated when other programs, eg RTL, are added.
    # 49392 is for REST API
    # 9735 is not needed by BTCpay; LND uses that for LN protocol communication

}

function user_pass_check {
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

function nbxplorer_config {
source <(cat $HOME/.bitcoin/bitcoin.conf | grep "rpcuser=")
source <(cat $HOME/.bitcoin/bitcoin.conf | grep "rpcpassword=")
source $HOME/.parmanode/parmanode.conf  #get postgres user and password

echo "
btc.rpc.auth=${rpcuser}:${rpcpassword}
port=24445
mainnet=1
postgres=User ID=$postgres_user;Password=$postgress_password;Host=localhost;Port=5432;Database=nbxplorer;
" | tee $HOME/.nbxplorer/Main/settings.config || \
    {log "nbxplorer" "failed to make settings.config" && \
    log "nbxplorer" "failed to make settings.config" && errormessage && return 1 ; }

log "nbxplorer" "end nbxplorer_config" && return 0
}

function create_pg_database { #probably need to runa from inside the container
#info..


#create postgres user
    sudo -i -u postgres

  

#create databases
    createdb -O parman btcpayserver
    createdb -O parman nbxplorer

#alternative
su - postgres -c "createdb -O parman parman_db"
}

function postgres_create { #create database user

docker exec -d 


}