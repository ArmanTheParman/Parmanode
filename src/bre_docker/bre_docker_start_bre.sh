function bre_docker_start_bre {

if docker ps >/dev/null 2>&1 ; then

    if docker ps | grep -q bre ; then
        docker exec -it bre /bin/bash -c "cd /home/parman/parmanode/btc-rpc-explorer && \
                                         /usr/bin/btc-rpc-explorer" && return 0
        announce "Failed to start BRE inside container. Aborting." 
        return 1
    fi

else
announce "Docker isn't running. Aborting." 
return 1
fi 
}