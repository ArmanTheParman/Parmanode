
function install_core_lightning {

if [[ $OS == "Darwin" ]] ; then no_mac ; return 1 ; fi

check_port_9735 || return 1

if ! yesorno "Would you like to compile Core Lightning? (Alternative is to
    use pre-built official binaries and gpg verify them.) Compiling
    is great, but it takes longer and prone to failure." ; then
    
    core_lightning_binaries

else

core_lightning_dependencies || return 1
download_core_lightning || return 1
compile_core_lightning || return 1
deactivate #deactivate virtual environment

fi



#make_core_lightning_directories
mkdir $HOME/.lightning/ >$dn 2>&1

make_core_lightning_config

success "Core Lightning should now be installed. You can start it from the command line with
    ${green}
        lightningd
    $orange
    And to stop it...$red
    
        lightning-cli stop$orange"
    
}


function core_lightning_dependencies {

announce "${green}Will install Core Lightning dependencies and setup 
    virtual environment...$orange"


sudo apt-get update -y && export APT_UPDATE="true"
sudo apt-get install -y \
  jq autoconf automake build-essential git libtool libsqlite3-dev libffi-dev \
  python3 python3-pip net-tools zlib1g-dev libsodium-dev gettext \
  protobuf-compiler python3-grpc-tools cargo rustfmt protobuf-compiler \
  pkg-config valgrind libpq-dev shellcheck cppcheck libsecp256k1-dev lowdown \
  python3-venv \
  || { enter_continue "something went wrong with installing a dependency" ; return 1 ; }

python3 -m venv $hp/venv_core_lightning
source $hp/venv_core_lightning/bin/activate
pip3 install --upgrade pip  || { enter_continue "something went wrong with installing a dependency" ; return 1 ; }
pip3 install poetry mako grpcio-tools pytest || { enter_continue "something went wrong with installing a dependency" ; return 1 ; }

}

function download_core_lightning {
if [[ -e $HOME/parmanode/core_lightning ]] ; then
  cd $hp/core_lightning
  git pull
else
  announce "${green}Will download Core Lightning from GitHub.$orange"
  cd $hp
  git clone https://github.com/ElementsProject/lightning.git core_lightning
  cd core_lightning
fi
  git checkout v24.11.1
}


function compile_core_lightning {
announce "${green}Will start compiling Core Lightning; This will take a while.$orange"
./configure | tee $dp/.clightning_build.log 
cpus=$(nproc)
cpu_allocation=$((cpus -1))
if [[ $cpu_allocation -lt 2 ]] ; then cpu_allocation=1 ; fi
make -d -j$cpu_allocation | tee $dp/.clightning_build.log || { enter_continue "something went wrong with compiling" ; return 1 ; } 
enter_continue "make command success. Next 'sudo make install' "
sudo make install | tee $dp/.clightning_build.log || { enter_continue "something went wrong with compiling" ; return 1 ; } 
enter_continue "make install command successful."
}

function make_core_lightning_config {

announce "${green}Will make Core Lightning configuration file.$orange"

bitcoin__rpcport="$(cat $HOME/.bitcoin/bitcoin.conf | grep rpcport | cut -d = -f 2)" #no hyphens in bash variables
bitcoin__rpcport=${bitcoin__rpcport:-8332} #default

cat <<EOF >> $HOME/.lightning/config
daemon
log-file=$HOME/.lightning/log
network=bitcoin
bitcoin-cli=$(which bitcoin-cli)
bitcoin-datadir=$HOME/.bitcoin
bitcoin-rpcuser=$(cat $HOME/.bitcoin/bitcoin.conf | grep rpcuser | cut -d = -f 2)
bitcoin-rpcpassword=$(cat $HOME/.bitcoin/bitcoin.conf | grep rpcpassword | cut -d = -f 2)
bitcoin-rpcconnect=127.0.0.1
bitcoin-rpcport=$bitcoin__rpcport
alias=BananaStand
#fee-base=MILLISATOSHI
#fee-per-satoshi=MILLIONTHS
#min-capacity-sat=SATOSHI
EOF
return 0
}

function check_port_9735 {
if netstat -tulnp 2>/dev/null | grep -q :9735 ; then
    announce "Port 9735 seems to be in use, perhaps because of a lightning installation 
    \r    that exists. Please stop or uninstall that before trying again. Aborting."
    return 1
fi
}

function core_lightning_binaries {

mkdir $hp/core_lightning || enter_continue
cd $hp/core_lightning || enter_continue
curl -LO https://github.com/ElementsProject/lightning/releases/download/v24.11.1/clightning-v24.11.1-Ubuntu-22.04-amd64.tar.xz
curl -LO https://github.com/ElementsProject/lightning/releases/download/v24.11.1/SHA256SUMS
curl -LO https://github.com/ElementsProject/lightning/releases/download/v24.11.1/SHA256SUMS.asc

import_core_lightning_gpg || { announce "gpg check failed. Aborting" ; exit ; }
sha256sum --check SHA256SUMS --ignore-missing || { announce "shasum check failed. Aborting" ; exit ; }

tar -xvf *xz
sudo mkdir -p /usr/bin /usr/share /usr/libexec
sudo cp -r ./usr/bin/* /usr/bin/ || enter_continue
sudo cp -r ./usr/share/* /usr/share/ || enter_continue 
sudo cp -r ./usr/libexec/* /usr/libexec/ || enter_continue

} 