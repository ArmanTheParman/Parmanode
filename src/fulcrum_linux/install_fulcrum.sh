function install_fulcrum {
set_terminal

grep "bitcoin-end" $HOME/.parmanode/installed.conf >/dev/null || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

choose_and_prepare_drive "Fulcrum" || return 1

#if drive already prepared and mounted, skip format function
if [[ $drive_fulcrum == "external" ]] && [[ ! -d $pd/fulcrum_db ]] ; then
format_ext_drive "Fulcrum" || return 1 
fi

installed_config_add "fulcrum-start"
fulcrum_make_directories || return 1 ; log "fulcrum" "make directories function exited."

make_fulcrum_config || return 1 ; log "fulcrum" "make config fucntion exited." 

echo 'zmqpubhashblock=tcp://*:8433' | sudo tee -a $bc >$dn 2>&1

download_fulcrum || return 1 ; clear

verify_fulcrum || return 1 

extract_fulcrum || return 1 

fulcrum_install_files || return 1 

make_ssl_certificates fulcrum || return 1 

make_fulcrum_service_file

installed_config_add "fulcrum-end" 

start_fulcrum_linux

success "Fulcrum" "being installed"
}