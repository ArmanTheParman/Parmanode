function menu_tor_webserver {
if ! grep -q "tor-server-end" $ic ; then return 0 ; fi
server_onion="$(sudo cat /var/lib/tor/tor-server/hostname)"


while true ; do 
if grep -q "autoindex on" /etc/nginx/conf.d/tor-server.conf ; then status="on" ; else status="off" ; fi
set_terminal ; echo -e "$blue
########################################################################################
        $orange               Tor Web Server (Darknet Server) Menu $blue
########################################################################################



$orange             (info)$blue          Important information

$orange             (rt)     $blue       Restart Tor

$orange             (sp)         $blue   Set permissions

$orange             (list)         $blue List file on the server

$orange             (off)     $blue      Turn off file indexing    [ Currently $status ]
            
$orange             (on)          $blue  Turn on file indexing     [ Currently $status ]

$orange             (rn)$blue            Retart Nginx 

$orange             (s)$blue             See Nginx status


$orange  
Onion address: $bright_blue  ${server_onion}:7001
$orange
Server location:$bright_blue /tor-server/
$blue

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 

rn|RN|Rn) sudo systemctl restart nginx.service  ;;

s|S) sudo systemctl status nginx.service ;;

rt|RT|Rt) sudo systemctl restart tor.service ;;

info|Info|INFO) tor_server_info ;;

list)
set_terminal_high
echo -e "$blue
########################################################################################

    Files in /tor-server: $blue
$orange
$(sudo ls /tor-server)
$blue
########################################################################################
"
enter_continue ; jump $enter_cont
;;


sp|SP|sP)
set_terminal ; echo -e "
Every time you add files to the tor-server directory, you need to make
sure the files have the correct permission settings otherwise they
are not accessible by others connecting to your server.

Hit $orange<enter>$blue to continue and set the permissions automatically,
or$red p$blue and$red <enter>$blue to go back."
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
ifile="/etc/nginx/conf.d/tor-server.conf"
sudo gsed -i "/autoindex/c\              # autoindex off" $ifile
sudo systemctl restart nginx
}

function index_on {
ifile="/etc/nginx/conf.d/tor-server.conf"
sudo gsed -i "/autoindex/c\              autoindex on; # autoindex tag" $ifile
sudo systemctl restart nginx
}
