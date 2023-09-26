function uninstall_lnbits {
set_terminal ; echo "
########################################################################################

                                 Uninstall LNbits 

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

please_wait

docker stop lnbits 2>/dev/null
docker rm lnbits 2>/dev/null
docker rmi lnbits 2>/dev/null
sudo rm -rf $HOME/parmanode/lnbits >/dev/null 2>&1

#sudo systemctl stop lnbits.service
#sudo systemctl disable lnbits.service
#sudo systemctl rm /etc/systemd/system/lnbits.service

installed_config_remove "lnbits"
success "LNbits" "being uninstalled."
return 0

}