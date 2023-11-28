function uninstall_qbittorrent {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall QBittorrent 
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

rm -rf $hp/qbittorrent /Applications/qbittorrent.app
installed_conf_remove "qbittorrent"
success "QBittorrent" "being uninstalled"
}