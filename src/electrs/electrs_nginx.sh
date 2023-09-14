function electrs_nginx {
#certificates need www-data owner.

which nginx >/dev/null || announce "Nginx not installed. Aborting." && return 1

if [[ $1 = "add" ]] ; then 
set_terminal
[ ! -f $HOME/parmanode/electrs/cert.pem ] || announce "Can't add SSL redirection using Nginx - no certificate found. Aborting." && return 1
[ ! -f $HOME/parmanode/electrs/key.pem ] || announce "Can't add SSL redirection using Nginx - no key found. Aborting." && return 1

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
# Parmanode - flag electrs-END" | sudo tee -a /etc/nginx/nginx.conf >/dev/null 2>&1
sudo systemctl restart nginx >/dev/null
fi

if [[ $1 = "remove" ]] ; then
sudo sed -i "/electrs-START/,/electrs-END/d" /etc/nginx/nginx.conf >/dev/null
sudo systemctl restart nginx >/dev/null
fi

}