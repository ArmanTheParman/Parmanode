function install_mempool {

if ! grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
announce "Need to install Bitcoin first from Parmanode menu. Aborting." ; return 1 ; fi

if ! grep -q "rpcallowip=172.18.0.0/16" < $bc >/dev/null 2>&1 ; then
echo "rpcallowip=172.18.0.0/16" | tee sudo -a $bc >/dev/null 2>&1 ;
fi

if ! docker ps >/dev/null ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1 ; fi

source $bc
if [[ $txindex != 1 ]] ; then announce "Sorry, txindex=1 needs to be in the bitcoin.conf file for Mempool to work.
    Type 'yolo' and <enter> to ignore warning, otherwise aborting."
    read choice
    if [[ $choice != yolo ]] ; then return 1 ; fi
fi

if [[ $server != 1 ]] ; then announce "Sorry, server=1 needs to be in the bitcoin.conf file for Mempool to work.
    Type 'yolo' and <enter> to ignore warning, otherwise aborting."
    read choice
    if [[ $choice != yolo ]] ; then return 1 ; fi
fi

# INTRO

cd $hp
git clone --depth 1 https://github.com/mempool/mempool.git
#make sure mounted dir permission is correct (Pi is not 1000:1000, so these dir's will not be readable by container.)
sudo chown -R 1000:1000 $hp/mempool/docker/data $hp/mempool/docker/mysql >/dev/null
installed_config_add "mempool-start"

#set variables
make_mempool_docker_compose
cp /tmp/docker-compose.yml $hp/mempool/docker/docker-compose.yml
debug "/tmp/docker-compose.yml copied?"
rm /tmp/docker-compose.yml >/dev/null 2>&1
mempool_backend
#choose_mempool_LND
#choose_mempool_tor

cd $hp/mempool/docker 
docker-compose up -d

#Final check to make sure the docker gatway IP is included in bitcoin.conf
string="$(docker network inspect docker_PM_network | grep Gateway | awk '{print $2}' | tr -d ' ' | tr -d \" | cut -d \. -f 1)"
if [[ $string == 172 ]] ; then #would be unusualy for it not to be 172
    #expecting 17 or 18
    string2="$(docker network inspect docker_PM_network | grep Gateway | awk '{print $2}' | tr -d ' ' | tr -d \" | cut -d \. -f 2)"
    target="172.$string2.0.0/16"
    if ! grep "$target" < $bc >/dev/null 2>&1 ; then
    echo "$target" | sudo tee -a $bc >/dev/null 2>&1
    sudo systemctl restart bitcoind.service
    restart_mempool
    fi
else
    #even if the gateway does not start with 172, add it to bitcoin.conf
    stringIP="$(docker network inspect docker_PM_network | grep Gateway | awk '{print $2}' | tr -d ' ' | tr -d \" )"
    echo "$stringIP"/16 | sudo tee -a $bc >/dev/null 2>&1
    sudo systemctl restart bitcoind.service
    restart_mempool
fi

installed_conf_add "mempool-end"
success "Mempool" "being installed"
}