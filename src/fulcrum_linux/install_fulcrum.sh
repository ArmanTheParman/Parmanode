function install_fulcrum {
set_terminal

grep "bitcoin-end" $HOME/.parmanode/installed.conf >/dev/null || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

choose_and_prepare_drive "Fulcrum" ; clear

format_ext_drive "Fulcrum" || return 1 ; clear

move_old_fulcrum_db 

fulcrum_make_directories || return 1 ; log "fulcrum" "make directories function exited."

make_fulcrum_config || return 1 ; log "fulcrum" "make config fucntion exited." 

download_fulcrum || return 1 ; log "fulcrum" "Download exited."  ; clear

verify_fulcrum || return 1 ; log "fulcrum" "gpg exited." 

extract_fulcrum || return 1 ; log "fulcrum" "Download exited." 

fulcrum_install_files || return 1 ; log "fulcrum" "fulcrum_install_files failed."

make_ssl_certificates || return 1 ; log "fulcrum" "make_ssl exited." 

make_fulcrum_service_file

installed_config_add "fulcrum-end" && log "fulcrum" "install finished"

start_fulcrum_linux

success "Fulcrum" "being installed"
}