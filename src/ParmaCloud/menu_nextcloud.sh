function menu_parmacloud {
if ! grep -q "parmacloud-end" $ic ; then return 0 ; fi
while true ; do 
unset nextcloud_running
source $pc
if docker ps | grep -q nextcloud ; then
nextcloud_running="${green}RUNNING$orange"
else
nextcloud_running="${red}NOT RUNNING$orange"
fi

if ! { sudo test -e /etc/docker/daemon.json && \
       grep -q "data-root" /etc/docker/daemon.json && \
       vld=$(sudo cat /etc/docker/daemon.json 2>/dev/null | jq -r '."data-root"') 
     } ; then 

    vld=/var/lib/docker
fi


set_terminal ; echo -en "$blue
########################################################################################$orange
                              PARMACLOUD - NextCloud $blue
########################################################################################

    NextCloud is:    $nextcloud_running

$orange
                      pass)$blue        Show setup password
$orange
                      reset)$blue       Reset a user account password
$orange
                      start)$blue       Start NextCloud Docker container
$orange
                      stop)$blue        Stop NextCloud Docker container
$orange
                      refresh)$blue     Refresh info after any manual file changes
                                   - Restarts container as well
$orange
                      data)$blue        Information about data storage and backups


    ACCESS: $green
            https://$IP:8020    $blue

    DATA DIRECTORY: $pink
    $vld/volumes/nextcloud_aio_nextcloud_data/_data/__NEXTCLOUD_username__
$blue
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 

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

reset)
nextcloud_password_reset
;;
*)
invalid
;;

esac
done
}


function nextcloud_password_reset {
set_terminal ; echo -e "$blue
########################################################################################

    Please type the username for which you'd like to reset the password, eg 'admin'

########################################################################################
$orange"
read user
docker exec -it nextcloud-aio-nextcloud bash -c "sudo -u www-data php /var/www/html/occ user:resetpassword $user" && success "Password change done."
}