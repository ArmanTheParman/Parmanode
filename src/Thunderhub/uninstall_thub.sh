function uninstall_thub {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Thunderhub 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

docker stop thunderhub 
rm -rf $hp/thunderhub
parmanode_conf_remove "thub_port"
installed_config_remove "thunderhub"
success "Thunderhub has been uninstalled"
}