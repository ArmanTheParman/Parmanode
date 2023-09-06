function enable_access_bre {

#check nginx installed
if ! which nginx ; then install_nginx ; fi

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
}" | sudo tee /etc/nginx/conf.d/btcrpcexplorer.conf >/dev/null

sudo systemctl restart nginx
parmanode_conf_add "bre_access=true"
}

function disable_access_bre {
if [ -f /etc/nginx/btcrpcexplorer.conf ] ; then
sudo rm /etc/nginx/btcrpcexplorer.conf >/dev/null
fi

sudo systemctl restart nginx
parmanode_conf_remove "bre_access=true"

}