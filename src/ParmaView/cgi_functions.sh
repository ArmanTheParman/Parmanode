function install_cgi {
grep -q "cgi-end" $ic && return 0
install_nginx
install_fcgiwrap
make_cgi_nginx_conf || return 1
sudo mkdir -p $wwwcgidir
sudo mount --bind $pp/parmanode/src/ParmaView/cgi-bin $wwwcgidir || sww "Mounting cgi-bin failed."
}

function install_fcgiwrap {
sudo apt update
sudo apt install -y fcgiwrap
sudo systemctl enable --now fcgiwrap
}

function uninstall_cgi {
sudo rm -rf $cginginx
sudo systemctl restart nginx
sudo apt remove -y fcgiwrap
sudo umount $wwwcgidir
}

function make_cgi_nginx_conf {

if ! [[ $silent == "true" ]] ; then
netstat -tuln 2>$dn | grep -q :54000 && { sww "Port 54000 is already in use. Unexpected. Can't continue, aborting." && return 1 ; }
fi

#SCRIPT_FILENAME neessary for fcgiwrap to know what to execute
#Other variables are for the script

cat <<EOF | sudo tee $cginginx >$dn 2>&1
server {
    #version 1
    listen 58000;
    server_name localhost parmanodl.local parmadrive.local parmanode.local ;
    root $wwwcgidir;

    location ~ /.*\.sh {
        fastcgi_split_path_info ^(/.*\.sh)(/.*)?$;
        include fastcgi_params;
        fastcgi_pass unix:/var/run/fcgiwrap.socket;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }

    location / {
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_pass http://127.0.0.1:58001;
    }
}
EOF

sudo nginx -t >$dn 2>&1      || { [[ $silent != "true" ]] && sww "Something went wrong with the nginx configuration." ; }
sudo systemctl restart nginx || { [[ $silent != "true" ]] && sww "Something went wrong with the nginx service. Proceed with caution." ; }
}