function install_fulcrum {
log "fulcrum" "delete" >/dev/null 2&>1

set_terminal

install_check "fulcrum-start"
    #first check if Fulcrum has been installed
    return_value="$?"
    if [[ $return_value = "1" ]] ; then return 1 ; fi       #Fulcrum already installed
    log "fulcrum" "install check passed."

fulcrum_drive_selectrion
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "drive seletected as $drive_fulcrum"

fulcrum_make_directories
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make directories function exited."

make_fulcrum_config
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make config fucntion exited." 




}