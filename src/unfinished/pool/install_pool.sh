function install_pool {

if ! which docker >/dev/null 2>&1 ; then install_docker_linux ; fi

cd $hp

git clone --depth 1 https://github.com/benjamin-wilson/public-pool.git pool
git clone --depth 1 https://github.com/benjamin-wilson/public-pool-ui.git pool-ui
installed_conf_add "pool-start"

########################################################################################
# Start with public-pool
########################################################################################
cd $hp/pool
make_pool_env
# Add ZMQ connection to bitcoin.conf
# Parmanode uses port 3000 for RTL, so can't use that for pool.
echo "zmqpubrawblock=tcp://*:5000" | tee -a $bc

#start container
docker build -t public-pool . ; debug "build done"
docker run -d --name public-pool --network=host -v .env:/.env public-pool ; debug "run pool done"


########################################################################################
# Next public-pool-ui
########################################################################################
cd $hp/pool-ui
docker build -t public-pool-ui . ; debug "build done"
docker run -d --name public-pool-ui -p 5050:80 public-pool-ui

installed_conf_add "pool-end"
success "Public Pool" "being installed"
}

#if [[ $OS == Mac ]] ; then need host.docker.internal for BITCOIN_RPC_URL