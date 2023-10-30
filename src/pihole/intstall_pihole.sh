# Need to disable ubuntu/Mint dns server if it's running.
# sudo systemctl stop systemd-resolved.service
# then disable
# then edit /etc/resolv.conf - change name server google, 8.8.8.8


#check for docker install
if ! which docker >/dev/null 2>&1 ; then install_docker ; fi

#if nginx is installed, need to release port 80
sudo sed -i 's/^listen 80/listen 50080/ default_server;/' /etc/nginx/sites-enabled/default
sudo sed -i 's/^listen [::]:80/listen [::]:50080 default_server;/' /etc/nginx/sites-enabled/default
sudo systemctl restart nginx.serivce

#check it worked
sudo netstat -tulnp | grep ":80"
#