function install_lnd {
download_lnd
verify_lnd || return 1
unpack_lnd
}

