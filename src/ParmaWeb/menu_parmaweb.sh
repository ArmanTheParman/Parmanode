function menu_parmaweb {
if ! grep -q "website-end" $ic ; then return 0 ; fi
IP_address get #fetches external_IP variable without printed menu
while true ; do
unset website_ssl website_tor ONION_ADDR_WEBSITE W_tor W_tor_logic domain add_domain_name_option domain_name domain_name_text web_ssl_status_print
source $pc >$dn 2>&1

#SSL status
if [[ $website_ssl == "true" ]] ; then
    web_ssl_status_print="${green}ON$blue"
    website_ssl_port="443"
    http=https
else
    web_ssl_status_print="${red}OFF$blue"
    http=http
fi

#Tor status
if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then
    if sudo cat /etc/tor/torrc | grep HiddenServiceDir | grep -q "website" >$dn 2>&1 ; then

        if sudo test -d /var/lib/tor/website-service && \
        sudo test -f /var/lib/tor/website-service/hostname >$dn 2>&1 ; then
        W_tor="${green}ON${blue}"
        W_tor_logic=on
        else 
        W_tor="${red}OFF${blue}"
        W_tor_logic=off
        fi

        if grep -q "website_tor=true" $pc ; then 
        get_onion_address_variable "website" 
        fi
    else
        W_tor="${red}OFF${blue}"
        W_tor_logic=off
    fi
fi

if [[ -n $domain_name ]] ; then
domain_name_text="$orange
        Domain Name:             $orang $domain_name$blue
"
else
domain_name=$domain
fi

if [[ -n $ONION_ADDR_WEBSITE ]] ; then
tor_menu="        $orange$ONION_ADDR_WEBSITE $blue
"
else
unset tor_menu
fi
debug "pause before set terminal"
set_terminal 48 88 ; echo -ne "$blue
########################################################################################$orange

                                  WORDPRESS WEBSITE $blue

########################################################################################
        $domain_name_text
$tor_menu                      

$yellow        To initialise:       $blue     $http://$domain_name/myphpadmin
$yellow        Database's name:     $blue     website (or website1, website2 etc)
$yellow        Database username:   $blue     parmanode
$yellow        Wordpress login:     $blue     $http://$domain_name/wp-admin
$yellow        Info Page:           $blue     $http://$domain_name/info.php

----------------------------------------------------------------------------------------

$yellow        Website data location: $blue   /var/www/website
$yellow        Data file permissions: $blue   user=www-data ; group=www-data
$yellow        Nginx configuration:   $blue   /etc/nginx/conf.d/website.conf

$yellow        TCP Port (http):          ${green}80
$yellow        SSL port (https):         ${green}$website_ssl_port 
$yellow        Tor Status:               $W_tor                     
$blue
----------------------------------------------------------------------------------------
                                                                                $cyan
                   i)            $blue Educational info ...                            $cyan
                 max)            $blue How up increase upload file size ...            $cyan
                 dom)            $blue Add/Change domain name                          $cyan
                pass)            $blue Reset password                                  $cyan
                  dd)            $blue Delete database and create new                  $cyan
                  bk)            $blue Back up database                                $cyan   
                  rs)            $blue Restore backed up database                      $cyan   
                 tor)            $blue Tor enable/disable      $W_tor                  $cyan
                 ssl)            $blue SSL enable/disable      $web_ssl_status_print   $cyan
                rphp)            $blue Restart php (troubleshoot)$cyan
                nlog)            $blue Viw nginx error log$cyan                        
$red
                next)             NEXT PAGE...
$blue
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal 45 88
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;

i)
website_info
;;

open)
port_instructions
;;

tor)
if [[ $W_tor_logic == on ]] ; then 
website_tor_remove
else
website_tor_add
fi
;;

dom)
website_domain
;;

ssl)
if [[ $website_ssl == "true" ]] ; then
    remove_ssl_website 
else
    if [[ -z $domain_name ]] ; then
    announce "Please add a domain name first." 
    continue
    fi

    website_ssl_on
fi
;;

max)
max_upload_file_size_info
;;

dd)
delete_website_database || return 1
success "Database deleted"
create_website_database || return 1
success "Database created"
;;

bk)
backup_website_database || return 1 
success_blue "The database file should now be at$orange $HOME/Desktop/website_database.sql"
;;

rs)
restore_website_database || return 1 
success "Database restored"
;;
pass)
wp_password_reset
;;
rphp)
sudo systemctl restart php*fpm
;;
nlog)
sudo less /var/log/nginx/error.log
;;
next)
menu_parmaweb2
;;
"")
continue ;;
*)
invalid ;;
esac
done
}


function wp_password_reset {

announce "The database username and password (in parmanode.conf) is needed to
    change the Wordpress login password."

echo -e "$blue
    Please enter the database username (default is parmanode)
    "
read databaseusername
echo -e "$blue
    Please enter the database name (probably website, or website2, or website3 etc)
    "
read databasename
echo -e "$blue
    Please enter your database password next (in parmanode.conf)
    You won't see keystrokes. 
    "
read -s databasepassword

wpuser=$(mysql -u $databaseusername -p"$databasepassword" -e "
USE $databasename;
SELECT ID, user_login FROM wp_users;"  | tail -n1 | awk '{print $2'} | xargs )

echo -e "${blue}Now please enter a new password you'd like for user:$orange $wpuser$blue
    You won't see your keystrokes on screen, and you will not be asked
    to confirm your password.
    
    If there was an erro above, you should hit x to abort."
read -s newpassword
case $newpassword in x) return 1 ;; esac

# echo -e "${blue}Now your database password again (the one stored in parmanode.conf)
# ...
# "
mysql -u $databaseusername -p"$databasepassword" -e "USE $databasename;
UPDATE wp_users SET user_pass = MD5('$newpassword') WHERE user_login = '$wpuser';" || { enter_continue "problem" ; return 1 ; }
bluesuccesscolour="true"
success "Password reset"
}

function menu_parmaweb2 {
while true ; do
set_terminal 38 88 ; echo -ne "$blue
########################################################################################$orange

                            WORDPRESS WEBSITE (PAGE 2)$blue

########################################################################################
        $domain_name_text
$tor_menu                      

$yellow        TCP Port (http):          ${green}80
$yellow        SSL port (https):         ${green}$website_ssl_port 
$yellow        Tor Status:               $W_tor                     
$blue
----------------------------------------------------------------------------------------
                                                                               $cyan
                 cdr)            $blue Certbot Let's Encrypt Renewal Dry Run   $cyan
                 cbt)            $blue Check Certbot renewals are running

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal 45 88
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;

cdr)
clear
sudo certbot renew --dry-run
enter_continue
return 0
;;
cbt)
clear
sudo systemctl list-timers | grep certbot
enter_continue
return 0
;;
"")
continue ;;
*)
invalid ;;
esac
done
}