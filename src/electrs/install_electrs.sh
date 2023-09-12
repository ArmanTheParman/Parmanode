function install_electrs {

sudo apt update -y

if ! which clang ; then sudo apt install -y clang ; fi

if ! which cmake ; then sudo apt install -y cmake ; fi

if ! dpkg -l | grep build-essential ; then sudo apt install -y build-essential ; fi 

if ! which git ; then sudo apt install -y git ; fi

if ! which cargo ; then sudo apt install -y cargo ; fi #not working on aarch64, downloads 32 bit for some reason

cd $HOME/parmanode/ ; git clone --depth 1 https://github.com/romanz/electrs
cd electrs

#please follow prompts to insall cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh
source $HOME/.cargo/env #or restart shell

}