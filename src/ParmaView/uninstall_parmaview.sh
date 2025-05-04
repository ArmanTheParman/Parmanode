function uninstall_parmaview {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall ParmaView
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done

export wwwdir="$macprefix/var/www/parmanode_cgi"
export cginginx="macprefix/etc/nginx.conf.d/parmaview_cgi.conf"

if ! docker ps >$dn ; then announce \
"Please make sure Docker is running before asking Parmanode to
    clean up the installed ParmaView."
return 1
fi
docker stop parmaview 
docker rm parmaview 
docker rmi parmaview
sudo rm -rf $HOME/parmanode/parmaview >$dn
uninstall_cgi
installed_config_remove "parmaview"
success "ParmaView" "being uninstalled"

}