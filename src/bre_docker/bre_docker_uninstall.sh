function bre_docker_uninstall {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                            Uninstall BTC RPC Explorer 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done
docker stop bre && docker rm -f bre && docker rmi -f bre

sudo rm -rf $HOME/parmanode/bre >$dn 2>&1

installed_config_remove "bre"

success "BTC RPC Explorer" "being uninstalled"
}