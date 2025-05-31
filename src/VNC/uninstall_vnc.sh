function uninstall_vnc {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall VNC
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

sudo rm -rf ~/.vnc/
sudo systemctl disable vnc.service >$dn 2>&1
sudo systemctl disable novnc.service >$dn 2>&1
sudo rm /etc/systemd/system/{novnc.service,vnc.service} >$dn 2>&1
installed_conf_remove "vnc-start"
installed_conf_remove "vnc-end"
success "Virtual Network Computing uninstalled"
}