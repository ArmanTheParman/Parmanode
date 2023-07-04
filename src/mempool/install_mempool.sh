function install_mempool {
if [[ $dockerexitmem != 1 ]] ; then

if [[ $1 != "resume" ]] ; then
{
if [[ $(uname -m) == "aarch64" || $(uname -m) == "armv71" ]] ; then 
    pi4_warning
    if [ $? == 1 ] ; then return 1 ; fi
fi

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
    esac ; done ; fibtcp
cd $HOME/parmanode
git_check #installs if not istalled
git clone http://github.com/mempool/mempool.git
cd mempool/docker

if ! which docker ; then
    if [[ $OS == "Linux" ]] ; then install_docker_linux "mempool" ; fi
    if [[ $OS == "Mac" ]] ; then download_docker_mac ; fi
fi

}

else
installed_config_remove "mempool-half"
set_terminal ; echo "Resuming Mempool install" ; enter_continue
fi

if [[ $OS == "Linux" ]] ; then
    if ! id | grep docker ; then 
        docker_troubleshooting
        add_docker_group
        fi
fi

else
set_terminal
echo " Resuming Mempool install. Type x to do this later and reach main menu."
echo " You'll need to exit Parmanode and return to install Mempool, or you"
echo " could attempt to install it again from the menu, it should pick up"
echo " where it left off."
read choice
case $choice in x|X) return 0 ;; esac
parmanode_conf_remove "dockerexitmem"
unset dockerexitmem
fi # end if dockerexit !=1 -- ie resume here if program exited during docker install.

if [[ $OS == "Mac" ]] ; then 
    if ! docker ps >/dev/null 2>&1 ; then start_docker_mac ; fi
fi

make_docker_compose

installed_conf_add "mempool-end"

cd $HOME/parmanode/mempool/docker && docker compose up -d

set_terminal ; echo "
########################################################################################

                                   S U C C E S S ! 

    Mempool Space has finished being installed. It may take a few days for the backend
    to synchronise. You can access the webpage at $IP:4080

    You can take a look before the synchronisation is finished; more info will appear
    once it's done.

########################################################################################
"
enter_continue
return 0
}

