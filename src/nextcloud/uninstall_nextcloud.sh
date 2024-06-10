function uninstall_nextcloud {

docker stop nextcloud-aio-mastercontainer
docker rm nextcloud-aio-mastercontainer
docker volume rm nextcloud_aio_mastercontainer
sudo docker network rm nextcloud-aio
sudo rm /var/lib/docker/volumes/metadata.db
#docker system prune -a --volumes
installed_config_remove "nextcloud"
debug "pause"
success "NextCloud has been uninstalled"
}