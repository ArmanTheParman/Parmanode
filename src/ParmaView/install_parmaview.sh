function install_parmaview {
#CGI
sudo systemctl disable fcgiwrap >$dn 2>&1 #in case it is running (needs modification)
sudo mkdir -p /etc/systemd/system/fcgiwrap.service.d
installed_config_add "parmaview-start"
cat<<EOS | sudo tee /etc/systemd/system/fcgiwrap.service.d/override.conf >$dn 2>&1
[Service]
User=$USER
Group=$USER
EOS
sudo apt update ; sudo apt install -y fcgiwrap ; sudo systemctl enable --now fcgiwrap
sudo mkdir -p $wwwparmaviewdir
sudo mount --bind $pp/parmanode/src/ParmaView/ $wwwparmaviewdir || sww "Mounting cgi-bin failed."
sudo mkdir -p /opt/parmanode
sudo mkdir -p /run/parmanode
sudo chmod 2771 /run/parmanode
sudo chown parman:www-data /run/parmanode
sudo mount --bind $pp/parmanode /opt/parmanode || sww "Mounting parmanode to /opt/parmanode failed."
sudo setfacl -R -d -m u:www-data:rX /opt/parmanode #uppercase X for directories only, and already executable files.

#Nginx
install_nginx
make_parmaview_nginx_conf || return 1

#Finish
installed_config_add "parmaview-end"
if [[ $1 != silent ]] ; then
success "ParmaView has been installed"
fi
}