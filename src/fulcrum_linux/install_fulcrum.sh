function install_fulcrum {
set_terminal

grep "bitcoin-end" $HOME/.parmanode/installed.conf >/dev/null || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

choose_and_prepare_drive "Fulcrum" ; clear

format_ext_drive "Fulcrum" || return 1 ; clear

fulcrum_make_directories || return 1 ; log "fulcrum" "make directories function exited."

make_fulcrum_config || return 1 ; log "fulcrum" "make config fucntion exited." 

download_fulcrum || return 1 ; log "fulcrum" "Download exited."  ; clear

fulcrum_gpg || return 1 ; log "fulcrum" "gpg exited." 

extract_fulcrum_tar || return 1 ; log "fulcrum" "Download exited." 

sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/fulcrum/Ful*/Ful* && \
rm $HOME/parmanode/fulcrum/Ful*/Ful* || \
{ log "fulcrum" "failed to move/install files" ; debug "failed to move/install fulcrum files" ; return 1 ; }
log "fulcrum" "files installed"

make_ssl_certificates || return 1 ; log "fulcrum" "make_ssl exited." 

make_fulcrum_service_file
start_fulcrum_linux
fulcrum_success_install

return 0
}