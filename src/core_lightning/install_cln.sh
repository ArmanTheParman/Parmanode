
function install_cln {
version="$core_lightning_version"

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if grep -q "lnd-" $ic || grep -q "lnddocker" $ic ; then
  announce "Parmanode is not configured to install C Lightning if
  \r    LND is already installed. Aborting." && return 1
fi

systemctl is-active --quiet core-lightning && 
if yesorno "It seems like you have installed C Lightning yourself without
    the help of Parmanode, or using the old script in Parmanode from
    the extras menu. To use this installation, C lightning needs to
    be uninstalled.
$cyan
    Would you like to run the Parmanode uninstall script now to clean
    up the old installation? 
$orange
    DO NOT DO THIS IF YOU MANUALLY INSTALLED C LIGHTNING, IT MAY NOT
    WORK. JUST MANUALLY REMOVE ALL REMNANTS OF C LIGHTNING YOURSELF,
    THEN RUN THIS INSTALL AGAIN." ; then
    uninstall_cln || return 1
    yesorno "Continue now to install C Lightning?" || return 1
else
    return 1
fi

check_port_9735 || return 1

if ! yesorno "Would you like to compile Core Lightning? $cyan(The Alternative 
    is to use pre-built official binaries and gpg verify them).$orange 
    
    Compiling is great, but it takes longer and prone to failure." ; then
    core_lightning_binaries
else
    core_lightning_dependencies || return 1
    installed_conf_add "cln-start"
    download_core_lightning || return 1
    compile_core_lightning || return 1
    deactivate #deactivate virtual environment
fi


mkdir $HOME/.lightning/ >$dn 2>&1

make_cln_config
make_cln_service
lightning-cli createrune >$dn 2>&1
installed_conf_add "cln-end"
success "Core Lightning has been installed."
}

function core_lightning_dependencies {
version="$core_lightning_version"


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
  git checkout v"$core_lightning_version" 
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


function check_port_9735 {

if netstat -tulnp 2>/dev/null | grep -q :9735 ; then
    announce "Port 9735 seems to be in use, perhaps because of a lightning installation 
    \r    that exists. You can stop or uninstall that before trying again.
    
    \r    Type yolo and <enter> to install anyway, anything else to abort."
    [[ $enter_cont == "yolo" ]] || return 1
fi
}

function core_lightning_binaries {
version="$core_lightning_version"

mkdir $hp/core_lightning || enter_continue
cd $hp/core_lightning || enter_continue
curl -LO https://github.com/ElementsProject/lightning/releases/download/v$version/clightning-v$version-Ubuntu-22.04-amd64.tar.xz
curl -LO https://github.com/ElementsProject/lightning/releases/download/v$version/SHA256SUMS-v$version
curl -LO https://github.com/ElementsProject/lightning/releases/download/v$version/SHA256SUMS-v$version.asc

import_core_lightning_gpg
sha256sum --check SHA256SUMS-v$version --ignore-missing || { enter_continue "shasum check failed. Aborting" ; return 1 ; }

tar -xvf *xz
sudo mkdir -p /usr/bin /usr/share /usr/libexec
sudo cp -R ./usr/bin/* /usr/bin/ || enter_continue
sudo cp -R ./usr/share/* /usr/share/ || enter_continue 
sudo cp -R ./usr/libexec/* /usr/libexec/ || enter_continue
} 


#lightning-cli showrunes

#connecting zeus to clightning:
   # give a name
   # choose Clightning REST
   # choose "use tor"
   # url is onion address, no port
   # port is 3778
   # rune is extracted from the command : lightning-cli showrunes