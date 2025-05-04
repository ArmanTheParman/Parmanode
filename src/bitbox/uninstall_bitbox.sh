function uninstall_bitbox {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall BitBox 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done

set_terminal

sudo rm -rf $HOME/parmanode/bitbox >$dn 2>&1

if [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/"BitBox.app" >$dn 2>&1
fi

installed_conf_remove "bitbox"
success "BitBox App" "being uninstalled."
}