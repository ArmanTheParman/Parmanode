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

yesorno_blue "Do you want to remove all your NextCloud data?
$orange
    THIS CANNOT BE UNDONE.
   $blue 
    Note ths will remove volume data only if it hasn't been moved to somewhere other than$orange

    /var/lib/docker/volumes/... $blue" && announce_blue "Type$red DELETENEXTCLOUDDATA$blue to confirm, othewise skipping."

if [[ $enter_cont == DELETENEXTCLOUDDATA ]] ; then 
    docker volume ls | cut -d ' ' -f6  | grep nextcloud | while read line ; do docker volume rm $line ; done
else
    announce_blue "Docker volumes can manually be deleted with
    $orange
    docker volumes ls $orange -- to see the volumes $orange
    docker volum rm name_of_volume $orange -- to permanently delete$blue"
fi

rm -rf $pp/parmacloud

installed_conf_remove "parmacloud"
parmanode_conf_remove "parmacloud"
success_blue "ParmaCloud (NextCloud) has been uninstalled"
}