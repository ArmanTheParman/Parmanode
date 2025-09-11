function install_alby {

mkdir $hp/alby
cat<<EOF >$hp/alby/docker-compose.yml
services:
  albyhub:
    container_name: albyhub
    image: ghcr.io/getalby/hub:v1.18.5
    volumes:
      - ./albyhub-data:/data
      - /home/parman/.lnd:/lnd:ro
    ports:
      - "8383:8080"
    environment:
      - WORK_DIR=/data/albyhub
      - LOG_EVENTS=true
      - LND_DIR=/lnd
    restart: unless-stopped
    networks:
      - default
EOF
alby_tor
installed_conf_add "alby-end"
success "Alby installed"
}

function menu_alby {
while true ; do
get_onion_address_variable "alby"
set_terminal 38 110 ; echo -e "
##############################################################################################################
                                              Alby Menu
##############################################################################################################

$runningalbymenu
$orange
    Connections:

            https://localhost:8383     \033[58GFrom this computer only
            https://127.0.0.1:8383     \033[58GFrom this computer only
            https://$IP:8383           \033[58GFrom any computer on your network 
    Tor:$blue
            http://$ONION_ADDR_ALBY:7011    $orange
            From any computer in the world 

$green
                  start)$orange         Start Alby docker container
$red
                  stop)$orange          Stop Alby docker container


    See LND menu for LND macaroons

##############################################################################################################
"
choose xpmq ; read choice ; set_terminal
jump $choice ; jump_pmq $choice
case $choice in
start)
start_alby
;;
stop)
stop_alby
;;
"") 
: ;;
*)
invalid ;;
esac
done

}


function alby_tor {
enable_tor_general || return 1

if ! sudo grep "HiddenServiceDir $varlibtor/alby-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/alby-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 7011 127.0.0.1:8383" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 7011 127.0.0.1:8383" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor
}

function alby_tor_remove {

please_wait

sudo gsed -i "/alby-service/d" $macprefix/etc/tor/torrc
sudo gsed -i "/127.0.0.1:50005/d" $macprefix/etc/tor/torrc

if [[ $1 != "uninstall" ]] ; then sudo systemctl restart tor ; fi

set_terminal
return 0
}

function uninstall_alby {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Alby
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done

stop_alby || return 1
sleep 2
rm -rf $hp/alby
alby_tor_remove "uninstall"
install_conf_remove "alby-"
success "Alby uninstalled"
}