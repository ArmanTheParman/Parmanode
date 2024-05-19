function menu_nginx {
while true ; do
set_terminal ; echo -e "
########################################################################################$cyan
                                    Nginx Menu            $orange                   
########################################################################################

                  s)             Start

                  stop)          Stop

                  r)             Restart

                  conf)          Edit nginx.conf

                  st)            Edit stream.conf
                  
                  cd)            Edit files in conf.d

                  t)             Test nginx configuration (nginx -t)

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;;

s) 
sudo systemctl start nginx
;;

stop)
sudo systemctl stop nginx
;;

r)
sudo systemctl restart nginx
;;

conf)
set_terminal ; echo -e "n for nano editor, v for vim, <enter> alone to go back" ; read editor 

    case $editor in
    "") continue ;;
    n) sudo nano /etc/nginx/nginx.conf ;;
    v) sudo vim /etc/nginx/nginx.conf ;;
    esac
;;

st)
set_terminal ; echo -e "n for nano editor, v for vim, <enter> alone to go back" ; read editor 
    case $editor in
    "") continue ;;
    n) sudo nano /etc/nginx/stream.conf ;;
    v) sudo vim /etc/nginx/stream.conf ;;
    esac
;;

cd)
set_terminal ; cd /etc/nginx/conf.d ; ls ; echo -e "
    Which file would you like to edit? Type the file name in full, then <enter>"
    read filename
set_terminal ; echo -e "n for nano editor, v for vim, <enter> alone to go back" ; read editor 
    case $editor in
    "") continue ;;
    n) sudo nano /etc/nginx/conf.d/$filename ;;
    v) sudo vim /etc/nginx/conf.d/$filename ;;
    esac
;;

t)
set_terminal ; sudo nginx -t
enter_continue
;;

*)
invalid
;;
esac
done

}