function install_mempool {

install_check "mempool" || return 1

cd $HOME/parmanode

git clone http://github.com/mempool/mempool.git

cd mempool/docker

make_docker_compose

installed_conf_add "mempool"
docker compose up -d

set_terminal ; echo "
########################################################################################

                                   S U C C E S S ! 

    Mempool Space has finished being installed. It may day a few days for the backend
    to synchronise. You can access the webpage at $IP:4080

    You can take a look before the synchronisation is finished; more info will appear
    once it's done.

########################################################################################
"
enter_continue
return 0
}

