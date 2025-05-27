function uninstall_i2p {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall I2P 
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
stop_i2p

if [[ $computer_type == "Pi" ]] ; then
sudo apt-get remove --purge -y i2p i2p-keyring
else
sudo rm -rf $HOME/i2p >$dn 2>&1
fi

sudo rm $dp/scripts/i2p.sh
sudo systemctl disable i2p.service >$dn 2>&1
sudo rm -rf etc/systemd/system/i2p.service 2>&1

installed_config_remove "i2p-"
success "I2P uninstalled"
}