function install_parmannostr {

#intro - what parmanostr does. Recommend own relay.
#dependencies
installed_confif_add "parmanostr-start"
#make wallet
#make gpg keys
#make a backup of the wallet and encrypt with gpg


installed_config_add "parmanostr-end"
success "ParmanNostr has been installed"

}