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

installed_config_add "lnddocker-start" 
make_lnd_directories || return 1


#apply variables first
modify_lnd_dockerfile || return 1
build_lnd_docker || return 1
lnd_docker_run || return 1
debug "after docker run and start"

installed_config_add "lnddocker-end"

success "LND Docker" "being installed"
unset install
}

function uninstall_lnd_docker {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall LND $orange

    Please note that if you are uninstalling to then install a newer version of
    LND,$pink your data will be deleted in the process$orange - please backup everything
    related to Lightning that's important to you. If you are unsure, it may be
    better to learn exactly what you're doing first.

    Uninstall, are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

lnd_docker_stop
docker rm lnd
rm -rf $hp/lnd $HOME/.lnd/
installed_conf_remove "lnddocker"
success "LND Docker has finished being uninstalled"
}