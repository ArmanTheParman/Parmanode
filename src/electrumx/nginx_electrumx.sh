#installs or uninstalls based on function argument
function nginx_electrumx {
#certificates need www-data owner.


#order of if's matter ; Mac, redundant for now
if [[ $OS == Mac ]] ; then
    if ! which nginx >/dev/null ; then install_nginx ; fi
nginx_conf="/usr/local/etc/nginx/nginx.conf"
ssl_cert="$HOME/parmanode/electrumx/cert.pem" 
ssk_key="$HOME/parmanode/electrumx/key.pem"

elif [[ $OS == Linux ]] ; then
    if ! which nginx >/dev/null ; then install_nginx ; fi
nginx_conf="/etc/nginx/nginx.conf"
ssl_cert="$HOME/parmanode/electrumx/cert.pem" 
ssk_key="$HOME/parmanode/electrumx/key.pem"

elif [[ $1 == electrumxdkr ]] ; then #must be last #electrumxdkr non-existent now.
nginx_conf=/etc/nginx/nginx.conf
ssl_cert="/home/parman/parmanode/electrumx/cert.pem" #absolute path, used within container.
ssl_key="/home/parman/parmanode/electrumx/key.pem"
fi

if [[ $1 = "add" || $1 == electrumxdkr ]] ; then 

echo -e " 
stream {
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

if [[ $1 == electrumxdkr ]] ; then
debug "before cat | docker tee"
cat /tmp/nginx_conf | docker exec -iu root electrumx bash -c "tee -a $nginx_conf >/dev/null 2>&1"
debug "after cat | docker tee"
return 0
fi

if [[ $OS == Linux ]] ; then sudo systemctl restart nginx >/dev/null 2>&1 ; fi
if [[ $OS == Mac ]] ; then brew services restart nginx    >/dev/null 2>&1 ; fi
fi

#needs to be at the end
if [[ $1 = "remove" ]] ; then
    if [[ $OS == Linux ]] ; then sudo sed -i "/electrumx-START/,/electrumx-END/d" $nginx_conf >/dev/null 
                                 sudo systemctl restart nginx >/dev/null 2>&1 ; fi
    #redundant, and, causing errors; should never run. 
    if [[ $OS == Mac ]] ; then sudo sed -i '' "/electrumx-START/,/electrxum-END/d" $nginx_conf >/dev/null
                                 brew services restart nginx >/dev/null 2>&1 ; fi
return 0
fi


}