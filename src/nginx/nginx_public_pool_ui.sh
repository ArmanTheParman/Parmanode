function nginx_public_pool_ui {

#Set variables first

nginx_conf="$macprefix/etc/nginx/nginx.conf"
nginx_root="$macprefix/etc/nginx/"
ssl_cert="$hp/public_pool_ui/cert.pem" 
ssl_key="$hp/public_pool_ui/key.pem" 

if [[ $OS == Mac ]] ; then
conf_file="$nginx_root/public_pool_ui.conf"

elif [[ $OS == Linux ]] ; then
conf_file="$nginx_root/conf.d/public_pool_ui.conf"
fi

#needs to be after variables set
if [[ $1 = "remove" ]] ; then
    sudo rm "$conf_file" >/dev/null 2>&1
    sudo gsed -i "/public_pool_ui.conf/d" $nginx_conf  #will apply only to Macs anyway.
else #install

#might need to install nginx
if ! which nginx >/dev/null ; then install_nginx ; fi

echo -en "
server {
        listen 5052 ssl;
        listen 5051;

        ssl_certificate $ssl_cert; 
        ssl_certificate_key $ssl_key; 
        ssl_session_timeout 4h;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers on;
        
        location / {
            proxy_pass http://localhost:80;
        }
}
" | sudo tee $conf_file >/dev/null 2>&1

    if [[ $OS == Mac ]] ; then
    parmased "$nginx_conf" "http {" "    include $conf_file;" "after" "silent"
    fi

fi #not remove ends


#restart
    if [[ $OS == Linux ]] ; then 
        sudo nginx -t >$dn 2>$dp/nginx_error.log && sudo systemctl restart nginx >/dev/null 2>&1 
    elif [[ $OS == Mac ]] ; then
        nginx -t >$dn 2>$dp/nginx_error.log && brew services restart nginx >/dev/null 2>&1 
    fi
}