function website_ssl_on {

if ! nmap -p 80 $external_IP | grep 80 | grep -q open ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please be aware that for this to work, you must have$pink port 80$orange opened on your
    router and forwarded to this machine, otherwise the certificate generation
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

parmanode_conf_add "website_ssl=true"
success "SSL has been turned on for your website"
}