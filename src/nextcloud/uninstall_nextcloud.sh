function uninstall_nextcloud {

docker stop $(docker ps --format "{{.Names}}" | grep nextcloud)
docker rm $(docker ps -a --format "{{.Names}}" | grep nextcloud)

while true ; do
set_terminal ; echo -e "
########################################################################################

    Do you want to remove the NextCloud Docker images as well? It can save some
    data.

                            d)    delete them

                            l)    Leave them

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
d)
docker rmi $(docker images | grep nextcloud | awk '{print $3}')
;;
l)
break
;;
*)
invalid
;;
esac
done

#docker volume rm nextcloud_aio_mastercontainer 
sudo docker network rm nextcloud-aio 2>/dev/null

#sudo rm /var/lib/docker/volumes/metadata.db >/dev/null 2>&1
#docker system prune -a --volumes
installed_config_remove "nextcloud"
parmanode_conf_remove "nextcloud"
debug "pause"
success "NextCloud has been uninstalled"
}