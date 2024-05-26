function nostrrelay_ssl_on {

if [[ $1 != install ]] && \
! nmap -p 80 $external_IP | grep 80 | grep -q open ; then
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

sudo systemctl restart nginx

if [[ $1 != install ]] ; then
success "SSL has been turned on"
else
set_terminal ; echo -e "${green}SSL certificate success."
sleep 1
fi
}
