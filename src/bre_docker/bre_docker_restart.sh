function bre_docker_restart {

bre_docker_stop || return 1
bre_docker_start || return 1

}