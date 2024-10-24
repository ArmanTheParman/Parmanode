function uninstall_bitbox {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall BitBox 
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

sudo rm -rf $HOME/parmanode/bitbox >$dn 2>&1

if [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/"BitBox.app" >$dn 2>&1
fi

installed_conf_remove "bitbox"
success "BitBox App" "being uninstalled."
}