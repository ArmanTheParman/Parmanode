function install_mempool {
export install=mempool

if grep -q mempool-end $ic ; then announce "Mempool already installed." ; jump $enter_cont ; return 0 ; fi
if grep -q mempool-start $ic ; then announce "Mempool partially installed." ; jump $enter_cont ; uninstall_mempool ; return 0 ; fi


if ! which docker >$dn 2>&1 ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1
else
    if ! docker ps >$dn ; then announce "Pease make sure you START the docker service first. Aborting for now." ; return 1 ; fi
fi

if ! grep -q bitcoin-end $HOME/.parmanode/installed.conf ; then
announce "Mempool won't work without Bitcoin installed first. You can
    go ahead, but you'll have to tweak the config file yourself to
    make it point to a functional backend."
fi

sned_sats
source $bc 2>$dn

if [[ $mbackend == 1 && $txindex != 1 ]] ; then clear ; echo -e "
    Sorry,$cyan txindex=1$orange needs to be in the bitcoin.conf file for Mempool to work.
    Type $red 'yolo'$orange and$cyan <enter>$orange to ignore warning, otherwise aborting."
    read choice
    if [[ $choice != yolo ]] ; then debug "not yolo" ; return 1 ; fi
fi

if [[ $mbackend == 1 && $server != 1 ]] ; then 
    check_server_1 || return 1
fi

# INTRO 
{
choose_mempool_version && cd $hp && git clone $memversion https://github.com/mempool/mempool.git
} || { enter_continue ; return 1 ; }

install_conf_add "mempool-start"
#make sure mounted dir permission is correct (Pi is not 1000:1000, so these dir's will not be readable by container.)
sudo chown -R 1000:1000 $hp/mempool/docker/data $hp/mempool/docker/mysql >$dn
installed_config_add "mempool-start"
#set variables
make_mempool_docker_compose
cp $tmp/docker-compose.yml $hp/mempool/docker/docker-compose.yml
rm $tmp/docker-compose.yml >$dn 2>&1

enable_mempool_tor

if grep -q "electrs-end" $ic || grep -q "electrsdkr-end" $ic ; then
choose_electrs_for_mempool 
else
choose_bitcoin_for_mempool
fi

cd $hp/mempool/docker 
docker compose up -d || debug "compose up didn't work"

#Final check to make sure the docker gatway IP is included in bitcoin.conf
if docker ps >$dn 2>&1 ; then

string="$(docker network inspect docker_PM_network | grep Gateway | awk '{print $2}' | tr -d ' ' | tr -d \" | cut -d \. -f 1)"
debug "string is $string"

if [[ $string != 172 ]] ; then #would be unusualy for it not to be 172

        if ! docker network inspect docker_PM_netowrk >$dn 2>&1 ; then 
        announce "some problem with starting the container. Aborting. Please let Parman know to fix."
        return 1
        fi

    stringIP="$(docker network inspect docker_PM_network | grep Gateway | awk '{print $2}' | tr -d ' ' | tr -d \" )"

    if [[ -n $stringIP ]] ; then
      cp $bc $dp/backup_bitcoin.conf 
      echo rpcallowip="$stringIP"/16 | sudo tee -a $bc >$dn 2>&1
    fi
    
    if [[ $OS == Linux ]] ; then sudo systemctl restart bitcoind.service 
    elif [[ $OS == Mac ]] ; then stop_bitcoin ; start_bitcoin
    fi

    announce "An unusual IP address for the Docker Gateway was detected 
    (doesn't start with 172) and was addeed to bitcoin.conf as
    rpcallowip=DockerIP/16. There is a chance this could cause errors.
    A backup of bitcoin.conf has been saved to 
    $dp/backup_bitcoin.conf just in case you need to go back to it.
    Call Parman for help if you have issues (Telegram or Twitter).
    "
    restart_mempool

fi ; fi #end if docker ps

if docker ps | grep -q mempool ; then
    installed_conf_add "mempool-end"
    filter_notice
    success "Mempool" "being installed"
else
announce "There was some problem with the installation. 
    You might need to uninstall and try again.
    Please let Parman know to fix."
return 1
fi
}

function choose_mempool_version {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Which version of Mempool would you like?
$cyan
            1)$orange     v2.5
$cyan
            2)$orange     v3.0
$cyan
            3)$orange     v3.2.1
$cyan
            4)$orange     Latest (pre-release, can be buggy, but cutting edge)

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
export memversion="--branch v2.5 --single-branch"
break ;;
2)
export memversion="--branch v3.0 --single-branch"
break ;;
3)
export memversion="--branch v3.2.1 --single-branch"
break ;;
4)
export memversion="--depth 1"
break ;;
*)
invalid ;;
esac
done
return 0
}