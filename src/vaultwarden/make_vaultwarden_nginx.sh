function make_vaultwarden_nginx {

cat <<EOF | sudo tee $macprefix/etc/nginx/conf.d/vaultwarden.conf >$dn 2>&1
server {
    listen 19443 ssl;
    ssl_certificate     $hp/vaultwarden/cert.pem;
    ssl_certificate_key $hp/vaultwarden/key.pem;

    location / {
        proxy_pass http://localhost:19080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
}
