function uninstall_sparrow {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Sparrow 
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


rm -rf $HOME/.sparrow
rm -rf $HOME/parmanode/*parrow* #redundant, folder doesn't exist yet, but will later.

if [[ $OS == "Mac" ]] ; then
sudo rm -rf /Applications/Sparrow.app
fi

installed_config_remove "sparrow"
success "Sparrow" "being uninstalled."
#clean up downloads
rm -rf $hp/"*parrow-1."*

rm $dp/.sparrow_first_run >/dev/null 2>&1
}
