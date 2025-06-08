function uninstall_parmadesk {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall ParmaDesk
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
esac
done

sudo rm -rf ~/.vnc/ $hp/vnc
sudo systemctl disable vnc.service >$dn 2>&1
sudo systemctl disable noVNC.service >$dn 2>&1
parmadesk_tor_remove
sudo systemctl $macprefix/etc/nginx/conf.d/vnc.conf >$dn 2>&1
sudo systemctl restart nginx >$dn 2>&1
sudo rm /etc/systemd/system/{noVNC.service,vnc.service} >$dn 2>&1
installed_conf_remove "vnc-"
installed_conf_remove "parmadesk-"
success "Virtual Network Computing uninstalled"
}