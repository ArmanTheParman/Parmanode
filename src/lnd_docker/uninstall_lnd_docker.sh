function uninstall_lnd_docker {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall LND $orange

    DATA WILL BE LOST!    

    Please note that even if you are uninstalling to then install a newer version of
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

lnd_docker_stop silent
docker rm lnd
rm -rf $hp/lnd $HOME/.lnd/
installed_conf_remove "lnddocker"
success "LND Docker has finished being uninstalled"
}