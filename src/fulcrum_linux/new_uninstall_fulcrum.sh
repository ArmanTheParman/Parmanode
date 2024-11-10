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



if ! grep -q "fulcrum" $ic >$dn 2>&1 ; then
    set_terminal 
    echo "Fulcrum is not installed. You can skip uninstallation."
    enter_continue
    return 1 
    fi

if grep -q "fulcrumdkr" $ic >$dn 2>&1 ; then
docker stop fulcrum >/dev/null 2>&1 
docker rm fulcrum >/dev/null 2>&1 
docker rmi fulcrum >/dev/null 2>&1 
else
sudo rm /usr/local/bin/Fulcrum* 2>$dn
sudo rm /etc/systemd/system/fulcrum.service 2>$dn
fi

sudo rm -rf $hp/fulcrum >$dn 2>&1
sudo rm -rf $HOME/.fulcrum >$dn 2>&1

fulcrum_tor_remove
sudo gsed -i '/zmqpubhashblock=tcp.+8433/d' $bc >$dn 2>&1

parmanode_conf_remove "drive_fulcrum"
installed_config_remove "fulcrum"

success "Fulcrum" "being uninstalled"
}