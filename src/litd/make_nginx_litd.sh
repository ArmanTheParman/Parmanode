function make_nginx_litd {

file=/etc/nginx/conf.d/litd.conf

echo "server {
    listen 8033 ssl;
    server_name _;

    ssl_certificate $HOME/.lit/tls.cert;
    ssl_certificate_key $HOME/.lit/tls.key;

    location / {
        proxy_pass https://localhost:8443;
        proxy_set_header Host localhost;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}" | sudo tee $file >/dev/null 2>&1


}