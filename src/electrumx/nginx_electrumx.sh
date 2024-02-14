#installs or uninstalls based on function argument
function nginx_electrumx {
#certificates need www-data owner.


#order of if's matter ; Mac, redundant for now
if [[ $OS == Mac ]] ; then
nginx_conf="/usr/local/etc/nginx/nginx.conf"
ssl_cert="$HOME/parmanode/electrumx/cert.pem" 
ssk_key="$HOME/parmanode/electrumx/key.pem"
nginx_electrumx_conf="/usr/local/etc/nginx/electrumx.conf"

elif [[ $OS == Linux ]] ; then
nginx_conf="/etc/nginx/nginx.conf"
ssl_cert="$HOME/parmanode/electrumx/cert.pem" 
ssk_key="$HOME/parmanode/electrumx/key.pem"
nginx_electrumx_conf="/etc/nginx/electrumx.conf"
fi

if [[ $1 = "remove" ]] ; then
install_gsed #redundant for now
delete_line "$nginx_conf" "electrumx.conf" 2>/dev/null
sudo rm /etc/nginx/conf.d/electrs.conf 2>/dev/null

else #add

#might need to install nginx
if ! which nginx >/dev/null ; then install_nginx ; fi

echo -e "stream {
        upstream electrumx {
                server 127.0.0.1:50007;
        }

        server {
                listen 50008 ssl;
                proxy_pass electrumx;

                ssl_certificate $ssl_cert; 
                ssl_certificate_key $ssl_key; 
                ssl_session_timeout 4h;
                ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
                ssl_prefer_server_ciphers on;
        }
}" | sudo tee /tmp/nginx_conf >/dev/null 2>&1
fi

if [[ $OS == Linux ]] ; then sudo systemctl restart nginx >/dev/null 2>&1 ; fi
if [[ $OS == Mac ]] ; then brew services restart nginx    >/dev/null 2>&1 ; fi

}