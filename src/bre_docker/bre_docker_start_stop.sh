function bre_docker_start {
check_config_bre || return 1
bre_docker_start_bre
}

function bre_docker_stop {
docker stop bre
}

function bre_docker_restart {
bre_docker_stop
bre_docker_start
}