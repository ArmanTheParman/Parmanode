function uninstall_nextcloud {

docker stop $(docker ps --format "{{.Names}}" | grep nextcloud)
docker rm $(docker ps -a --format "{{.Names}}" | grep nextcloud)
if [[ $debug != 1 ]] ; then
docker rmi $(docker images | grep nextcloud | awk '{print $3}')
fi
#docker volume rm nextcloud_aio_mastercontainer 
sudo docker network rm nextcloud-aio 2>/dev/null

#sudo rm /var/lib/docker/volumes/metadata.db >/dev/null 2>&1
#docker system prune -a --volumes
installed_config_remove "nextcloud"
debug "pause"
success "NextCloud has been uninstalled"
}