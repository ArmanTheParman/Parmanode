function uninstall_green {
set_terminal ; echo -e "
########################################################################################
$cyan
                                  Uninstall Green
$orange
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

set_terminal

if [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/Blockstream*app >$dn 2>&1
elif [[ $OS == Linux ]] ; then
sudo rm -rf $HOME/parmanode/green >$dn 2>&1
fi

installed_conf_remove "green"
success "BlockStream Green App" "being uninstalled."
}