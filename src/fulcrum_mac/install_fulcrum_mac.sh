function install_fulcrum_mac {
set_terminal

grep "bitcoin-end" $HOME/.parmanode/installed.conf >/dev/null || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

choose_and_prepare_drive_parmanode "Fulcrum"
  if [[ $? == 1 ]] ; then return 1 ; fi

format_ext_drive "Fulcrum"

fulcrum_make_directories
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make directories function exited."

install_docker_intro
  if [[ $? == 1 ]] ; then log "docker" "installation abandoned" ; return 1 
  else
  log "docker" "Docker install to proceed."
  fi

if ! which docker >/dev/null 2>&1 ; then download_docker_mac ; fi
    if [ $? == 1 ] ; then return 1 ; fi

#start docker if it exists
if [[ $OS == "Mac" ]] ; then 
    if ! docker ps >/dev/null 2>&1 ; then start_docker_mac ; fi
fi

warning_deleting_fulcrum
  if [[ $? == 1 ]] ; then log "fulcrum" "warning message, abort" ; return 1 ; fi
  log "fulcrum" "warning message reached, continue."

build_fulcrum_docker
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "Fulcrum docker build done."

run_fulcrum_docker
  if [[ $? == 1 ]] ; then log "fulcrum" "run_fulcrum_docker returned 1" ; return 1 ; fi
  log "fulcrum" "Fulcrum docker run done."

check_rpc_authentication_exists && log "fulcrum" "check rpc auth exists done"

add_IP_fulcrum_config_mac  

installed_config_add "fulcrum-end"

#start docker if it exists
if [[ $OS == "Mac" ]] ; then 
    if ! docker ps >/dev/null 2>&1 ; then start_docker_mac ; fi
fi

start_fulcrum_docker
fulcrum_success_install

return 0
}