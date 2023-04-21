function docker_install_check {

if command -V docker ; then

set_terminal ; echo "
########################################################################################

                  Docker appears to already be installed. Skipping.

######################################################################################## 
"
enter_continue ; return 1
fi

log "docker" "docker not installed yet. Proceed with installation."
return 0
}