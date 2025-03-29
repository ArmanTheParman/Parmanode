function install_vaultwarden {
install=vaultwarden
if ! docker ps >$dn ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1 ; fi

if ! which nginx >$dn 2>&1 ; install_nginx silent ; fi

mkdir -p $hp/vaultwarden 
installed_config_add "vaultwarden-start"

vaultwarden_tor
make_ssl_certificates vaultwarden
make_vaultwarden_nginx

docker run -d \
      --name vaultwarden \
      -e WEBSOCKET_ENABLED=true \
      -v $HOME/.vw_data:/data \
      -p 19080:80 \
      -restart unless-stopped \
      vaultwarden/server:latest || { enter_continue "Something went wrong." ; return 1 ; }

installed_config_add "vaultwarden-end"

success "VaultWarden has been installed"
unset install
}