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
docker stop fulcrum
fi
}
