#this funny function name is to distinguish between bre_docker_start, which
#starts the container, but this function start BRE inside an already
#started container.
function bre_docker_start_bre {


if docker ps >/dev/null 2>&1 ; then

    if docker ps | grep -q bre ; then
        docker exec -d -u parman bre /bin/bash -c "btc-rpc-explorer" 
    fi

else
announce "Docker isn't running. Aborting." 
return 1
fi 
}