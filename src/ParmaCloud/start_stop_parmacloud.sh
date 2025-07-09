function start_parmacloud {
docker start nextcloud-aio-mastercontainer 
}

function stop_parmacloud {
docker stop $(docker ps --format "{{.Names}}" | grep nextcloud)
}
