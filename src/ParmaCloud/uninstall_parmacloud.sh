function uninstall_parmacloud {
while true ; do
set_terminal ; echo -e "$blue
########################################################################################
$orange
                        Uninstall ParmaCloud (NextCloud)?
$blue
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done

docker stop $(docker ps --format "{{.Names}}" | grep nextcloud)
docker rm $(docker ps -a --format "{{.Names}}" | grep nextcloud)

while true ; do
set_terminal ; echo -e "$blue
########################################################################################

    Do you want to remove the NextCloud Docker images as well? It can save some
    data.
$red
                            d)    delete them
$green
                            l)    Leave them
$blue
########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
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

installed_config_remove "parmacloud"
parmanode_conf_remove "parmacloud"
success "ParmaCloud (NextCloud) has been uninstalled"
}