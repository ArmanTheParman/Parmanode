function menu_nextcloud {

while true ; do 
if docker ps | grep -q joinmarket ; then
joinmarket_running="${green}RUNNING$orange"
else
joinmarket_running="${red}NOT RUNNING$orange"
fi

set_terminal ; echo -en "
########################################################################################$cyan
                                J O I N M A R K E T $orange
########################################################################################

    JoinMarket is:    $nextcloud_running

$cyan
                      start)$orange       Start JoinMarket Docker container
$cyan
                      stop)$orange        Stop JoinMarket Docker container

                      cr)$orange          Create/Restore JoinMarket Wallet

$orange   
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 

start)
docker start joinmarket
;;
stop)
docker stop joinmarket
;;
cr)
    docker exec joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py generate' 
    ;;
*)
invalid
;;

esac
done
}