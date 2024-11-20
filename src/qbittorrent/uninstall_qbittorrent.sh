function uninstall_qbittorrent {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall QBittorrent 
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

sudo rm -rf $hp/qbittorrent /Applications/qbittorrent.app
installed_conf_remove "qbittorrent"
success "QBittorrent" "being uninstalled"
}