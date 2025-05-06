function install_parmaview {
yesorno "ParmaView is a Docker container with the purpose of orchestrating a
    communication channel to a browser interface for Parmanode.

    Install?" || return 1
clear

if ! which docker > $dn ; then announce "Please install Docker from the Parmanode install menu first."
return 1
fi

if ! docker ps >$dn ; then announce "Please make sure Docker is running first."
return 1
fi

if docker ps | grep -q parmaview ; then 
announce "The parmaview container is already running."
return 1
fi

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
#Docker
please_wait
parmaview_build || { enter_continue && announce "build failed" && return 1 ; }
parmaview_run
parmanode_in_parmaview
#Finish
installed_config_add "parmaview-end"
if [[ $1 != silent ]] ; then
success "ParmaView has been installed"
fi
}