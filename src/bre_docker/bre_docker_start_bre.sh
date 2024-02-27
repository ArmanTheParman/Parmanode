#this funny function name is to distinguish between bre_docker_start, which
#starts the container, but this function start BRE inside an already
#started container.
function bre_docker_start_bre {

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi

#start container
if ! docker ps 2>&1 | grep -q bre ; then #is bre container running?
    docker start bre
fi
#start program
docker exec -du parman bre /bin/bash -c "btc-rpc-explorer" #start btc-rpc-explorer
}