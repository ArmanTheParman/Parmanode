function uninstall_piapps {
while true ; do 
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall PiApps 
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

clear
echo -e "
########################################################################################

    Please be aware that uninstalling PiApps does not uninstall any programs it may
    have installed for you.

########################################################################################
"
enter_continue ; jump $enter_cont
clear

cd $hp/pi-apps
./uninstall
cd $hp
sudo rm -rf $hp/pi-apps >$dn 2>&1
installed_conf_remove "piapps-"
success "PiApps" "being uninstalled"
}