function install_lnd {
download_lnd
verify_lnd
unpack_lnd
}

function unpack_lnd {
cd $HOME/parmanode && mkdir lnd >/dev/null 2>&1
tar -xvf lnd-* -C ./lnd
rm lnd-*
}