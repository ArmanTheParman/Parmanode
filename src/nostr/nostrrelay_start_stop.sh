function start_nostrrelay {
docker ps >/dev/null 2>&1 || { announce "Please start Docker" ; return 1 ; } 
please_wait
docker start nostrrelay 
}

function stop_nostrrelay {
please_wait
docker stop nostrrelay
}