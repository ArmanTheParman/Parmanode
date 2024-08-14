function menu_tor_webserver {

server_onion="$(sudo cat /var/lib/tor/tor-server/hostname)"


while true ; do 
if grep -q "autoindex on" /etc/nginx/conf.d/tor-server.conf ; then status="on" ; else status="off" ; fi
set_terminal ; echo -e "
########################################################################################
        $cyan               Tor Web Server (Darknet Server) Menu $orange
########################################################################################



$green             (info)$orange          Important information

$green             (rt)     $orange       Restart Tor

$green             (sp)         $orange   Set permissions

$green             (list)         $orange List file on the server

$green             (off)     $orange      Turn off file indexing    [ Currently $status ]
            
$green             (on)          $orange  Turn on file indexing     [ Currently $status ]

$green             (rn)$orange            Retart Nginx 

$green             (s)$orange             See Nginx status


$cyan  
Onion address: $bright_blue  ${server_onion}:7001
$cyan
Server location:$bright_blue /tor-server/
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
rn|RN|Rn) sudo systemctl restart nginx.service  ;;

s|S) sudo systemctl status nginx.service ;;

rt|RT|Rt) sudo systemctl restart tor.service ;;

info|Info|INFO) tor_server_info ;;

list)
set_termina_high
echo -e "
########################################################################################

Files in /tor-server



sp|SP|sP)
set_terminal ; echo -e "
Every time you add files to the tor-server directory, you need to make
sure the files have the correct permission settings otherwise they
are not accessible by others connecting to your server.

Hit $green<enter>$orange to continue and set the permissions automatically,
or$red p$orange and$red <enter>$orange to go back."
read choice
if [[ $choice == "p" || $choice == "P" ]] ; then return 1 ; fi

sudo chown -R www-data:www-data /tor-server
sudo shopt -s dotglob ; sudo chmod -R 755 /tor-server/*
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
