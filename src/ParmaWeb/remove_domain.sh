function remove_domain {
source $pc
if [[ -n $domain_name ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    You currently have a domain associated with your server, $domain_name

    Do you want to remove it?

                                    y)     Yes

                                    n)     No

########################################################################################
"
read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; n|N|no|NO) break ;;
y)
sudo rm /etc/nginx/conf.d/$domain_name.conf >/dev/null 2>&1
sudo mv /etc/nginx/conf.d/website.conf.backup /etc/nginx/conf.d/website.conf >/dev/null 2>&1
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
echo "${green}No domain to remove...$orange"
sleep 1.5
fi
}