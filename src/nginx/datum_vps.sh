function datum_vps {
    setup_autossh_vps
    datum_vps_nginx
    success "Datum VPS is set up. Data will stream from the VPS coming in at port 23334
    to port 23335. The latter port will be sent through a tunnel to your other computer,
    but only if the tunnel service is set up there."
}

function datum_vps_nginx {

install_nginx 

if grep -r "^stream {" /etc/nginx ; then 
    sww "There seems to already be a stream directive in Nginx,
    so Parmanode can predict how to safely modify config files to make a datum 
    stream config." && return 1
fi

sudo mkdir -p /etc/nginx/stream 
cat <<EOF | tee /etc/nginx/stream/datum.conf >$dn 2>&1
stream {
    server {
        listen 23334;
        proxy_pass 127.0.0.1:23335;
    }
}
EOF

if ! grep -E "include /etc/nginx/stream/datum.conf;" ; then
    echo "include /etc/nginx/stream/datum.conf;" | sudo tee -a $nginxconf >$dn 2>&1
fi

restart_nginx
clear
enter_continue "Nginx config for Datum completed"
}


function setup_autossh_vps {

sudo apt-get update -y
sudo apt-get install autossh -y

file="/etc/ssh/sshd_config"
if ! grep -E "^PubkeyAuthentication yes" $file ; then
    echo "PubkeyAuthentication yes" | tee -a $file >$dn
fi

if ! grep -E "^GatewayPorts yes" $file ; then
    echo "GatewayPorts yes" | tee -a $file >$dn
fi

if ! grep -E "^AllowTcpForwarding yes" $file ; then
    echo "AllowTcpForwarding yes" | tee -a $file >$dn
fi

if ! grep -E "^ClientAliveInterval 60" $file ; then
    echo "ClientAliveInterval 60" | tee -a $file >$dn
fi

sudo systemctl restart sshd
clear
enter_continue "AutoSSH setup on VPS"
}


