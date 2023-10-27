function uninstall_lnd {

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

sudo systemctl stop lnd.service
sudo rm /etc/systemd/system/lnd.service
rm -rf $HOME/parmanode/lnd $HOME/.lnd
parmanode_conf_remove "lnd_port"
installed_conf_remove "lnd"
success "LND" "being uninstalled."
return 0
}