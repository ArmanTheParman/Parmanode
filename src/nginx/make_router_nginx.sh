function make_router_nginx {

file=/etc/nginx/conf.d/router.conf
router_IP=192.168.0.1

#proxy_set_header="proxy_set_header Host localhost;" -- doesn't work for router
proxy_set_header1="proxy_set_header Host $router_IP;"

echo "server {
    listen 11111 ;
    server_name _;

    location / {
        proxy_pass http://$router_IP;
        $proxy_set_header1
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}" | sudo tee $file >$dn 2>&1

sudo systemctl restart nginx

}