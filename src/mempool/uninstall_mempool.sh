function uninstall_mempool {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Mempool?
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

if ! docker ps > $dn 2>&1 ; then
announce "Docker needs to be running. Aborting."
return 1
fi
nogsedtest
cd $hp/mempool/docker && docker compose down
#need sudo, some dirs have container permissions
cd $hp && sudo rm -rf $hp/mempool
sudo gsed -i "/mempool-service/d" $macprefix/etc/tor/torrc 
sudo gsed -i "/127.0.0.1:8180/d" $macprefix/etc/tor/torrc 
installed_config_remove "mempool-"
success "Mempool" "being uninstalled"

}