function uninstall_specter {
set_terminal ; echo "
########################################################################################

                                 Uninstall Specter 

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

if [[ $OS == "Linux" ]] ; then
rm -rf $HOME/.specter
rm -rf $HOME/parmanode/*pecter*
installed_config_remove "specter"
success "Specter" "being uninstalled."
fi

if [[ $OS == "Mac" ]] ; then
rm -rf $HOME/parmanode/*pecter*
rm -rf /Applications/*pecter*
installed_config_remove "specter"
success "Specter" "being uninstalled."
fi
}