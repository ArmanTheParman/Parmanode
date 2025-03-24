function menu_parmacloud {
if ! grep -q "parmacloud-end" $ic ; then return 0 ; fi

while true ; do 

if ! grep -q parmacloud_domain $pc ; then
parmanode_conf_add "parmacloud_domain=yourchoice.parmacloud.com"
fi

unset nextcloud_running
source $pc
if  [[ $(podman ps | grep nextcloud | wc -l) -gt 1 ]] ; then
nextcloud_running="${green}RUNNING$orange"
elif podman ps | grep -q nextcloud ; then
nextcloud_running="${red}PARTIALLY RUNNING - you might need to access the
                                       initial setup link to get it going, see below$orange
                                       Then start the containers from the browser"
else
nextcloud_running="${red}NOT RUNNING$orange"
fi

if ! { sudo test -e /etc/podman/daemon.json && \
       grep -q "data-root" /etc/podman/daemon.json && \
       vld=$(sudo cat /etc/podman/daemon.json 2>/dev/null | jq -r '."data-root"') 
     } ; then 

    vld=/var/lib/podman
fi


set_terminal 38 96 ; echo -en "$blue
################################################################################################$orange
                                   PARMACLOUD - NextCloud $blue
################################################################################################

    NextCloud is:    $nextcloud_running

$orange
                      pass)$blue          Show setup passphrase
$orange
                      reset)$blue         Reset a user account password
$green
                      start)$blue         Start NextCloud Docker container
$red
                      stop)$blue          Stop NextCloud Docker container
$orange
                      refresh)$blue       Run if you manually modified the podman volume 
$orange
                      rerun)$blue         Destroy container and rerun (no data loss, be cool) 
$orange
                      data)$blue          Information about data storage and backups


    ACCESS FOR INITIAL SETUP (and when restarting stopped containers): $green
          https://$IP:8020    $blue
    
    REGULAR ACCESS: $pink
          https://$parmacloud_domain $orange   mod)$blue   Modify domain

    DEFAULT DATA DIRECTORY: $pink
          $vld/volumes/nextcloud_aio_nextcloud_data/_data/__NEXTCLOUD_username__
$blue
################################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 

pass)
set_terminal
sudo podman exec nextcloud-aio-mastercontainer grep password /mnt/podman-aio-config/data/configuration.json || \
{ announce "No password found. It is created only once you access the server setup page
    the very first time around." ; continue ; }

enter_continue
;;

start)
podman start nextcloud-aio-mastercontainer || enter_continue
;;
stop)
podman stop $(podman ps --format "{{.Names}}" | grep nextcloud)
;;

data)
nextcloud_storage_info
;;

reset)
nextcloud_password_reset
;;

mod)
parmacloud_modify_domain
;;
refresh)
refresh_parmacloud
;;

rerun)
podman stop $(podman ps --format "{{.Names}}" | grep nextcloud) || enter_continue
podman rm $(podman ps -a --format "{{.Names}}" | grep nextcloud) || enter_continue
parmacloud_run
;;
"")
continue ;;
*)
invalid
;;

esac
done
}


function nextcloud_password_reset {
set_terminal ; echo -e "$blue
########################################################################################

    Please type the username for which you'd like to reset the password, eg 'admin'

########################################################################################
$orange"
read user
podman exec -it nextcloud-aio-nextcloud bash -c "sudo -u www-data php /var/www/html/occ user:resetpassword $user" || { enter_continue "some error" ; return 1 ; }
success_blue "Password change done." 
}

function parmacloud_modify_domain {
announce_blue "This is only to make the menu screen appear accurate.
    Changeing domain routing is done outsite of Parmanode.
    Please$orange type in your preferred domain$blue, eg mycloudserver.com,
    do not enter the https prefix. Or hit$cyan <enter>$blue alone to abort."

case $enter_cont in
q|Q) exit ;; ""|p|P) return 1 ;;
*)
yesorno_blue "Use $orange$enter_cont$blue to print on your ParmaCloud menu?" || return 1
parmanode_conf_remove "parmacloud_domain="
parmanode_conf_add "parmacloud_domain=$enter_cont"
;;
esac

}

function refresh_parmacloud {

announce "If you modify files in the podman volume directory, it's not going to show up
    in the NextCloud web interface unless you make sure any new files/directories are 
    owned by www-data and you also have to run a database refresh command."

jump $enter_cont
case $enter_cont in
q|Q) exit ;; p) return ;; m|M) back2main ;;
"")
clear
podman exec -u www-data nextcloud-aio-nextcloud php occ files:scan --all
enter_continue "Database refershed"
;;
esac
}