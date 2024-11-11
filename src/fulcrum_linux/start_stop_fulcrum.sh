function start_fulcrum {
if grep -q "fulcrum-" $ic ; then
sudo systemctl start fulcrum.service
elif grep -q "fulcrumdkr" $ic ; then
docker_running || return 1
docker start fulcrum
docker exec -d fulcrum /bin/bash -c "/home/parman/parmanode/fulcrum/Fulcrum /home/parman/.fulcrum/fulcrum.conf \
    >>/home/parman/parmanode/fulcrum/fulcrum.log 2>&1" >/dev/null 2>&1
fi
}

function stop_fulcrum {
if grep -q "fulcrum-" $ic ; then
sudo systemctl stop fulcrum.service
elif grep -q "fulcrumdkr" $ic ; then
docker_running || return 1
please_wait
docker exec -it fulcrum bash -c "kill -15 \"\$(ps -x | grep fulcrum | grep -v bash | grep -v grep | awk '{print \$1}')\""
#make sure fulcrum gracefully stopped
docker exec -it fulcrum bash -c "ps -x | grep fulcrum | grep -v grep" && docker stop fulcrum && return 0
sleep 2
docker exec -it fulcrum bash -c "ps -x | grep fulcrum | grep -v grep" && docker stop fulcrum && return 0
sleep 2
docker exec -it fulcrum bash -c "ps -x | grep fulcrum | grep -v grep" && docker stop fulcrum && return 0
sleep 2

yesorno "Unable to stop fulcrum - Forcefully stop? Doing so can corrupt the database" && docker stop fulcrum
fi
}
