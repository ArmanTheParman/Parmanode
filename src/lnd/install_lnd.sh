function install_lnd {
set_terminal
please_wait

install_check "lnd" || return 1

make_lnd_directories && \
installed_config_add "lnd-start" 

download_lnd

verify_lnd || return 1
unpack_lnd

sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/lnd/lnd-*/* >/dev/null 2>&1

set_lnd_alias
set_lnd_password


make_lnd_conf

#do last. Also runs LND
make_lnd_service 

installed_conf_add "lnd-end"

success "lnd" "being installed."
return 0
}
