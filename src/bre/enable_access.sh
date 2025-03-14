function enable_access_bre {
unset file
#check nginx installed
if ! sudo which nginx >$dn 2>&1 ; then install_nginx ; fi

if [[ $OS == Mac ]] ; then
local file="/usr/local/etc/nginx/btcrpcexplorer.conf"
else
local file="/etc/nginx/conf.d/btcrpcexplorer.conf"
fi


echo -e "server {
    listen 3003;
    server_name _;

    location / {
        proxy_pass http://localhost:3002;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}" | sudo tee $file  >$dn

sudo systemctl restart nginx 2>$dn || brew services restart nginx 2>$dn
}
