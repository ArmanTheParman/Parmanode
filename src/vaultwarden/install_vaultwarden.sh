function install_vaultwarden {

yesorno "Please be aware of a very nasty danger with password managers...

    They are not magical tools, they are databases that store your password in an
    encrypted way. You access them with a master password, resulting in decryption
    and reading of the passwords, never storing the actual passwords anywhere
    in readable format.

    But just because the database/server never sees your passwords, it doesn't 
    mean you're automatically safe. The client computer "sees" your decryption 
    password (because you type it to unlock), and if that leaks, ALL your passwords
    are exposed, including the bitcoin seed phrase you should never have added in 
    there. Be warned.

    Proceed to install VaultWarden?" || return 0

clear
install=vaultwarden
if ! grep docker-end $ic ; then announce "Please install Docker first. Aborting" ; return 1 ; fi
if ! docker ps >$dn ; then announce "Please start Docker first. Aborting." ; return 1 ; fi
if ! sudo which nginx >$dn 2>&1 ; then install_nginx silent ; fi

clear
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
