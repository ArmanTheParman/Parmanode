function electrs_nginx {
#certificates need www-data owner.

sudo rm -rf /etc/nginx/conf.d/electrs.conf >/dev/null 2>&1

if cat $HOME/.parmanode/installed.conf | grep -q fulcrum ; then #check fulcrum installed to avoid conflict of ports
set_terminal
echo "stream {
        upstream electrs {
                server 127.0.0.1:50005;
        }

        server {
                listen 50006 ssl;
                proxy_pass electrs;

                ssl_certificate /path/to/example.crt;
                ssl_certificate_key /path/to/example.key;
                ssl_session_cache shared:SSL:1m;
                ssl_session_timeout 4h;
                ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
                ssl_prefer_server_ciphers on;
        }
}" | sudo tee /etc/nginx/conf.d/electrs.conf >/dev/null 2>&1
fi


}