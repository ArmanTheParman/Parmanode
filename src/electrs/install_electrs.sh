function install_electrs {

    build_dependencies_electrs
    download_electrs
    compile_electrs
    check_pruning_off || return 1

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

if ! cat $HOME/.bitcoin/bitcoin.conf | grep "prune=" ; then return 0 
else
    if cat $HOME/.bitcoin/bitcoin.conf | grep "prune=0" ; then return 0 
    announce "Note that Electrs won't work if Bitcoin is pruned. You'll have to" \
    "completely start bitcoin sync again without pruning to use Electrs. Sorry."
    return 1
    fi
fi


}