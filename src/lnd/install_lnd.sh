function install_lnd {
set_terminal
please_wait

install_check "lnd" || return 1

make_lnd_directories && \
installed_config_add "lnd-start" 

download_lnd

verify_lnd || return 1
unpack_lnd

sudo install -m 0755 -o root -g root -t /usr/local/bin $HOME/parmanode/lnd/lnd-*/* >/dev/null 2>&1

set_lnd_alias
set_lnd_password


make_lnd_conf ; debug1 "lnd conf made"

#do last. Also runs LND
make_lnd_service ; debug1 "make lnd service done"

installed_conf_add "lnd-end"

success "lnd" "being installed."
return 0
}
