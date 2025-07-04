function install_public_pool {
if grep -q "pihole" $ic >$dn ; then
announce "Can't install Public Pool and PiHole on the same system. Aborting."
return 1
fi

if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi #for now
set_terminal 
sned_sats
if [[ $OS == Mac ]] ; then
    if ! which docker >$dn 2>&1 ; then announce "Please install Docker first. Aborting" ; return 1 ; fi
    if ! which python3 >$dn ; then
        if ! which brew >$dn ; then install_homebrew 
        fi
    brew install python3
    fi
elif [[ $OS == Linux ]] ; then
    if ! which docker >$dn 2>&1 ; then announce "Please install Docker first. Aborting" ; return 1 ; fi
    if ! which python3 >$dn ; then
        sudo apt-get update -y && export APT_UPDATE="true" && sudo apt-get install python3 -y
    fi
fi

if ! sudo which nginx >$dn 2>&1 ; then sudo gsed -i "/nginx-/d" $ic  ; install_nginx ; debug "nginx1?" ; fi
#nginx_stream public_pool install || { debug "nginx_stream failed" ; return 1 ; }

#check for port 80 clash
if sudo netstat -tulnp | grep :80 | grep -q nginx ; then
sudo rm -rf /etc/nginx/sites-enabled/default >$dn 2>&1
sudo systemctl restart nginx >$dn 2>&1
fi

if sudo netstat -tulnp | grep :80 | grep -q nginx ; then
nginx_clash
return 1
fi

#check Docker running, esp Mac
if ! docker ps >$dn 2>&1 ; then echo -e "
########################################################################################

    Docker doesn't seem to be running. Please start it and, once it's running, hit $green 
    <enter>$orange to continue.

########################################################################################
"
choose "emq" ; read choice  
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in Q|q) exit 0 ;; m|M) back2main ;; esac
set_terminal
if ! docker ps >$dn 2>&1 ; then echo -e "
########################################################################################

    Docker is still$red not running$orange. 

    It can take a while to be in a 'ready state' even though you started it. Try
    again later. 
    
    Aborting. 

########################################################################################
"
enter_continue ; jump $enter_cont
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
if [[ -e $bc ]] ; then sudo gsed -i "/:28332/d" $bc 
echo "zmqpubrawblock=tcp://*:28332" | tee -a $bc >$dn ; debug "$bc edited"
fi

#Set Dockerfile
local file=$hp/public_pool/Dockerfile

#delete any Dockerfile in repo and replace with Parmanode's fork.
if [[ -e $file ]] ; then rm $file ; fi
cp $pp/parmanode/src/public_pool/Dockerfile $file 2>$dn
debug "cp"
unset file

# build image
docker build -t public_pool $NOCACHE . ; debug "build done"
echo -e "${pink}Pausing, you can check if the first build went ok.$orange"
enter_continue

#start container
if [[ $OS == Linux ]] ; then
    docker run -d --name public_pool --restart unless-stopped --network=host -v $hp/public_pool/.env:/.env public_pool ; debug "run pool done"
elif [[ $OS == Mac ]] ; then
    docker run -d --name public_pool --restart unless-stopped -p 3333:3333 -p 3334:3334 -v $hp/public_pool/.env:/.env public_pool ; debug "run pool done"
fi


########################################################################################
# Next public_pool_ui
########################################################################################
cd $hp/public_pool_ui
sudo rm $hp/public_pool_ui/src/environments/*
sudo cp $pp/parmanode/src/public_pool/environment* $hp/public_pool_ui/src/environments/
docker build -t public_pool_ui . ; debug "build done"
echo -e "${pink}Pausing, you can check if the second build went ok.$orange"
enter_continue
#docker run -d --name public_pool_ui -p 5050:80 public_pool_ui ; debug "run done"
docker run -d --restart unless-stopped --name public_pool_ui --network=host public_pool_ui ; debug "run done"
#certs before socat
make_ssl_certificates "public_pool_ui" ; debug "certs done"
# make_socat_script "public_pool_ui"
# $dp/start_socat_public_pool_ui.sh  # starts socat and captures process ID

echo "pausing to determine if run command worked."
enter_continue

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


