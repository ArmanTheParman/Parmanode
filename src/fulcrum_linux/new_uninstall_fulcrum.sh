function new_uninstall_fulcrum {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Fulcrum 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal
if [[ $choice == y ]] ; then true ; else return 1 ; fi

#uninstall....
please_wait

if grep -q "fulcrumdkr" $ic || [[ $OS == Mac ]] ; then
if ! docker ps >$dn 2>&1 ; then announce "Please make sure Docker is running. Aborting." ; return 1 ; fi
docker stop fulcrum >/dev/null 2>&1 
docker rm fulcrum >/dev/null 2>&1 
docker rmi fulcrum >/dev/null 2>&1 
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

parmanode_conf_remove "drive_fulcrum"
installed_config_remove "fulcrum"

success "Fulcrum" "being uninstalled"
}