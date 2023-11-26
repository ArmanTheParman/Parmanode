function uninstall_electrum {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Electrum 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal
if [[ $choice == y ]] ; then true ; else return 1 ; fi

rm -rf $HOME/parmanode/electrum >/dev/null 2>&1
installed_config_remove "electrum"
if [[ $OS == "Mac" ]] ; then rm -rf /Applications/Electrum.app ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################

    Do you also wish to delete the Electrum configuration directory and wallet files?

    (Note that if you are upgrading Electrum to a newer version, you only need to
    replace the application file(s); the configuration directory can be left alone
    and it will work with the newer version of Electrum)

$red
                                  y)          Yes
$green
                                  n)          No
$orange
########################################################################################
"
choose "x" ; read choice

case $choice in y|Y) rm -rf $HOME/.electrum ; break ;; n|N|NO|no) break ;; *) invalid ;; esac ; done

success "Electrum" "being uninstalled."

}