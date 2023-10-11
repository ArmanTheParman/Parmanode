function uninstall_trezor {
set_terminal ; echo "
########################################################################################

                                 Uninstall Sparrow 

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

rm -rf $HOME/parmanode/trezor

if [[ $OS == Mac ]] ; then
rm -rf /Applications/"Trezor Suite"
fi

installed_conf_remove "trezor"
success "Trezor Suite" "being uninstalled."

}