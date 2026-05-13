
function make_mempool_nginx {

install_nginx || sww

cat <<EOF | sudo tee $macprefix/etc/nginx/conf.d/mempool.conf >$dn 2>&1
server {
    listen 8181 ssl;
    ssl_certificate     $hp/mempool/cert.pem;
    ssl_certificate_key $hp/mempool/key.pem;

    location / {
        proxy_pass http://localhost:8180;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

sudo nginx -t >$dn 2>&1 && sudo systemctl reload nginx >$dn 2>&1
return 0
}
