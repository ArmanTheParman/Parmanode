function make_router_nginx {

#use this function to make a reverse proxy from your computer to your router.
#change the IP of the router if needed.
#then set up a tor service to localhost:11111 to access your router from home.
#a tor service alone won't work, I've tried.

file=/etc/nginx/conf.d/router.conf
router_IP=192.168.0.1

echo "server {
    listen 11111 ;
    server_name _;

    location / {
        proxy_pass https://$router_IP;
        proxy_set_header Host localhost;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}" | sudo tee $file >/dev/null 2>&1

sudo systemctl restart nginx

}