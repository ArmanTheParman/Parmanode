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
make_mempool_docker_compose
cp /tmp/docker-compose.yml $file 
rm /tmp/docker-compose.yml >/dev/null 2>&1
mempool_backend
choose_mempool_LND
choose_mempool_tor

installed_conf_add "mempool-end"
success "Mempool" "being installed"
}