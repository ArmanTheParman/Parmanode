function install_mempool {
set_terminal
install_check "mempool" || return 1

source $HOME/.bitcoin/bitcoin.conf

if [[ -z $rpcuser ]] ; then
    while true ; do
    set_terminal
    echo "A Bitcoind username and password needs to be set for Mempool Space"
    echo "to work. Set it now? (y) (n)"
    read choice
    case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 1 ;;
    n|N) echo "OK then, aborting installation." ; sleep 2 ; return 1 ;;
    y|Y|"") set_rpc_authentication && break ;;
    *) invalid ;;
    esac ; done ; fi


cd $HOME/parmanode
git_check #installs if not istalled
git clone http://github.com/mempool/mempool.git

cd mempool/docker
if ! which docker ; then install_docker_linux ; fi
make_docker_compose

installed_conf_add "mempool-end"
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

