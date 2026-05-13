
function make_mempool_nginx {

install_nginx || sww

cat <<EOF | sudo tee $macprefix/etc/nginx/conf.d/mempool.conf >$dn 2>&1
server {
    listen 8181 ssl;
    ssl_certificate     $hp/mempool/cert.pem;
    ssl_certificate_key $hp/mempool/key.pem;

    location / {
        proxy_pass http://127.0.0.1:8180;
        proxy_http_version 1.1;
        proxy_set_header Host \$host:\$server_port;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Port 8181;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

sudo nginx -t >$dn 2>&1 && sudo systemctl reload nginx >$dn 2>&1
return 0
}