function make_vnc_nginx {

cat <<EOF | sudo tee $macprefix/etc/nginx/conf.d/vnc.conf >$dn 2>&1
server {
    listen 21001 ssl;
    ssl_certificate     $hp/vnc/cert.pem;
    ssl_certificate_key $hp/vnc/key.pem;

    location / {
        proxy_pass http://localhost:21000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
}