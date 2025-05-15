function uninstall_nym {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Nym VPN 
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

stop_nym 2>$dn
sudo apt remove --purge nym-vpn
rm -rf $hp/nym
installed_config_remove "nym-"
success "Nym VPN removed"
}