function install_fulcrum_mac {
set_terminal

install_check "fulcrum"
  #first check if Fulcrum has been installed
  return_value="$?"
  if [[ $return_value == "1" ]] ; then return 1 ; fi       #Fulcrum already installed
  log "fulcrum" "install check passed."

fulcrum_drive_selection
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "drive seletected as $drive_fulcrum"

fulcrum_make_directories
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make directories function exited."

install_docker_intro
  if [[ $? == 1 ]] ; then log "docker" "installation abandoned" ; return 1 
  else
  log "docker" "Docker install to proceed."
  fi

docker_install_check  

if [[ $docker_installed == "false" ]] ; then
    download_docker_mac
    if [ $? == 1 ] ; then return 1 ; fi
    fi

start_docker_mac
    if [ $? == 1 ] ; then return 1 ; fi
    log "docker" "Docker started"

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
    debug1 "check rpc auth exists should have been called."

installed_config_add "fulcrum-end"
start_fulcrum_docker
fulcrum_success_install

return 0
}