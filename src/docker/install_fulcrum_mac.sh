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

build_fulcrum_docker
  if [[ $? == 1 ]] ; then return 1 ; fi

warning_deleting_fulcrum
  if [[ $? == 1 ]] ; then return 1 ; fi

run_fulcrum_docker
  if [[ $? == 1 ]] ; then return 1 ; fi

edit_user_pass_fulcrum_docker
  if [[ $? == 1 ]] ; then return 1 ; fi

return 0
}