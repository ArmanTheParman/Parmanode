function install_phoenix {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

yesorno "Phoenix is a Bitcoin lightning wallet developed by ACINQ, They say
    it is self-custodial, which means that you hold the keys of the wallet. 

    As I understand it, because they can manage lightning channels$red THEY MUST 
    ALSO HAVE YOUR PRIVATE KEY - SO ITS SHARED CUSTODY, NOT REALLY SELF CUSTORY.$orange
    
    The convenience might be worth it, just use it for small amounts.

    This istallation is for the sever, not the wallet. It's for advanced users.

    Install?" || return 1


if [[ $(uname -m) != "x86_64" ]] && [[ $(uname -m) != "aarch64" ]] && [[ $(file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
yesorno "Non-64 bit architecture detected. It's unlikely to work if you
    proceed, but Parmanode could be wrong.

    Install?" || return 1
fi

installed_config_add "phoenix-start"

set_terminal

[[ ! -e $hp/phoenix ]] && mkdir -p $hp/phoenix 
cd $hp/phoenix
download_phoenix || enter_continue "Something went wrong with the download"
clear
verify_phoenix || return 1
clear
unzip_phoenix

installed_config_add "phoenix-end"
success "Phoenix Server has been installed"
}

function download_phoenix {
curl -LO https://github.com/ACINQ/phoenixd/releases/download/v0.4.2/SHA256SUMS.asc
curl -LO https://github.com/ACINQ/phoenixd/releases/download/v0.4.2/phoenix-0.4.2-linux-x64.zip
}

function unzip_phoenix {
which unzip >$dn || sudo apt-get update -y && sudo apt-get install unzip -y
unzip -j *.zip
}

function verify_phoenix {
gpg --import $pn/src/phoenix_server/phoenix_gpg_key.asc
gpg --verify S*.asc || { enter_continue "Something went wrong with importing the phoenix public key." ; return 1 ; }
enter_continue "gpg verification$green passed$orange"
shasum --check ./SHA256SUMS.asc || { enter_continue "SHA256 verification$red failed." ; return 1 ; }
enter_continue "SHA256 check passed"
}