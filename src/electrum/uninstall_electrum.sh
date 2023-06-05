function uninstall_electrum {

rm -rf $HOME/parmanode/electrum
installed_config_remove "electrum"

while true ; do
set_terminal ; echo "
########################################################################################

    Do you also wish to delete the Electrum configuration directory and wallet files?


                                  y)          Yes

                                  n)          No

########################################################################################
"
choose "x" ; read choice

case $choice in y|Y) rm -rf $HOME/.electrum ; break ;; n|N|NO|no) break ;; *) invalid ;; esac ; done

success "Electrum" "being uninstalled."

}