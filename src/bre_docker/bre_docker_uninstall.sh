function bre_docker_uninstall {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall BRE 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal
if [[ $choice == y ]] ; then true ; else return 1 ; fi

docker stop bre && docker rm -f bre && docker rmi -f bre

rm -rf $HOME/parmanode/bre >/dev/null 2>&1

installed_config_remove "bre"

success "BTC RPC Explorer" "being uninstalled"
}