function menu_nextcloud {

while true ; do 
unset nextcloud_running
source $pc
if docker ps | grep -q nextcloud ; then
nextcloud_running="${green}RUNNING$orange"
else
nextcloud_running="${red}NOT RUNNING$orange"
fi

set_terminal ; echo -en "
########################################################################################$cyan
                                N E X T C L O U D $orange
########################################################################################

    Nextcloud is:    $nextcloud_running


                      pass)        Show setup password

                      start)       Start NextCloud Docker container

                      stop)        Stop NextCloud Docker container

                      refresh)     Refresh info after any manual file changes
                                   - Restarts container as well
                      
                      data)        Information about data storage and backups

    ACCESS: $green
            https://$IP:8020    $orange

    DATA: $bright_blue
           /var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/
$orange   
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 

pass)
set_terminal
sudo docker exec nextcloud-aio-mastercontainer grep password /mnt/docker-aio-config/data/configuration.json || \
{ announce "No password found. It is created only once you access the server setup page
    the very first time around." ; continue ; }

enter_continue
;;

start)
docker start nextcloud-aio-mastercontainer
;;
stop)
docker stop $(docker ps --format "{{.Names}}" | grep nextcloud)
;;

refresh)
please_wait
docker stop $(docker ps --format "{{.Names}}" | grep nextcloud)
docker start nextcloud-aio-nextcloud
docker exec -itu www-data nextcloud-aio-nextcloud bash -c "cd /var/www/html ; php occ files:scan --all"
enter_continue
;;

data)
nextcloud_storage_info
;;

*)
invalid
;;

esac
done
}