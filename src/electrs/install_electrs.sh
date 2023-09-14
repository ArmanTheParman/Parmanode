function install_electrs {

    restore_elctrs #get electrs_compile true/false

    preamble_install_electrs || return 1

    install_nginx #the function checks first before attempting install.
    electrs_nginx add
    build_dependencies_electrs && log "electrs" "build_dependencies success" ; debug "build dependencies done"

    log "electrs" "compile_electrs $compile_electrs"
    if [[ $compile_electrs == "true" ]] ; then
    download_electrs && log "electrs" "download_electrs success" ; debug "download electrs done"
    compile_electrs && log "electrs" "compile_electrs success" ; debug "build, download, compile... done"
    elif [[ $compile_electrs == "false" ]] ; then
    rm -rf $HOME/parmanode/electrs
    cp -r $HOME/.electrs_backup $HOME/parmanode/electrs/
    fi


    # check Bitcoin settings
    unset rpcuser rpcpassword prune server
    source $HOME/.bitcoin/bitcoin.conf >/dev/null
    check_pruning_off || return 1
    check_server_1 || return 1
    check_rpc_bitcoin

    #prepare drives
    choose_and_prepare_drive_parmanode "Electrs" && log "electrs" "choose and prepare drive function borrowed"
    prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } ; debug "prepare drive done"

    make_ssl_certificates "electrs" || announce "SSL certificate generation failed. Proceed with caution." ; debug "ssl certs done"

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
"the installation."

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

function restore_elctrs {

if [ -d $HOME/.electrs_backup ] ; then
while true ; do
set_terminal
echo "
########################################################################################

    Parmanode has detected that you've previously compiled and backup up electrs.

    To save time, would you like to use that backup or comile electrs all over again.

    If that was an old version, you'll need to compile again instead, to get the new
    version, of course.

                       u)    Use backup

                       c)    Compile again

########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in
q|Q) exit 0 ;;
p|P) return 1 ;;
u|U|use|Use) export electrs_compile="false" && return 0 ;;
c|C|compile) export electrs_compile="true" && return 0 ;;
*) invalid ;;
esac
done
else
export electrs_compile="true" 
fi
}
