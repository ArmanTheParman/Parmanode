function install_fulcrum_docker {
if [[ $OS == Linux ]] ; then announce "Docker version is not for Linux. Aborting." ; return 1 ; fi
export fulcrumdocker="true"
sned_sats
set_terminal
grep -q "bitcoin-end" $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
grep -q "docker-end" $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

#start docker if it is not running 
if ! docker ps >/dev/null 2>&1 ; then 
announce "Please make sure Docker is running, then try again. Aborting."
return 1
fi

#remove old container, just in case
docker stop fulcrum >/dev/null 2>&1 
docker rm fulcrum >/dev/null 2>&1 

choose_and_prepare_drive "Fulcrum" || return 1 #gets drive_fulcrum variable

#if drive already prepared and mounted, skip format function
if [[ $drive_fulcrum == "external" ]] && [[ ! -d $pd/fulcrum_db ]] ; then
format_ext_drive "Fulcrum" || return 1 
fi

installed_config_add "fulcrum-start"
fulcrum_make_directories || return 1 ; log "fulcrum" "make directories function exited."

echo 'zmqpubhashblock=tcp://*:8433' | sudo tee -a $bc >$dn 2>&1

make_ssl_certificates fulcrum || return 1

build_fulcrum_docker || { echo "Build failed. Aborting" ; enter_continue ; return 1 ; }

run_fulcrum_docker || { announce "Docker run failed. Aborting." ; return 1 ; }

installed_config_add "fulcrum-end"

start_fulcrum_docker

success "Fulcrum" "being installed"
}
