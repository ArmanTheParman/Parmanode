function menu_tor_server {

server_onion="$(sudo cat /var/lib/tor/tor-server/hostname)"


while true ; do 
if grep -q "autoindex on" /etc/nginx/conf.d/tor-server.conf ; then status="on" ; else status="off" ; fi
set_terminal ; echo -e "
########################################################################################
        $cyan                 Tor Server (Darknet Server) Menu $orange
########################################################################################


             (info)          Important information

             (rn)            Retart Nginx 

             (s)             See Nginx status

             (rt)            Restart Tor

             (sp)            Set permissions

             (m)             Move files to server directory
            
             (off)           Turn off file indexing    [ Currently $status ]
            
             (on)            Turn on file indexing     [ Currently $status ]


  Onion address: ${server_onion}:7001

  Server location: /tor-server/


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

rn|RN|Rn) sudo systemctl restart nginx.service  ;;

s|S) sudo systemctl status nginx.service ;;

rt|RT|Rt) sudo systemctl restart tor.service ;;

info|Info|INFO) tor_server_info ;;

sp|SP|sP)
set_terminal ; echo "
This will adjust the permissions for all files in /tor-server/ so that they are 
accessible. Hit <enter> to continue, or p and <enter> to go back."
read choice
if [[ $choice == "p" || $choice == "P" ]] ; then return 1 ; fi

sudo chown -R www-data:www-data /tor-server
sudo shopt -s dotglob ; sudo chmod -R 755 /tor-server/*
;;

m|M)
sudo chown -R www-data:www-data /tor-server-move
sudo chmod -R 755 /tor-server-move/*
sudo shopt -s dotglob ; sudo mv /tor-server-move/* /tor-server/
;;

off|Off|OFF) 
index_off ;;

on|ON|On) 
index_on ;;

*)
invalid
;;

esac
done
}

function index_off {

swap_string "/etc/nginx/conf.d/tor-server.conf" "autoindex" "              # autoindex off"
sudo systemctl restart nginx

}

function index_on {

swap_string "/etc/nginx/conf.d/tor-server.conf" "autoindex" "              autoindex on; # autoindex tag"
sudo systemctl restart nginx

}
