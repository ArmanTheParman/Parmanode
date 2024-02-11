function nginx_public_pool_ui {

if [[ $OS == Mac ]] ; then
    if ! which nginx >/dev/null ; then install_nginx ; fi
nginx_conf="/usr/local/etc/nginx/nginx.conf"
ssl_cert="$hp/public_pool_ui/cert.pem" 
ssk_key="$hp/public_pool_ui/key.pem" 

elif [[ $OS == Linux ]] ; then
    if ! which nginx >/dev/null ; then install_nginx ; fi
nginx_conf="/etc/nginx/nginx.conf"
ssl_cert="$hp/public_pool_ui/cert.pem" 
ssk_key="$hp/public_pool_ui/key.pem" 
fi

echo "# Parmanode - flag public_pool_ui-START
stream {
        upstream public_pool_ui {
                server localhost:5050;
        }

        server {
                listen 5052 ssl;
                listen 5051;
                proxy_pass public_pool_ui;

                ssl_certificate $ssl_cert; 
                ssl_certificate_key $ssl_key; 
                ssl_session_cache shared:SSL:1m;
                ssl_session_timeout 4h;
                ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
                ssl_prefer_server_ciphers on;
        }
        
}
# Parmanode - flag public_pool_ui-END" | sudo tee /tmp/nginx_conf >/dev/null 2>&1

}