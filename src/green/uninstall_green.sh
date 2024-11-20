function uninstall_green {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                  Uninstall Green
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

if [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/Blockstream*app >$dn 2>&1
elif [[ $OS == Linux ]] ; then
sudo rm -rf $HOME/parmanode/green >$dn 2>&1
fi

installed_conf_remove "green"
success "BlockStream Green App" "being uninstalled."
}