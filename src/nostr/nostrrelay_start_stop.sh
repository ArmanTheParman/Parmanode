function start_nostrrelay {
podman ps >$dn 2>&1 || { announce "Please start Docker" ; return 1 ; } 
please_wait
podman start nostrrelay 
}

function stop_nostrrelay {
please_wait
podman stop nostrrelay
}