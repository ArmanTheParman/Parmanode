function menu_docker {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
if ! grep -q "docker-end" $ic ; then return 0 ; fi

if [[ -f $dp/parmadrive.conf ]] ; then
    source $pdc
    if [[ $DOCKERMOUNT == "external" ]] ; then
        mountwarning="$yellow\n    Note that the external ParmaDrive must be mounted for Docker to run.\n$orange"
    else
        unset mountwarning
    fi
else
    unset mountwarning
fi


while true ; do set_terminal 
if docker ps >$dn 2>&1 ; then
local running="    Docker is${green} RUNNING"
else
local running="    Docker is${red} NOT RUNNING"
fi
echo -e "

########################################################################################
                 $cyan              Docker Menu            $orange                   
########################################################################################
$mountwarning
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
ps)
clear
docker ps
enter_continue
;;
nn)
clear
docker network ls
enter_continue
;;
*)
invalid
;;

esac
done
} 
