function remove_domain {
source $pc
if [[ -n $domain_name ]] ; then
while true ; do
set_terminal ; echo -e "$blue
########################################################################################

    You currently have a domain associated with your server, $domain_name

    Do you want to remove it?
$orange
                                    y)$blue     Yes
$orange
                                    n)$blue     No

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; n|N|no|NO) break ;; m|M) back2main ;;
y)
sudo rm /etc/nginx/conf.d/$domain_name.conf >$dn 2>&1
sudo mv /etc/nginx/conf.d/website.conf.backup /etc/nginx/conf.d/website.conf >$dn 2>&1
sudo systemctl restart nginx || echo "couldn't restart nginx. Something went wrong." && enter_continue
parmanode_conf_remove "domain_name="
parmanode_conf_remove "www="
break
;;

*)
invalid
;;
esac
done
else
set_terminal
echo -e "${red}No domain to remove...$blue"
sleep 1.5
fi
}