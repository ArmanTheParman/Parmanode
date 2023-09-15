function install_electrs {

grep "bitcoin-end" "$HOME/.parmanode/installed.conf" >/dev/null || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

unset electrs_compile && restore_elctrs #get electrs_compile true/false
[[ $electrs_compile == "false" ]] || preamble_install_electrs || return 1
[[ $electrs_compile == "false" ]] && mv $HOME/.electrs_backup $HOME/parmanode/electrs


[[ $electrs_compile == "true" ]] && build_dependencies_electrs && log "electrs" "build_dependencies success" ; debug "build dependencies done"

log "electrs" "compile_electrs $compile_electrs"
if [[ $electrs_compile == "true" ]] ; then
download_electrs && log "electrs" "download_electrs success" ; debug "download electrs done"
compile_electrs && log "electrs" "compile_electrs success" ; debug "build, download, compile... done"
elif [[ $electrs_compile == "false" ]] ; then
rm -rf $HOME/parmanode/electrs
cp -r $HOME/.electrs_backup $HOME/parmanode/electrs/
fi

make_ssl_certificates "electrs" || announce "SSL certificate generation failed. Proceed with caution." ; debug "ssl certs done"
install_nginx #the function chethis is amazcks first before attempting install.
electrs_nginx add

# check Bitcoin settings
unset rpcuser rpcpassword prune server
source $HOME/.bitcoin/bitcoin.conf >/dev/null
check_pruning_off || return 1
check_server_1 || return 1
check_rpc_bitcoin

#prepare drives
choose_and_prepare_drive_parmanode "Electrs" && log "electrs" "choose and prepare drive function borrowed"
format_ext_drive "electrs" || return 1
prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } ; debug "prepare drive done"


#config
make_electrs_config && log "electrs" "config done" ; debug "config done"

make_electrs_service || log "electrs" "service file failed" ; debug "service file done"

installed_config_add "electrs-end" ; debug "finished electrs install"

success "electrs" "being installed"

backup_electrs

}

########################################################################################

function install_cargo {

announce "You may soon see a prompt to install Cargo. Choose \"1\" to continue" \
"the installation"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh 
source $HOME/.cargo/env #or restart shell
debug "install cargo function end"
}

function download_electrs {
cd $HOME/parmanode/ && git clone --depth 1 https://github.com/romanz/electrs && installed_config_add "electrs-start"
}

function compile_electrs {
set_terminal ; echo "   Compiling electrs..."
please_wait ; echo ""
cd $HOME/parmanode/electrs && cargo build --locked --release
}

function check_pruning_off {
    if [[ $prune -gt 0 ]] ; then
    announce "Note that Electrs won't work if Bitcoin is pruned. You'll have to" \
    "completely start bitcoin sync again without pruning to use Electrs. Sorry."
    return 1
    else
    return 0
    fi
}

function check_server_1 {
if [[ $server -ne 1 ]] ; then 
announce "\"server=1\" needs to be included in the bitcoin.conf file." \
"Please do that and try again. Aborting." 
return 1 
fi
}


