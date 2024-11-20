function uninstall_ledger {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Ledger Live 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done

set_terminal

sudo rm -rf $HOME/parmanode/ledger

if [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/"Ledger Live"*
fi

installed_conf_remove "ledger"
success "Ledger Live" "being uninstalled."
}