function install_electrs {

sudo apt update -y

if ! which clang ; then sudo apt install -y clang ; fi

if ! which cmake ; then sudo apt install -y cmake ; fi

if ! dpkg -l | grep build-essential ; then sudo apt install -y build-essential ; fi 

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

if ! which cargo ; then sudo install_cargo
else
    if [[ $(cargo --version | cut -d . -f 2) -lt 63 ]] ; then
    sudo apt purge cargo rustc -y
    install_cargo
fi

cd $HOME/parmanode/ ; git clone --depth 1 https://github.com/romanz/electrs
cd electrs

#please follow prompts to insall cargo


}

function install_cargo {
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh
source $HOME/.cargo/env #or restart shell
}