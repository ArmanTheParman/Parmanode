# Linux, then Mac
function build_dependencies_electrs {
if [[ $OS == Linux ]] ; then
please_wait
sudo apt-get update -y >/dev/null 2>&1

if ! which clang >/dev/null ; then sudo apt-get install -y clang ; fi
if ! which cmake >/dev/null ; then sudo apt-get install -y cmake ; fi

if ! dpkg -l >/dev/null | grep build-essential ; then sudo apt-get install -y build-essential ; fi 

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
if ! which cargo ; then 
    install_cargo || return 1
else
    if [[ $(cargo --version | cut -d . -f 2) -lt 63 ]] ; then
    debug "will uninstall then reinstall cargo, because < 63 version"
    sudo apt-get purge cargo rustc -y
    install_cargo || return 1
    fi
fi
fi #end if Linux
debug "end if linux in build dependencies"

if [[ $OS == Mac ]] ; then
brew update ; brew upgrade

if ! which automake   > /dev/null 2>&1 ; then brew install automake   ; fi
if ! which libtool    > /dev/null 2>&1 ; then brew install libtool    ; fi
if ! which pkg-config > /dev/null 2>&1 ; then brew install pkg-config ; fi

#installs rust (with cargo)
if ! which cargo >/dev/null 2>&1 ; then brew install rust ; fi

if ! which clang >/dev/null 2>&1 ; then brew install --cask clay ; fi

if [[ ! -e /Library/Developer/CommandLineTools ]] ; then
xcode-select --install
# /Library/Developer/CommandLineTools (delete to uninstall build-essentials)
fi

if [[ $(cargo --version | cut -d . -f 2) -lt 63 ]] ; then
brew upgrade rust
fi
fi
}