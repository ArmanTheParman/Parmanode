function uninstall_vaultwarden {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall VaultWarden
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
rem)
rem="true"
break
;;
esac
done

stop_vaultwarden
docker rm vaultwarden

yesorno "Do you want to delete your data directory as well, ie where your passwords are?" &&
yesorno "ARE YOU SURE???" &&
rm -rf $hp/vaultwarden

installed_config_remove "vaultwarden-"
success "VaultWarden has been uninstalled"
}