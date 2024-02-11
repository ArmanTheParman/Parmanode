function install_public_pool {

if ! which docker >/dev/null 2>&1 ; then install_docker_linux ; fi
if ! which nginx >/dev/null 2>&1 ; then install_nginx ; fi
cd $hp

git clone --depth 1 https://github.com/benjamin-wilson/public-pool.git public_pool
git clone --depth 1 https://github.com/benjamin-wilson/public-pool-ui.git public_pool_ui
installed_conf_add "public_pool-start"

########################################################################################
# Start with public_pool
########################################################################################
cd $hp/public_pool
make_public_pool_env ; debug "made env"
# Add ZMQ connection to bitcoin.conf
# Parmanode uses port 3000 for RTL, so can't use that for pool.
echo "zmqpubrawblock=tcp://*:5000" | tee -a $bc >/dev/null ; debug "$bc edited"

#Fix dependencies
if uname -m | grep -q arm || [[ $computer_type == Pi ]] ; then
    local file=$hp/public_pool/Dockerfile
    swap_string "$file" "python3" "python3 ca-certificates cmake curl " 
    #need function to check for an install python here.
    python3 $pp/parmanode/src/public_pool/add_backslash_pool_Dockerfile.py ; debug "fix arm done" #ARM build failes unless extra dependencies installed
    unset file
fi

#start container
if [[ $OS == Linux ]] ; then
    docker build -t public_pool . ; debug "build done"
    docker run -d --name public_pool --network=host -v $hp/public_pool/.env:/.env public_pool ; debug "run pool done"

elif [[ $OS == Mac ]] ; then

    docker run -d --name public_pool -p 3333:3333 -p 3334:3334 -v $hp/public_pool/.env:/.env public_pool ; debug "run pool done"

fi


########################################################################################
# Next public_pool_ui
########################################################################################
cd $hp/public_pool_ui
docker build -t public_pool_ui . ; debug "build done"
docker run -d --name public_pool_ui -p 5050:80 public_pool_ui ; debug "run done"

make_ssl_certificates "public_pool_ui" ; debug "certs done"

if docker ps | grep "public_pool" | grep -q "public_pool_ui" ; then
success "Public Pool" "being installed"
installed_conf_add "public_pool-end"
else
announce "Something went wrong"
fi
}


