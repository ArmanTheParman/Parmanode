function website_domain {
unset domain site_name

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                    Domain Name
$orange

    Do you have a domain name to use? 

$cyan                 n)$orange           No, just use my internal IP address 
                                          (for local use only)

$cyan                 e)$orange           No, just use my external IP address 

$cyan                 y)$orange           ${green}Yes, and configure it

$cyan                 t)$orange           Tell me how ...

$cyan                 r)$orange           ${red}Remove my domain$orange from Parmanode configuration 


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;; 
n|N|No|no) 
export domain="$IP"
export IP_choice="internal"
parmanode_conf_remove "domain="
parmanode_conf_remove "domain_name="
parmanode_conf_add "domain=\"$IP\""
return 0
;;
e|E)
export domain="$external_IP"
export IP_choice="external"
parmanode_conf_remove "domain="
parmanode_conf_remove "domain_name="
parmanode_conf_add "domain=\"$external_IP\""
return 0
;;
y|Y)
export IP_choice="domainname"
break
# will get domain=string and www=true/false
;;
t|T)
get_a_domain
continue
;; 
r)
remove_domain
continue
;;

*)
invalid
;;
esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please type in your domain name, eg 
$cyan
        example.com
$orange    
    then$green <enter>$orange. If you have a 'www' prefix, you don't need to type that in here.

########################################################################################
"
choose "xpmq"
read domain ; set_terminal
case $domain in q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
"") 
continue
;;
*)
set_terminal ; echo -e "
########################################################################################

    You have chosen$cyan $domain $orange

    ${green}y$orange and$cyan <enter>$orange to accept, and anything else to try again.

########################################################################################
"
read accept ; if [[ $accept == "y" ]] ; then export domain ; break ; else continue ; fi
break
;;
esac
done

if ! echo $domain | grep -qE '^www\.' ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Would you like your domain with a 'www' prefix to also be accessible to visitors?

                                ${green}y)$orange       yes

                                ${red}n)$orange       no

########################################################################################
" 
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
n|N|NO|No|no)
export www="false"
break
;;
y|Y|Yes|yes)
export www="true"
debug "export www"
break
;;
*)
invalid
;;
esac
done
fi

parmanode_conf_remove "domain_name="
parmanode_conf_remove "domain="
parmanode_conf_remove "www="
parmanode_conf_add "domain_name=$domain"
parmanode_conf_add "www=$www"

source $pc
debug "source pc"

if [[ -n $domain_name && -e /etc/nginx/conf.d/$website.conf ]] ; then
    local file="/etc/nginx/conf.d/$domain_name.conf"
    sudo mv /etc/nginx/conf.d/$website.conf $file >/dev/null 2>&1

    if [[ $www == "true" ]] ; then www_name="www.$domain_name" ; fi
        
    local server_name="    server_name $domain_name $www_name;"
    swap_string "$file" "#put server___name" "$server_name"
    sudo systemctl restart nginx || echo "couldn't restart nginx. Something went wrong." && enter_continue
fi
debug "end of $website domain function"
}