function uninstall_lnd {

install_check "lnd" "uninstall" || return 1 

set_terminal ; echo "
########################################################################################

                                 Uninstall LND

    Are you sure? (y) (n)

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
installed_conf_remove "lnd"
success "LND" "being uninstalled."
return 0
}