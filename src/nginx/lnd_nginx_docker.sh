function lnd_nginx_docker {

return 0

######################################
#### during docker build process #####
######################################
# nginx installed 
# rm /etc/nginx/sites-available/*
# rm /etc/nginx/sites-enabled/*
######################################
#streamfile="/etc/nginx/stream.conf"
#nginx_conf="/etc/nginx/nginx.conf"



########################################################################################

#this is added at the end of the file, not in any particular block
echo "include stream.conf;" | sudo tee -a $nginx_conf

}