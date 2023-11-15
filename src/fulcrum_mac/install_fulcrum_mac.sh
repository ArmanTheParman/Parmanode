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

warning_deleting_fulcrum
  if [[ $? == 1 ]] ; then log "fulcrum" "warning message, abort" ; return 1 ; fi
  log "fulcrum" "warning message reached, continue."

build_fulcrum_docker || return 1 ; log "fulcrum" "Fulcrum docker build done."
debug "build fulcrum docker done"
run_fulcrum_docker
  if [[ $? == 1 ]] ; then log "fulcrum" "run_fulcrum_docker returned 1" ; return 1 ; fi
debug "Fulcrum docker run done."

check_rpc_authentication_exists || announce "No bitcoin conf file found. You'll have to edit it yourself 
    with a usernamd and password, matching to the Fulcrum config, to make
    it all work. Otherwise, control-c to quit, get Bitcoin setup 
    properly, then try installing Fulcrum again."
if ! grep -q userpass < $HOME/.bitcoin/bitcoin.conf ; then
announce "Can't install without bitcoin user/pass set. Aborting."
return 1
fi

debug "check rpc auth exists"
add_IP_fulcrum_config_mac  

installed_config_add "fulcrum-end"

#start docker if it isn't running 
if ! docker ps >/dev/null 2>&1 ; then start_docker_mac ; fi

start_fulcrum_docker
fulcrum_success_install

return 0
}