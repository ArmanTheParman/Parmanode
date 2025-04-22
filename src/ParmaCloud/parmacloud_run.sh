function parmacloud_run {

if  [[ $preconfigure_parmadrive == "true" ]] ; then
echo -e "$blue"
sudo docker run \
-d \
--init \
--sig-proxy=false \
--name nextcloud-aio-mastercontainer \
--restart unless-stopped \
--publish 8020:8080 \
--env APACHE_PORT=11000 \
--env APACHE_IP_BINDING=0.0.0.0 \
--env APACHE_ADDITIONAL_NETWORK="" \
--env SKIP_DOMAIN_VALIDATION=true \
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
nextcloud/all-in-one:latest || { enter_continue "Something went wrong." ; return 1 ; }
return 0
fi


if yesorno_blue "Regular or Reverse Proxy?" "reg" "Regular" "rev" "Reverse" ; then
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
else

if yesorno_blue "Normal Reverse Proxy with Nginx or a are Tunnel?" "r" "normal reverse proxy" "c" "cloudflare" ; then
sdv="false"
else
sdv="true"
fi

clear
echo -e "$blue"
sudo docker run \
-d \
--init \
--sig-proxy=false \
--name nextcloud-aio-mastercontainer \
--restart unless-stopped \
--publish 8020:8080 \
--env APACHE_PORT=11000 \
--env APACHE_IP_BINDING=0.0.0.0 \
--env APACHE_ADDITIONAL_NETWORK="" \
--env SKIP_DOMAIN_VALIDATION=$sdv \
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
nextcloud/all-in-one:latest || { enter_continue "Something went wrong." ; return 1 ; }
fi
}
