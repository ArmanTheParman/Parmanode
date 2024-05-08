function lnd_docker_start {

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi
docker start lnd 
docker exec -du root lnd /bin/bash -c "tor > /home/parman/parmanode/lnd/tor.log 2>&1" || return 1
sleep 2
docker exec -du root lnd /bin/bash -c "nginx > /home/parman/parmanode/lnd/nginx.log 2>&1" || return 1
debug "after nginx"
sleep 3
docker exec -d lnd /bin/bash -c "lnd /usr/local/bin/lnd > /home/parman/parmanode/lnd/lnd.log 2>&1" || return 1
debug "after lnd start"
#do later
#docker exec -d lnd tor
}

function lnd_docker_stop {

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
if [[ $1 != silent ]] ; then enter_continue ; return 1 ; esle true ; fi
fi

if ! docker ps | grep -q lnd ; then set_terminal ; echo -e "
########################################################################################$red
                        The LND container is not running. $orange
########################################################################################
"
if [[ $1 != silent ]] ; then enter_continue ; return 1 ; esle true ; fi
fi 

docker stop lnd
#docker exec -d lnd /bin/bash -c "lnd /usr/local/bin/lnd stop >> /home/parman/parmanode/lnd/lnd.log &"
}