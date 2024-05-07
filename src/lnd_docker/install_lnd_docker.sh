function install_lnd_docker {
set_terminal
export install=lnddocker
export lndversion="v0.17.3-beta"

grep -q bitcoin-end < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
install_check "lnd" || { announce "LND seems to already be installed. Aborting" ; return 1 ; }
install_check "lnddocker" || { announce "LND seems to already be installed. Aborting" ; return 1 ; }
if docker ps | grep -q lnd ; then
announce "LND in Docker seems to be running. Aborting Installation."
return 1 
fi

please_wait

make_lnd_directories || return 1
installed_config_add "lnddocker-start" 


#apply variables first
modify_lnd_dockerfile || return 1
build_lnd_docker || return 1
lnd_docker_run || return 1



unset install
}