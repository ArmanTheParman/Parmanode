function menu_nginx {
while true ; do
if sudo systemctl status nginx >$dn 2>&1 ; then
nginxrunning="${green}RUNNING$orange"
else
nginxrunning="${red}NOT RUNNING$orange"
fi

set_terminal ; echo -e "
########################################################################################$cyan
                                    Nginx Menu            $orange                   
########################################################################################
$nginxrunning
$green
                  s)$orange             Start
$red
                  stop)$orange          Stop
$cyan
                  r)$orange             Restart
$cyan
                  conf)$orange          Edit nginx.conf (confv for vim)
$cyan
                  cd)$orange            Edit files in conf.d
$cyan
                  t)$orange             Test nginx configuration (nginx -t)

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
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
sudo nano /etc/nginx/nginx.conf 
;;

confv) 
vim_warning ; sudo vim /etc/nginx/nginx.conf 
;;

cd)
set_terminal ; cd /etc/nginx/conf.d ; ls ; echo -e "
    Which file would you like to edit? Type the file name in full, then <enter>"
    read filename
set_terminal ; echo -e "${green}n$orange for nano editor,$green v$orange for vim, <enter> alone to go back" ; read editor     case $editor in
    case $editor in
    "") continue ;;
    n) sudo nano /etc/nginx/conf.d/$filename ;;
    v) vim_warning ; sudo vim /etc/nginx/conf.d/$filename ;;
    esac
;;

t)
set_terminal ; sudo nginx -t
enter_continue
;;
"")
continue ;;
*)
invalid
;;
esac
done

}