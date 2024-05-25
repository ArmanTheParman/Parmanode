function nostr_ssl_on {

if ! nmap -p 80 $external_IP | grep 80 | grep -q open ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please be aware that for this to work, you must have$pink port 80 and 443$orange opened 
    on your router and forwarded to this machine, otherwise the certificate generation
    process will fail.
    
    To continue, type$cyan free ross$orange and hit$cyan <enter>$orange otherwise just hit$red <enter>$orange 
    to abort this.

########################################################################################
"
choose "x" ; read choice ; set_terminal 
case $choice in
"free ross" | "Free Ross" | "free Ross" | "free Ross" | "freeross")
break
;;
*)
return 1
;;
esac
done
fi

source $pc
# Run cerbot # Port 80 needs to be open. 
sudo certbot --nginx -d $domain_name || { echo -e "\nSomething went wrong" ; enter_continue ; return 1 ; }
parmanode_conf_add "nostr_ssl=\"true\""

swap_string "/etc/nginx/conf.d/$domain_name.conf" "try_files" "
    proxy_pass http://localhost:7080;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;

    # WebSocket support
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \\"upgrade\\";
"
debug "after swapstring nginx"

sudo systemctl restart nginx

success "SSL has been turned on"
}