function install_electrs {

    build_dependencies_electrs
    download_electrs
    compile_electrs

    # check Bitcoin settings
    unset rpcuser rpcpassword prune server
    source $HOME/.bitcoin/bitcoin.conf >/dev/null
    check_pruning_off || return 1
    check_server_1 || return 1
    check_bitcoin_auth_only

    #config
    make_electrs_config 
}

function build_dependencies_electrs {
sudo apt update -y

if ! which clang ; then sudo apt install -y clang ; fi

if ! which cmake ; then sudo apt install -y cmake ; fi

if ! dpkg -l | grep build-essential ; then sudo apt install -y build-essential ; fi 

# cargo install needed, but won't work if 64 bit system uses a 32 bit os,
# like Raspian OS 32-bit (it supports 64 bit chips, but cargo won't work)
if $(uname -m) == "aarch64" ; then 
    if [[ $(file /bin/bash | grep 64 | cut -d " " -f 3) != "64-bit" ]] then
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
if ! which cargo ; then sudo install_cargo
else
    if [[ $(cargo --version | cut -d . -f 2) -lt 63 ]] ; then
    sudo apt purge cargo rustc -y
    install_cargo
fi
}
########################################################################################

function install_cargo {
#please follow prompts to insall cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh
source $HOME/.cargo/env #or restart shell
}

function download_electrs {
cd $HOME/parmanode/ && git clone --depth 1 https://github.com/romanz/electrs
}

function compile_electrs {
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

choose_db_dir

echo "daemon_rpc_addr = \"127.0.0.1:8332\"
daemon_p2p_addr = \"127.0.0.1:8333\"
db_dir=$db_dir
network=\"bitcoin\"
electrum_rpc_addr = \"127.0.0.1:50001\"
log_filters = \"INFO\"
auth=\"$rpcuser:$rpcpassword\"
" | tee $HOME/.electrs/config.toml >/dev/null

}