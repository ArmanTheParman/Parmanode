function uninstall_electrum {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Electrum 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done

sudo rm -rf $HOME/parmanode/electrum >$dn 2>&1
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