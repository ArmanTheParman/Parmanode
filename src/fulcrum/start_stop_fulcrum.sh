function start_fulcrum {
if grep -q "fulcrum-" $ic ; then
sudo systemctl start fulcrum.service
elif grep -q "fulcrumdkr" $ic ; then
docker_running || return 1
docker start fulcrum
docker exec -d fulcrum /bin/bash -c "/home/parman/parmanode/fulcrum/Fulcrum /home/parman/.fulcrum/fulcrum.conf \
    >/home/parman/parmanode/fulcrum/fulcrum.log 2>&1" >$dn 2>&1
fi
}

function stop_fulcrum {
if grep -q "fulcrum-" $ic ; then

    sudo systemctl stop fulcrum.service 

elif grep -q "fulcrumdkr" $ic ; then
    docker_running || return 1
    please_wait

    shutdownsig="false" ; count=0
    while [[ $shutdownsig == "false" && $count -lt 5 ]] ; do
    debug3 "stopping in loop"
    docker exec -it fulcrum bash -c "kill -15 \"\$(ps -x | grep fulcrum | grep -v bash | grep -v grep | awk '{print \$1}')\""
    sleep 2
    #make sure fulcrum gracefully stopped
    if docker exec -it fulcrum bash -c "cat /home/parman/parmanode/fulcrum/fulcrum.log  | tail -n15 | grep 'exiting ...' "  ; then
    shutdownsig="true"
    break
    fi
    done
    #yesorno "Unable to stop fulcrum - Forcefully stop? Doing so can corrupt the database" && docker stop fulcrum
fi
}
