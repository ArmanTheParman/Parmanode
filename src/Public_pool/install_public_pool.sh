function install_public_pool {
set_terminal 

if [[ $OS == Mac ]] ; then
    if ! which docker >/dev/null 2>&1 ; then announce "Please install Docker first. Aborting" ; return 1 ; fi
    if ! which python3 >/dev/null ; then
        if ! which brew >/dev/null ; then install_homebrew 
        fi
    brew install python3
    fi
elif [[ $OS == Linux ]] ; then
    if ! which docker >/dev/null 2>&1 ; then announce "Please install Docker first. Aborting" ; return 1 ; fi
    if ! which python3 ; then
        sudo apt-get update -y && sudo apt-get install python3 -y
    fi
fi

if ! which nginx >/dev/null 2>&1 ; then install_nginx ; fi

#check Docker running, esp Mac
if ! docker ps >/dev/null 2>&1 ; then echo -e "
########################################################################################

    Docker doesn't seem to be running. Please start it and, once it's running, hit $green 
    <enter>$orange to continue.

########################################################################################
"
choose "emq"
read choice ; case $choice in Q|q) exit 0 ;; m|M) back2main ;; esac
set_terminal
if ! docker ps >/dev/null 2>&1 ; then echo -e "
########################################################################################

    Docker is still$red not running$orange. 

    It can take a while to be in a 'ready state' even though you started it. Try
    again later. 
    
    Aborting. 

########################################################################################
"
enter_continue
return 1
fi
fi

if docker ps | grep -q "public_pool" ; then
docker stop public_pool public_pool_ui
fi

if docker ps -a | grep -q "public_pool" ; then
docker rm public_pool public_pool_ui
fi

cd $hp

check_port_conflicts_public_pool

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

#Set Dockerfile
local file=$hp/public_pool/Dockerfile

#delete any Dockerfile in repo and replace with Parmanode's fork.
if [[ -e $file ]] ; then rm $file ; fi
cp $pp/parmanode/src/public_pool/Dockerfile $file
unset file

# build image
docker build -t public_pool . ; debug "build done"
echo -e "${pink}Pausing, you can check if the first build went ok.$orange"
enter_continue

#start container
if [[ $OS == Linux ]] ; then
    docker run -d --name public_pool --network=host -v $hp/public_pool/.env:/.env public_pool ; debug "run pool done"
elif [[ $OS == Mac ]] ; then
    docker run -d --name public_pool -p 3333:3333 -p 3334:3334 -v $hp/public_pool/.env:/.env public_pool ; debug "run pool done"
fi


########################################################################################
# Next public_pool_ui
########################################################################################
cd $hp/public_pool_ui
docker build -t public_pool_ui . ; debug "build done"
echo -e "${pink}Pausing, you can check if the second build went ok.$orange"
enter_continue
docker run -d --name public_pool_ui -p 5050:80 public_pool_ui ; debug "run done"

make_ssl_certificates "public_pool_ui" ; debug "certs done"

########################################################################################
# configure and restart nginx last
########################################################################################
nginx_public_pool_ui

#check for success
if docker ps | grep "public_pool" | grep -q "public_pool_ui" ; then
success "Public Pool" "being installed"
installed_conf_add "public_pool-end"
else
announce "Something went wrong"
fi
}


