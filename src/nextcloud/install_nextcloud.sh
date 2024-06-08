function install_nextcloud {

# No macs
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

# Need Docker
if ! which docker >/dev/null 2>&1 ; then announce "Please install Docker first from Parmanode Add/Other menu. Aborting." ; return 1 ; fi

# Need port 80 free
if sudo netstat -tulnp | grep :80 ; then
announce "It seems that port 80 is already in use. Type$cyan yolo$orange to ignore this, otherwise aborting."
if [[ $enter_cont == yolo ]] ; then
true
else
return 1
fi
fi

# Need 8443 free
if sudo netstat -tulnp | grep :8443 ; then
announce "It seems that port 8443 is already in use. Type$cyan yolo$orange to ignore this, otherwise aborting."
if [[ $enter_cont == yolo ]] ; then
true
else
return 1
fi
fi

# Need 8020 free
if sudo netstat -tulnp | grep :8020 ; then
announce "It seems that port 8020 is already in use. Type$cyan yolo$orange to ignore this, otherwise aborting."
if [[ $enter_cont == yolo ]] ; then
true
else
return 1
fi
fi

# --name nextcloud-aio-mastercontainer This is the name of the container. 
# This line is not allowed to be changed, since mastercontainer updates would fail.
# --restart always This is the "restart policy". 
# Means that the container should always get started with the Docker daemon. 

sudo docker run \
-d \
--init \
--sig-proxy=false \
--name nextcloud-aio-mastercontainer \
--restart always \
--publish 80:80 \
--publish 8020:8080 \
--publish 8443:8443 \
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
nextcloud/all-in-one:latest

installed_config_add "nextcloud-end"
success "NextCloud has finished being installed"

}