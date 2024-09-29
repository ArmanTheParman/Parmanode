function clear_sparrow {

set_terminal ; echo -e "
########################################################################################

    Please check that Sparrow is completely shut down before proceeding or changes
    may not take effect.

########################################################################################
"
enter_continue

sudo rm -rf $HOME/.sparrow/certs
sudo rm -rf $HOME/.sparrow/tor
debug "deleted sparrow connection settings"

success "Deleting Sparrow connection settings" "" 
}