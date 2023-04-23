function docker_install_check {

if command -V docker ; then

set_terminal ; echo "
########################################################################################

                  Docker appears to already be installed. Skipping.

######################################################################################## 
"
    enter_continue ; set_terminal
    docker_installed="true" && log "docker" "docker_installed=true"
    return 1
fi

docker_installed="false" && log "docker" "docker_installed=false"
return 0
}