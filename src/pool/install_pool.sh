function install_public-pool {

if ! which docker >/dev/null 2>&1 ; then install_docker_linux ; fi

cd $hp

git clone --depth 1 https://github.com/benjamin-wilson/public-pool.git public-pool
git clone --depth 1 https://github.com/benjamin-wilson/public-pool-ui.git public-pool-ui
installed_conf_add "public-pool-start"

########################################################################################
# Start with public-pool
########################################################################################
cd $hp/public-pool
make_public-pool_env ; debug "made env"
# Add ZMQ connection to bitcoin.conf
# Parmanode uses port 3000 for RTL, so can't use that for pool.
echo "zmqpubrawblock=tcp://*:5000" | tee -a $bc

#start container
docker build -t public-pool . ; debug "build done"
if [[ $OS == Linux ]] ; then
docker run -d --name public-pool --network=host -v $hp/public-pool/.env:/.env public-pool ; debug "run pool done"
elif [[ $OS == Mac ]] ; then
docker run -d --name public-pool -p 3333:3333 3334:3334 -v $hp/public-pool/.env:/.env public-pool ; debug "run pool done"
fi


########################################################################################
# Next public-pool-ui
########################################################################################
cd $hp/public-pool-ui
docker build -t public-pool-ui . ; debug "build done"
docker run -d --name public-pool-ui -p 5050:80 public-pool-ui

installed_conf_add "public-pool-end"
success "Public Pool" "being installed"
}
