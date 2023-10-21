#installs or uninstalls based on function argument
function electrs_nginx {
#certificates need www-data owner.

if ! which nginx >/dev/null ; then install_nginx ; fi

if [[ $OS == Mac ]] ; then
nginx_conf="/usr/local/etc/nginx/nginx.conf"
elif [[ $OS == Linux ]] ; then
nginx_conf="/etc/nginx/nginx.conf"
fi

if [[ $1 = "remove" ]] ; then
    if [[ $OS == Linux ]] ; then sudo sed -i "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null 
                                 sudo systemctl restart nginx >/dev/null 2>&1 ; fi
    if [[ $OS == Mac ]] ; then sudo sed -i '' "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null
                                 brew services restart nginx >/dev/null 2>&1 ; fi
return 0
fi

if [[ $1 = "add" ]] ; then 
set_terminal
[ ! -f $HOME/parmanode/electrs/cert.pem ] && { announce "Can't add SSL redirection using Nginx - no certificate found. Aborting." && return 1 ; }
[ ! -f $HOME/parmanode/electrs/key.pem ] && { announce "Can't add SSL redirection using Nginx - no key found. Aborting." && return 1 ; } 

echo "# Parmanode - flag electrs-START
stream {
        upstream electrs {
                server 127.0.0.1:50005;
        }

        server {
                listen 50006 ssl;
                proxy_pass electrs;

                ssl_certificate $HOME/parmanode/electrs/cert.pem; 
                ssl_certificate_key $HOME/parmanode/electrs/key.pem; 
                ssl_session_cache shared:SSL:1m;
                ssl_session_timeout 4h;
                ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
                ssl_prefer_server_ciphers on;
        }
}
# Parmanode - flag electrs-END" | sudo tee -a $nginx_conf >/dev/null 2>&1
if [[ $OS == Linux ]] ; then sudo systemctl restart nginx >/dev/null 2>&1 ; fi
if [[ $OS == Mac ]] ; then brew services restart nginx    >/dev/null 2>&1 ; fi
fi
}