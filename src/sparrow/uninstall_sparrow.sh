function uninstall_sparrow {

rm /usr/local/bin/Sparrow
rm -rf $HOME/.sparrow
rm -rf $HOME/parmanode/*parrow*
installed_conf_remove "sparrow"
success "Sparrow" "being uninstalled."
}