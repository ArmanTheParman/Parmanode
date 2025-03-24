function start_thunderhub {
podman ps >$dn 2>&1 || { announce "Please start Docker" ; return 1 ; } 
please_wait
podman start thunderhub
}

function stop_thunderhub {
please_wait
podman stop thunderhub
}