unction install_lnd {
download_lnd
verify_lnd || return 1
unpack_lnd

sudo install -m 0755 -o root -g root -t /usr/local/bin $HOME/parmanode/lnd/* >/dev/null 2>&1

make_dot_lnd


set_lnd_alias
make_lnd_conf

}