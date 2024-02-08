#installs or uninstalls based on function argument
function electrs_nginx {
#certificates need www-data owner.

if [[ $1 = "remove" ]] ; then
    if [[ $OS == Linux ]] ; then sudo sed -i "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null 
                                 sudo systemctl restart nginx >/dev/null 2>&1 ; fi
    if [[ $OS == Mac ]] ; then sudo sed -i '' "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null
                                 brew services restart nginx >/dev/null 2>&1 ; fi
return 0
fi

if [[ $1 == electrsdkr ]] ; then
nginx_conf=/etc/nginx/nginx.conf
ssl_cert="/home/parman/parmanode/electrs/cert.pem"
ssl_key="/home/parman/parmanode/electrs/key.pem"

elif [[ $OS == Mac ]] ; then
    if ! which nginx >/dev/null ; then install_nginx ; fi
nginx_conf="/usr/local/etc/nginx/nginx.conf"
ssl_cert="$HOME/parmanode/electrs/cert.pem" 
ssk_key="$HOME/parmanode/electrs/key.pem"

elif [[ $OS == Linux ]] ; then
    if ! which nginx >/dev/null ; then install_nginx ; fi
nginx_conf="/etc/nginx/nginx.conf"
ssl_cert="$HOME/parmanode/electrs/cert.pem" 
ssk_key="$HOME/parmanode/electrs/key.pem"
fi

if [[ $1 = "add" || $1 == electrsdkr ]] ; then 

echo "# Parmanode - flag electrs-START
stream {
        upstream electrs {
                server 127.0.0.1:50005;
        }

        server {
                listen 50006 ssl;
                proxy_pass electrs;

                ssl_certificate $ssl_cert; 
                ssl_certificate_key $ssl_key; 
                ssl_session_cache shared:SSL:1m;
                ssl_session_timeout 4h;
                ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
                ssl_prefer_server_ciphers on;
        }
}
# Parmanode - flag electrs-END" | sudo tee -a /tmp/nginx_conf >/dev/null 2>&1

if [[ $1 == electrsdkr ]] ; then
cat /tmp/nginx_conf | docker exec -iu root electrs tee -a $nginx_conf >/dev/null 2>&1
return 0
fi

if [[ $OS == Linux ]] ; then sudo systemctl restart nginx >/dev/null 2>&1 ; fi
if [[ $OS == Mac ]] ; then brew services restart nginx    >/dev/null 2>&1 ; fi
fi
}