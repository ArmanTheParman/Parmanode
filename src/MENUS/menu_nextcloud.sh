function menu_nextcloud {

while true ; do 
unset nextcloud_running
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


    ACCESS: $green
            https://$IP:8020    $orange


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
docker start nextcloud
;;
stop)
docker stop nextcloud
;;


*)
invalid
;;

esac
done
}