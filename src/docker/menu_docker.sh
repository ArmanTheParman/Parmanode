function menu_docker {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if ! grep -q "docker-end" $ic ; then return 0 ; fi
while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan              Docker Menu            $orange                   
########################################################################################

$green
         start)$orange                 Start Docker Service and Socket
$red
          stop)$orange                 Stop Docker Service and Socket
$cyan
            ps)$orange                 List running docker containers
$cyan            
            nn)$orange                 List docker networks
$red
         purge)$orange                 Purge data for stopped and unused containers


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; m|M) back2main ;;

start|Start|START|S|s)
clear
sudo systemctl start docker.service docker.socket
enter_continue "Done"
;;
stop|STOP|Stop)
sudo systemctl stop docker.service docker.socket
enter_continue "Done"
;;
*)
invalid
;;

esac
done
} 
