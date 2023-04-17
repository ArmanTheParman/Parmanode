function install_fulcrum {

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

make_fulcrum_config
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make config fucntion exited." 

download_fulcrum
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "Download exited." 

fulcrum_gpg.sh
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "gpg exited." 

extract_fulcrum_tar
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "Download exited." 


sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/fulcrum/download/Ful*/Ful* && \
rm $HOME/parmanode/fulcrum/download/Ful*/Ful* || \
{ log "fulcrum" "failed to move/install files" ; debug "failed to move/install fulcrum files" ; return 1 ; }

make_ssl_certificates
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make_ssl exited." 

make_fulcrum_service_file

fulcrum_success_install

return 0
}