function uninstall_sparrow {
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

if [[ $OS == "Linux" ]] ; then
rm -rf $HOME/.sparrow
rm -rf $HOME/parmanode/*parrow*
installed_config_remove "sparrow"
success "Sparrow" "being uninstalled."
fi

if [[ $OS == "Mac" ]] ; then
rm -rf $HOME/parmanode/*arrow*
rm -rf /Applications/*parrow*
installed_config_remove "sparrow"
success "Sparrow" "being uninstalled."
fi


rm $dp/.sparrow_first_run >/dev/null 2>&1

}
