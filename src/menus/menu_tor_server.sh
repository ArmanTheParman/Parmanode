function menu_tor_server {

server_onion="$(sudo grep /var/lib/tor/tor-server/hostname)"

while true ; do set_terminal ; echo "
########################################################################################
                                  Tor Server Menu 
########################################################################################

             (rn)            Retart Nginx 

             (s)             See Nginx status

             (rt)            Restart Tor

             (info)          Important information

             (sp)            Set permissions

             (m)             Move files to server directory
            
             (off)           Turn off file indexing
            
             (on)            Turn on file indexing


    Onion address: ${server_onion}:7001

    Server location: /tor-server/

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
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
sudo chown www-data:www-data /tor-server-move
sudo chmod 755 /tor-server-move/*
sudo shopt -s dotglob ; sudo mv -r /tor-server-move/* /tor-server/
;;

off|Off|OFF) index_off ;;

on|ON|On) index_on ;;

*)
invalid
;;

esac
done
}

function tor_server_info {

set_terminal
echo "
########################################################################################
                                Tor Server Information

    The server files are located in /tor-server/ directory. Please do no move this
    directory, the system is specifically configured to serve files from here. Moving
    it will break things.

    To add files to the directory, first copy or move them to /tor-server-move/  
    
    Then come back to the tor-server menu in Parmanode, and select 
    \"move files to server\".  This will move the files and also correct the 
    permissions so they will be accessible.

    The server directory starts empty. You can start by adding a file called 
    index.html which will automatically load when someone browses to your site without
    specifying a file.

    If index.html doesn't exist, and the onion address without a file is accessed in
    a Tor browser, then the contents of the entire directory will be displayed,
    allowing one to click and download. If this behavious is not desirable, turn it 
    off in the Tor-Server menu by selecting \"Turn off file indexing.\"

########################################################################################
"
enter_continue
}
function index_off {

swap_string "/etc/nginx/donf.d/tor-server.conf" "autoindex" "              autoindex off; # autoindex tag"

}

function index_on {

swap_string "/etc/nginx/donf.d/tor-server.conf" "autoindex" "              autoindex on; # autoindex tag"

}
