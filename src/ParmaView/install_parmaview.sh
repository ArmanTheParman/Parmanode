function install_parmaview {
yesorno "ParmaView is a Docker container with the purpose of orchestrating a
    communication channel to a browser interface for Parmanode.

    Install?" || return 1

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
sudo apt update ; sudo apt install -y fcgiwrap ; sudo systemctl enable --now fcgiwrap
installed_config_add "parmaview-start"
sudo mkdir -p $wwwparmaviewdir
sudo mount --bind $pp/parmanode/src/ParmaView/ $wwwparmaviewdir || sww "Mounting cgi-bin failed."
sudo mkdir -p /opt/parmanode
sudo mount --bind $pp/parmanode /opt/parmanode || sww "Mounting parmanode to /opt/parmanode failed."
sudo setfacl -R -m u:www-data:rwx /opt/parmanode
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