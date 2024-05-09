function start_thunderhub {
docker ps >/dev/null 2>&1 || { announce "Please start Docker" ; return 1 ; } 
please_wait
docker start thunderhub
}

function stop_thunderhub {
please_wait
docker stop thunderhub
}