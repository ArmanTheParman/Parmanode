#this funny function name is to distinguish between bre_docker_start, which
#starts the container, but this function start BRE inside an already
#started container.
function bre_docker_start_bre {

if ! docker ps >/dev/null 2>&1 && [[ $OS == Mac ]] ; then #is docker running?
 start_docker_mac 
fi

if ! docker ps >/dev/null 2>&1 | grep -q bre ; then #is bre container running?
    docker start bre
fi

docker exec -du parman bre /bin/bash -c "btc-rpc-explorer" #start btc-rpc-explorer
}