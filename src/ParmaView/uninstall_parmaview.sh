function uninstall_parmaview {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall ParmaView
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

#stop connections
tmux kill-session -t ws1

#uninstall_cgi
    sudo umount $wwwparmaviewdir
    sudo rm -rf $parmaviewnginx
    sudo umount /opt/parmanode
    sudo systemctl restart nginx
    sudo systemctl disable fcgiwrap >$dn
    sudo rm -rf /etc/systemd/system/fcgiwrap.service.d
    sudo systemctl daemon-reload

installed_config_remove "parmaview"
success "ParmaView" "being uninstalled"

}