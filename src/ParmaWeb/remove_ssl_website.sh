function remove_ssl_website {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Do you want to remove the certificates for your domain that was made by Certbot?
    The actual certificates will be removed, and the Nginx configuration file will
    be modified by certbot. If things go wrong, you can choose to delete your domain
    which will reset the configuration file to the default (no domain, listening on
    port 80), and then you can add your domain again, and add certificates again later
    if you want.
$cyan
                                    y)$orange     Yes
$cyan
                                    n)$orange     No

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P|n|N|NO|No) return 1 ;; m|M) back2main ;;
y)
break
;;
*) invalid ;;
esac
done

sudo rm /etc/nginx/conf.d/$domain_name.conf
make_website_nginx

sudo certbot delete --cert-name $domain_name --nginx
if [[ $www == "true" ]] ; then 
sudo certbot delete --cert-name "www.$domain_name" --nginx
fi
sudo systemctl restart nginx || echo "couldn't restart nginx. Something went wrong." && enter_continue
parmanode_conf_remove "website_ssl=true"
}
