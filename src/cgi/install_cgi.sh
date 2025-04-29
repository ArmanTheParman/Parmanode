function install_cgi {
grep -q "cgi-end" $ic && return 0
if ! [[ $silent == "true" ]] ; then
yesorno "Do you want to enable the browser-based CGI interface?" || return 1
fi
install_nginx
install_fcgiwrap
make_cgi_nginx_conf || return 1
sudo mkdir -p $macprefix/var/www/parmanode_cgi
sudo mount --bind $pp/parmanode/src/cgi/cgi-bin $macprefix/var/www/parmanode_cgi || sww "Mounting cgi-bin failed."
installed_conf_add "cgi-end"
success "CGI interface for browser access enabled. User IP address and port 54000"
}

function install_fcgiwrap {
sudo apt update
sudo apt install -y fcgiwrap
sudo systemctl enable --now fcgiwrap
}

function uninstall_cgi {
yesorno "Do you want to disable the browser-based CGI interface?" || return 1
sudo rm $macprefix/etc/nginx/conf.d/parmanode_cgi.conf
sudo systemctl restart nginx
sudo apt remove -y fcgiwrap
sudo umount /var/www/parmanode_cgi 
installed_conf_remove "cgi-end"
success "CGI interface for browser access disabled"
}

function make_cgi_nginx_conf {

if ! [[ $silent == "true" ]] ; then
netstat -tuln 2>$dn | grep -q :54000 && { sww "Port 54000 is already in use. Unexpected. Can't continue, aborting." && return 1 ; }
fi

#SCRIPT_FILENAME neessary for fcgiwrap to know what to execute
#Other variables are for the script

cat <<EOF | sudo tee $macprefix/etc/nginx/conf.d/parmanode_cgi.conf >$dn 2>&1
server {
    #version 1
    listen 54000;
    server_name localhost parmanodl.local parmadrive.local parmanode.local ;
    root /var/www/parmanode_cgi;

    location ~ /.*\.sh {
        fastcgi_split_path_info ^(/.*\.sh)(/.*)?$;
        include fastcgi_params;
        fastcgi_pass unix:/var/run/fcgiwrap.socket;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}
EOF

sudo nginx -t >$dn 2>&1      || { [[ $silent != "true" ]] && sww "Something went wrong with the nginx configuration." ; }
sudo systemctl restart nginx || { [[ $silent != "true" ]] && sww "Something went wrong with the nginx service. Proceed with caution." ; }
}