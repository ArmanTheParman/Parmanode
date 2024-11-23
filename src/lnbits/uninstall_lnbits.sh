function uninstall_lnbits {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall LNbits 
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

configure_yourself || return 1

please_wait

docker stop lnbits 2>$dn
docker rm lnbits 2>$dn
docker rmi lnbits 2>$dn
sudo rm -rf $HOME/parmanode/lnbits >$dn 2>&1

#sudo systemctl stop lnbits.service
#sudo systemctl disable lnbits.service
#sudo systemctl rm /etc/systemd/system/lnbits.service

installed_config_remove "lnbits"
success "LNbits" "being uninstalled."
return 0

}