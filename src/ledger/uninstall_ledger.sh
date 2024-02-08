function uninstall_ledger {
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Ledger Live 
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

set_terminal

rm -rf $HOME/parmanode/ledger

if [[ $OS == Mac ]] ; then
rm -rf /Applications/"Ledger Live"*
fi

installed_conf_remove "ledger"
success "Ledger Live" "being uninstalled."
}