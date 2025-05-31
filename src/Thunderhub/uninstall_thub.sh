function uninstall_thub {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Thunderhub 
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

docker stop thunderhub ; docker rm thunderhub 
sudo rm -rf $hp/thunderhub
parmanode_conf_remove "thub_port"
installed_config_remove "thunderhub"
success "Thunderhub has been uninstalled"
}