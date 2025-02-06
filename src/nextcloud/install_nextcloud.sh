function install_nextcloud {
return 1
# No macs
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

sned_sats

# Need Docker
if ! which docker >$dn 2>&1 ; then announce "Please install Docker first from Parmanode Add/Other menu. Aborting." ; return 1 ; fi

# Need port 80 free
if sudo netstat -tulnp | grep -E ':80\s' ; then
announce "It seems that port 80 is already in use. Type$cyan yolo$orange to ignore, otherwise aborting."
if [[ $enter_cont == yolo ]] ; then
true
else
return 1
fi
fi

# Need port 443 free
if sudo netstat -tulnp | grep -E ':443\s' ; then
announce "It seems that port 443 is already in use. Type$cyan yolo$orange to ignore, otherwise aborting."
if [[ $enter_cont == yolo ]] ; then
true
else
return 1
fi
fi

# Need 8443 free
if sudo netstat -tulnp | grep -E ':8443\s' ; then
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

nextcloud_storage_info

# --name nextcloud-aio-mastercontainer This is the name of the container. 
# This line is not allowed to be changed, since mastercontainer updates would fail.
# --restart always This is the "restart policy". 
# Means that the container should always get started with the Docker daemon. 
sudo docker network rm nextcloud-aoi >$dn 2>$dn

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

#a weird fix needed after nextcloud devs broke something
sudo docker network connect bridge nextcloud-aio-mastercontainer >$dn 2>&1

installed_config_add "nextcloud-end"
success "NextCloud has finished being installed"
}
