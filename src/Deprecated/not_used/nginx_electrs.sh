#installs or uninstalls based on function argument
function nginx_electrs {
echo "deprecated"
sleep 5
exit 0
#certificates need www-data owner.


#order of if's matter
if [[ $OS == Mac ]] ; then
nginx_conf="/usr/local/etc/nginx/nginx.conf"
ssl_cert="$HOME/parmanode/electrs/cert.pem" 
ssk_key="$HOME/parmanode/electrs/key.pem"
nginx_electrs_conf="/usr/local/etc/nginx/electrs.conf"

elif [[ $OS == Linux ]] ; then
nginx_conf="/etc/nginx/nginx.conf"
ssl_cert="$HOME/parmanode/electrs/cert.pem" 
ssk_key="$HOME/parmanode/electrs/key.pem"
nginx_electrs_conf="/etc/nginx/electrs.conf"
fi

# made redundant
# elif [[ $1 == electrsdkr ]] ; then #must be last
# nginx_conf=/etc/nginx/nginx.conf
# ssl_cert="/home/parman/parmanode/electrs/cert.pem" #absolute path, used within container.
# ssl_key="/home/parman/parmanode/electrs/key.pem"
# fi

if [[ $1 = "remove" ]] ; then
install_gsed #checks and installs or returns
#gsed works mac, and alias to sed for linux
sudo gsed -i "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null  2>&1 #redundant
delete_line "$nginx_conf" "electrs.conf" 2>/dev/null
sudo rm $nginx_electrs_conf 2>/dev/null

else #add

#might need to install nginx
if ! which nginx >/dev/null ; then install_nginx ; fi

#parmased "$nginx_conf" "http {" "    include electrs.conf;" "after" "silent"
echo "include electrs.conf;" | tee -a $nginx_conf >/dev/null 2>&1

echo "stream {
        upstream electrs {
                server 127.0.0.1:50005;
        }

        server {
                listen 50006 ssl;
                proxy_pass electrs;

                ssl_certificate $ssl_cert; 
                ssl_certificate_key $ssl_key; 
        }
}" | sudo tee $nginx_electrs_conf >/dev/null 2>&1
fi

if [[ $OS == Linux ]] ; then sudo systemctl restart nginx >/dev/null 2>&1 ; fi
if [[ $OS == Mac ]] ; then brew services restart nginx    >/dev/null 2>&1 ; fi

}