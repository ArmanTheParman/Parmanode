function bre_docker_restart {

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi
bre_docker_stop || return 1
bre_docker_start || return 1

}