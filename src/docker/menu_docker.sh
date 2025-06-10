function menu_docker {

source $pdc

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
if ! grep -q "docker-end" $ic ; then return 0 ; fi

while true ; do set_terminal 
if docker ps >$dn 2>&1 ; then
local running="\n    Docker is${green} RUNNING"
else
local running="\n    Docker is${red} NOT RUNNING"
fi
echo -e "

########################################################################################
                 $cyan              Docker Menu            $orange                   
########################################################################################
$running
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
if sudo grep -q "/var/lib/docker" /etc/fstab ; then sudo mount /var/lib/docker >$dn 2>&1 ; fi

sleep 1
sudo systemctl start docker.service docker.socket
;;
stop|STOP|Stop)
sudo systemctl stop docker.service docker.socket
if sudo grep -q "/var/lib/docker" /etc/fstab ; then sudo umount /var/lib/docker $dn 2>&1 ; fi
;;
*)
invalid
;;

esac
done
} 
