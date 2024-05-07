function lnd_docker_start {

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi
docker start lnd && \
docker exec -d lnd /bin/bash -c "tor & lnd /usr/local/bin/lnd >> /home/parman/parmanode/lnd/lnd.log &"
}

function lnd_docker_stop {

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi

if ! docker ps | grep -q lnd ; then set_terminal ; echo -e "
########################################################################################$red
                        The LND container is not running. $orange
########################################################################################
"
enter_continue
return 1
fi 
docker stop lnd
#docker exec -d lnd /bin/bash -c "lnd /usr/local/bin/lnd stop >> /home/parman/parmanode/lnd/lnd.log &"
}