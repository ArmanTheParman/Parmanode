function uninstall_fulcrum {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Fulcrum 
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

#uninstall....
please_wait

nogsedtest
if grep -q "fulcrumdkr" $ic || [[ $OS == Mac ]] ; then
[[ $debug == 1 ]] || if ! docker ps >$dn 2>&1 ; then announce "Please make sure Docker is running. Aborting." ; return 1 ; fi
docker stop fulcrum >$dn 2>&1 
docker rm fulcrum >$dn 2>&1 
docker rmi fulcrum >$dn 2>&1 
else
sudo rm /usr/local/bin/Fulcrum* 2>$dn
sudo systemctl disable fulcrum.service 2>$dn
sudo rm /etc/systemd/system/fulcrum.service 2>$dn
sudo systemctl daemon-reload 2>$dn
fi

sudo rm -rf $hp/fulcrum >$dn 2>&1
sudo rm -rf $HOME/.fulcrum >$dn 2>&1

fulcrum_tor_remove
sudo gsed -i '/zmqpubhashblock=tcp.*8433$/d' $bc >$dn 2>&1
parmanode_conf_remove "configure_bitcoin_self" 
parmanode_conf_remove "drive_fulcrum"
installed_config_remove "fulcrum"

success "Fulcrum" "being uninstalled"
}