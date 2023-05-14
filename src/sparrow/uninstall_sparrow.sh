function uninstall_sparrow {
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

}
