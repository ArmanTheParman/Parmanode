function make_parmadesk_nginx {

cat <<EOF | sudo tee $macprefix/etc/nginx/conf.d/vnc.conf >$dn 2>&1
server {
    listen 21001 ssl;
    ssl_certificate     $hp/parmadesk/cert.pem;
    ssl_certificate_key $hp/parmadesk/key.pem;

    location /websockify {
        proxy_pass http://localhost:21000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location = / {
        proxy_pass http://localhost:21000/vnc.html;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location / {
        proxy_pass http://localhost:21000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
sudo systemctl restart nginx >$dn 2>&1
}