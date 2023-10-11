function uninstall_bitbox {
set_terminal ; echo "
########################################################################################

                                 Uninstall BitBox 

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

rm -rf $HOME/parmanode/bitbox

if [[ $OS == Mac ]] ; then
rm -rf /Applications/"BitBox.app"
fi

installed_conf_remove "bitbox"
success "BitBox App" "being uninstalled."

}