function parmacloud_run {

if ! yesorno_blue "Regular or Reverse Proxy?" "reg" "Regular" "rev" "Reverse" ; then
clear
echo -e "$blue"
sudo docker run \
-d \
--init \
--sig-proxy=false \
--name nextcloud-aio-mastercontainer \
--restart unless-stopped \
--publish 8020:8080 \
--publish 80:80 \
--publish 8443:8443 \
--env APACHE_PORT=11000 \
--env APACHE_IP_BINDING=0.0.0.0 \
--env APACHE_ADDITIONAL_NETWORK="" \
--env SKIP_DOMAIN_VALIDATION=false \
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
nextcloud/all-in-one:latest || { enter_continue "Something went wrong." ; return 1 ; }
else
clear
echo -e "$blue"
sudo docker run \
-d \
--init \
--sig-proxy=false \
--name nextcloud-aio-mastercontainer \
--restart unless-stopped \
--publish 8080:8080 \
--publish 80:80 \
--publish 8020:8080 \
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
nextcloud/all-in-one:latest || { enter_continue "Something went wrong." ; return 1 ; }
fi

}
