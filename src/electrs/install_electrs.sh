function install_electrs {
    set_terminal

    build_dependencies_electrs && log "electrs" "build_dependencies success"
    download_electrs && log "electrs" "download_electrs success" 
    compile_electrs && log "electrs" "compile_electrs success"

    debug "build, download, compile... done"

    # check Bitcoin settings
    unset rpcuser rpcpassword prune server
    source $HOME/.bitcoin/bitcoin.conf >/dev/null
    check_pruning_off || return 1
    check_server_1 || return 1
    check_bitcoin_auth_only

    #prepare drives
    choose_and_prepare_drive_parmanode "Electrs" && log "electrs" "choose and prepare drive function borrowed"
    prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; }
    #config
    make_electrs_config && log "electrs" "config done"
    debug "config done"

    make_electrs_service || log "electrs" "service file faile"

    installed_config_add "electrs-end"
    success "electrs" "being installed"


}

function build_dependencies_electrs {
please_wait
sudo apt update -y >/dev/null 2>&1

if ! which clang ; then sudo apt install -y clang ; fi

if ! which cmake ; then sudo apt install -y cmake ; fi

if ! dpkg -l | grep build-essential ; then sudo apt install -y build-essential ; fi 

# cargo install needed, but won't work if 64 bit system uses a 32 bit os,
# like Raspian OS 32-bit (it supports 64 bit chips, but cargo won't work)
if [[ $(uname -m) == "aarch64" ]] ; then 
    if [[ $(file /bin/bash | grep 64 | cut -d " " -f 3) != "64-bit" ]] ; then
    set_terminal ; echo "
########################################################################################
    It looks like you are running a 64-bit kernal on a 64-bit microprocessor but 
    with 32-bit binaries. While this is possible (eg Raspbian OS 32-bit for 64-bit
    Raspberry Pis) Electrs can't cope. Aborting. If you really want Electrs on this
    machine, you'll need to install the 64-bit version of the operating system,
    basically starting over completely. Sorry!
########################################################################################
"
enter_continue && return 1
fi
fi

# if old version of cargo, won't work
if ! which cargo ; then install_cargo
else
    if [[ $(cargo --version | cut -d . -f 2) -lt 63 ]] ; then
    sudo apt purge cargo rustc -y
    install_cargo
    fi
fi
}
########################################################################################

function install_cargo {
# The following is the recommended way to install cargo.
# The <<<'1' was added, and sends a 1 input to the interactive prompt, making the choice automatic.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh <<<'1'
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

function check_bitcoin_auth_only {

if [ -z $rpcuser ] ; then
while true ; do
set_terminal ; echo "
########################################################################################

    A username and password for Bitcoin Core authentication needs to be set for 
    Electrs to function properly. 
    
                            Do that now?   y   or   n

########################################################################################
"
read choice ; choose "xq"
case $choice in
q|Q) 
exit 0 ;;
y|Y|Yes|YES|yes)
set_rpc_authentication
return 0
;;
n|no|N|NO|No)
return 0
;;
*)
invalid ;;
esac ; done
fi
}

function make_electrs_config {
mkdir -p $HOME/.electrs

if [[ $drive_electrs == "external" ]] ; then 
    db_dir="/media/$USER/parmanode/electrs_db"
else
    db_dir="$HOME/parmanode/electrs/electrs_db"
fi

echo "daemon_rpc_addr = \"127.0.0.1:8332\"
daemon_p2p_addr = \"127.0.0.1:8333\"
db_dir=$db_dir
network=\"bitcoin\"
electrum_rpc_addr = \"127.0.0.1:50001\"
log_filters = \"INFO\"
auth=\"$rpcuser:$rpcpassword\"
" | tee $HOME/.electrs/config.toml >/dev/null

}

function prepare_drive_electrs {

mkdir -p $HOME/.electrs

if [[ $drive_electrs == "internal" ]] ; then
    mkdir -p $HOME/parmanode/electrs/electrs_db && return 0
fi

if [[ $drive_electrs == "external" ]] ; then
    mkdir -p /media/$USER/parmanode/electrs_db && return 0
fi  

return 1
}