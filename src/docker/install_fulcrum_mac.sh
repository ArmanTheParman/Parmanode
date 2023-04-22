function install_fulcrum_mac {
set_terminal

install_check "fulcrum-start"
  #first check if Fulcrum has been installed
  return_value="$?"
  if [[ $return_value = "1" ]] ; then return 1 ; fi       #Fulcrum already installed
  log "fulcrum" "install check passed."

fulcrum_drive_selection
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "drive seletected as $drive_fulcrum"

fulcrum_make_directories
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make directories function exited."

install_docker
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "Docker install done"
  
build_fulcrum_docker
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "Fulcrum docker build done."

warning_deleting_fulcrum
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "warning message reached."
  
run_fulcrum_docker
  if [[ $? == 1 ]] ; then log "fulcrum" "run_fulcrum_docker returned 1" ; return 1 ; fi
  log "fulcrum" "Fulcrum docker run done."

edit_user_pass_fulcrum_docker
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "user/pass edited in docker fulcrum.conf" 

installed_config_add "fulcrum-end"

return 0
}