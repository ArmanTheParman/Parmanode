function enable_access_bre {

#check nginx installed
if ! which nginx ; then install_nginx ; fi

if [[ $OS == Mac ]] ; then
local $file="/usr/local/etc/nginx/conf.d/btcrpcexplorer.conf"
else
local $file="/etc/nginx/conf.d/btcrpcexplorer.conf"
fi


echo "server {
    listen 3003;
    server_name _;

    location / {
        proxy_pass http://localhost:3002;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}" | sudo tee $file  >/dev/null

sudo systemctl restart nginx 2>/dev/null || brew services restart nginx 2>dev/null
}

function disable_access_bre {

sudo rm /etc/nginx/conf.d/btcrpcexplorer.conf 2>/dev/null || \
sudo rm /usr/local/etc/nginx/conf.d/btcrpcexplorer.conf 2>/dev/null

sudo systemctl restart nginx 2>/dev/null || brew services restart nginx 2>dev/null
}