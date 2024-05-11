function remove_nginx_sites_enabled {

if [[ ! -e /etc/nginx/sites-enabled/default && ! -e /etc/nginx/sites-available/default ]] ; then return 0 ; fi

if [[ $1 != silent ]] ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode will remove the default server for nginx (the one that automatically is
    configured when nginx is installed).

    If this is meaningless to you, great, hit$cyan <enter>$orange to continue and 
    Parmanode will delete it; it's not needed.

    If you do run a server with Nginx already, then this installation is not for you. 
    You should hit$red a$orange and$cyan <enter>$orange to abort, otherwise Parmanode might 
    delete your server configuration.

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P|A|a) return 1 ;; "") break ;; m|M) back2main ;; *) invalid ;; 
esac
done
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default
return 0
else #silent removal because nginx just installed, no risk of removing wanted configuration files
sudo rm/etc/nginx/sites-enabled/default >/dev/null 2>&1
sudo rm/etc/nginx/sites-available/default >/dev/null 2>&1
fi
}