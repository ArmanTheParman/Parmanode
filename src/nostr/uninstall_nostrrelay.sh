function uninstall_nostrrelay {
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Nostr Relay 
$orange
    Are you sure? 

                    y)    Yes, uninstall

                    n)    Nah, abort
$red
                    rem)  Yes, and remove the data directory too.
$orange


########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

set_terminal

if ! docker ps >/dev/null 2>&1 ; then
announce "docker not running. Aborting."
return 1
fi

double_check_website_not_installed || return 1

docker stop nostrrelay
docker rm nostrrelay

rm -rf $hp/nostrrelay 2>/dev/null

if [[ -e /var/www/website ]] ; then
sudo rm -rf /var/www/website
fi

sudo rm -rf /etc/nginx/conf.d/website* >/dev/null 2>&1
sudo rm -rf /etc/nginx/conf.d/$domain_name.conf >/dev/null 2>&1
sudo rm -rf /etc/letsencrypt/live/$domain_name >/dev/null 2>&1
sudo rm -rf /etc/letsencrypt/live/www.$domain_name >/dev/null 2>&1
sudo systemctl restart nginx >/dev/null 2>&1

nostr_tor_remove
parmanode_conf_remove "domain"
parmanode_conf_remove "www" 
installed_conf_remove "nostrrelay"
success "Nostr Relay has been uninstalled"
}

function double_check_website_not_installed {

if which mariadb >/dev/null || which mysql >/dev/null ; then 
while true ; do
set_terminal ; echo -e "
########################################################################################
$pink$blinkon
       MAKE SURE YOU DON'T HAVE A PARMAWEB WEBSITE INSTALLED OR THIS PROCESS
       MAY DELETE FILES. $blinkoff
$orange       
       PARMANODE DOES NOT ALLOW THE TWO TO BE INSTALLED TOGETHER ANYWAY, BUT IF YOU 
       WERE \"LYING 'N' TRICKIN' THE CODE\", BAD THINGS CAN HAPPEN.


                        c)     continue, it's fine

                        a)     abort

########################################################################################
"
read choice
set_terminal
case $choice in
c) return 0 ;;
a) return 1 ;;
*) invalid ;;
esac
done
fi
}