function bre_docker_start {
docker start bre
bre_docker_start_bre
}

function bre_docker_stop {
docker stop bre
}

function bre_docker_restart {
bre_docker_stop
bre_docker_start
}