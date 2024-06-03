function make_router_nginx {

#Attempted to use this function to make a reverse proxy from my computer to my router.
#then I set up a tor service to localhost:11111 to access the router from home.
#a tor service alone didn't work, this method also failed.

file=/etc/nginx/conf.d/router.conf
router_IP=192.168.0.1

#proxy_set_header="proxy_set_header Host localhost;"
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
}" | sudo tee $file >/dev/null 2>&1

sudo systemctl restart nginx

}