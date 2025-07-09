function start_parmacloud {
docker start nextcloud-aio-mastercontainer 
}

function stop_parmacloud {
please_wait
docker stop $(docker ps --format "{{.Names}}" | grep nextcloud)
}
