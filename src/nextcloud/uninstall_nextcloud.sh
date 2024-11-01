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
break
;;
l)
break
;;
*)
invalid
;;
esac
done

installed_config_remove "nextcloud"
parmanode_conf_remove "nextcloud"
success "NextCloud has been uninstalled"
}