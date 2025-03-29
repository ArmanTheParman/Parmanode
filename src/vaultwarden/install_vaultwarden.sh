function install_vaultwarden {
install=vaultwarden
if ! grep docker-end $ic ; then announce "Please install Docker first. Aborting" ; return 1 ; fi
if ! docker ps >$dn ; then announce "Please start Docker first. Aborting." ; return 1 ; fi
if ! which nginx >$dn 2>&1 ; then install_nginx silent ; fi

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
      --restart unless-stopped \
      vaultwarden/server:latest || { enter_continue "Something went wrong." ; return 1 ; }

installed_config_add "vaultwarden-end"

success "VaultWarden has been installed"
unset install
}