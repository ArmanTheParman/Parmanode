function uninstall_pihole {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall PiHole 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
esac
done

cd $hp/pihole
docker compose down
cd
sudo rm -rf $hp/pihole
installed_conf_remove "pihole"
success "PiHole" "being uninstalled"
return 0
}