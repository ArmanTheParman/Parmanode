function uninstall_piapps {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall PiApps 
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

cd $hp/pi-apps
./uninstall
cd $hp
rm -rf $hp/pi-apps 2>&1
installed_conf_remove "piapps-"
success "PiApps" "being uninstalled"
}