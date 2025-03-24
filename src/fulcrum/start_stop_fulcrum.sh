function start_fulcrum {
if grep -q "fulcrum-" $ic ; then
    sudo systemctl start fulcrum.service
elif grep -q "fulcrumdkr" $ic ; then
    podman_running || return 1
    podman start fulcrum
    podman exec -d fulcrum /bin/bash -c "/home/parman/parmanode/fulcrum/Fulcrum /home/parman/.fulcrum/fulcrum.conf \
        >/home/parman/.fulcrum/fulcrum.log 2>&1" >$dn 2>&1
fi
}

function stop_fulcrum {
if grep -q "fulcrum-" $ic ; then
    sudo systemctl stop fulcrum.service
    sleep 1

elif grep -q "fulcrumdkr" $ic ; then
    podman_running || return 1
    please_wait
    tmux "podman exec -it fulcrum bash -c 'pkill Fulcrum'"
    sleep 1
fi
}
