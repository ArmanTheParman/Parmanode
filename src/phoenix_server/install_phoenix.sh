function install_phoenix {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if [[ $chip != "x86_64" ]] && [[ $chip != "aarch64" ]] && [[ $(file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
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
verify_phoenix || enter_continue "Something went wrong with verification"
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
gpg --verify S*.asc || return 1
}