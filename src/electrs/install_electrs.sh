function install_electrs {
while true ; do
set_terminal
echo "
########################################################################################
    
    Parmanode will now install ELECTRS on your system.

    Please note, you may be prompted to install cargo, a necessary program to compile
    electrs from source code. If you see an option to choose 1, 2, or 3, you need to
    select 1 to continue the installation.

    Also note, that because this is going to be compiled, no hash or gpg verification
    is necessary. This is because you are not trusting anyone per se, except that 
    the code is open source, and probably has had many eyes laid upon it. You are 
    of course free to read the code yourself to be sure. 

    This might take 10 to 30 minutes, depending on the speed of your computer.

    PROCEED?

                        y)      yes please, this is amazing

                        n)      nah mate
    
########################################################################################
"
read choice
case $choice in
n|No|nah|NO|no) return 1 ;;
y|yes|YES|Yes|yeah|shit_yeah) break ;;
*) invalid ;;
esac ; done ; set_terminal

    build_dependencies_electrs && log "electrs" "build_dependencies success"
    debug "build dependencies done"
    download_electrs && log "electrs" "download_electrs success" 
    debug "download electrs done"
    compile_electrs && log "electrs" "compile_electrs success"

    debug "build, download, compile... done"

    # check Bitcoin settings
    unset rpcuser rpcpassword prune server
    source $HOME/.bitcoin/bitcoin.conf >/dev/null
    check_pruning_off || return 1
    check_server_1 || return 1
    check_rpc_bitcoin

    #prepare drives
    choose_and_prepare_drive_parmanode "Electrs" && log "electrs" "choose and prepare drive function borrowed"
    prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; }
    #config
    make_electrs_config && log "electrs" "config done"
    debug "config done"

    make_electrs_service || log "electrs" "service file faile"

    installed_config_add "electrs-end"
    debug "finished electrs install"
    success "electrs" "being installed"


}

########################################################################################

function install_cargo {

announce "You will soon see a prompt to install cargo. Choose \"1\" to continue" \
"the installation."

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh 
source $HOME/.cargo/env #or restart shell
debug "install cargo function end"
}

function download_electrs {
cd $HOME/parmanode/ && git clone --depth 1 https://github.com/romanz/electrs && installed_config_add "electrs-start"
}

function compile_electrs {
set_terminal
announce "electrs does not need sha256 or gpg verification because it will be" \
"compiled from source."
set_terminal ; please_wait ; echo ""
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
