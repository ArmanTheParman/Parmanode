function install_fulcrum_mac {
set_terminal
grep -q "bitcoin-end" $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
grep -q "docker-end" $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }



choose_and_prepare_drive "Fulcrum" || return 1 #gets drive_fulcrum variable

format_ext_drive "Fulcrum" || return 1

fulcrum_make_directories || return 1 ; log "fulcrum" "make directories function exited."

if ! which docker >/dev/null 2>&1 ; then install_docker_mac || return 1 ; fi

#start docker if it is not running 
if ! docker ps >/dev/null 2>&1 ; then start_docker_mac ; fi

warning_deleting_fulcrum || { log "fulcrum" "warning message, abort" ; return 1 ; }

build_fulcrum_docker || { echo "Build failed. Aborting" ; enter_continue ; return 1 ; }

run_fulcrum_docker || { announce "Docker run failed. Aborting." ; return 1 ; }

check_rpc_authentication_exists || { announce "Failed to set rpc authentication details from bitcoin.conf" ; return 1 ; }

add_IP_fulcrum_config_mac  

installed_config_add "fulcrum-end"

#start docker if it isn't running 
if ! docker ps >/dev/null 2>&1 ; then start_docker_mac ; fi

start_fulcrum_docker

fulcrum_success_install

return 0
}