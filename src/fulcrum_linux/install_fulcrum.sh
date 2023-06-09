function install_fulcrum {
set_terminal

install_check "fulcrum"
  #first check if Fulcrum has been installed
  return_value="$?"
  if [[ $return_value == "1" ]] ; then return 1 ; fi       #Fulcrum already installed
  log "fulcrum" "install check passed."

choose_and_prepare_drive_parmanode "Fulcrum"

fulcrum_make_directories
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make directories function exited."

make_fulcrum_config
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make config fucntion exited." 

download_fulcrum
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "Download exited." 

fulcrum_gpg
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "gpg exited." 

extract_fulcrum_tar
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "Download exited." 

sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/fulcrum/Ful*/Ful* && \
rm $HOME/parmanode/fulcrum/Ful*/Ful* || \
{ log "fulcrum" "failed to move/install files" ; debug "failed to move/install fulcrum files" ; return 1 ; }
log "fulcrum" "files installed"

make_ssl_certificates
  if [[ $? == 1 ]] ; then return 1 ; fi
  log "fulcrum" "make_ssl exited." 

check_fulcrum_pass

make_fulcrum_service_file
start_fulcrum_linux
fulcrum_success_install

return 0
}