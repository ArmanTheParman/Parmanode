function uninstall_pihole {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall PiHole 
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

cd $hp/pihole
docker compose down
cd
sudo rm -rf $hp/pihole
installed_conf_remove "pihole"
success "PiHole" "being uninstalled"
return 0
}