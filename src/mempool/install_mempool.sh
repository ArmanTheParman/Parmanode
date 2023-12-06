function install_mempool {

if ! grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
announce "Need to install Bitcoin first from Parmanode menu. Aborting." ; return 1 ; fi

if ! docker ps >/dev/null ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1 ; fi

# INTRO

cd $hp
git clone --depth 1 https://github.com/mempool/mempool.git
installed_config_add "mempool-start"

#set variables
cp $pn/src/mempool/docker-compose.yml $hp/mempool/docker

choose_mempool_backend
choose_mempool_LND
choose_mempool_tor

installed_conf_add "mempool-end"
success "Mempool" "being installed"
}


function choose_mempool_backend {

while true ; do

set_terminal ; echo -e "
########################################################################################

    What would you like Mempool to connect to for its data?


            1)      Bitcoin Core

            2)      Electrs

            3)      Fulcrum

            4)      Manual (can put details of server on another machine)

########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit ;;
p|P) return 1 ;;
m|M) back2main ;;
1)


;;
2)


;;
3)


;;
4)

;;
*) invalid ;;
esac
done



}