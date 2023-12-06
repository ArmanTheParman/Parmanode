function install_mempool {
export file="$hp/mempool/docker/docker-compose.yml"

if ! grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
announce "Need to install Bitcoin first from Parmanode menu. Aborting." ; return 1 ; fi

if ! docker ps >/dev/null ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1 ; fi

# INTRO

cd $hp
git clone --depth 1 https://github.com/mempool/mempool.git
installed_config_add "mempool-start"

#set variables
cp $pn/src/mempool/docker-compose.yml $file 

mempool_backend

choose_mempool_LND
choose_mempool_tor

installed_conf_add "mempool-end"
success "Mempool" "being installed"
}

########################################################################################################################

function choose_mempool_LND {
export file="$hp/mempool/docker/docker-compose.yml"
set_terminal ; echo -e "
########################################################################################

    Turn on connection to LND (does nothing if you haven't installed LND)?
$green
          y)      y stands for \"yes\"
$red
          n)      No
   $orange       
######################################################################################## 
"
choose "x"
read choice
case $choice in
n) return ;;
esac
clear

swap_string "$file" "LIGHTNING_ENABLED:" "LIGHTNING_ENABLED: \"true\""
return 0
}

function choose_mempool_tor {
export file="$hp/mempool/docker/docker-compose.yml"

set_terminal ; echo -e "
########################################################################################

    Turn on connection to Mempool via Tor?
$green
                                 y)      Yes
$red
                                 n)      No
   $orange       
######################################################################################## 
"
choose "x"
read choice
case $choice in
n) return ;;
esac
clear
swap_string "$file" "SOCKS5PROXY_ENABLED:" "SOCKS5PROXY_ENABLED: \"true\""

}