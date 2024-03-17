function install_PHP {
set_terminal ; echo -e "
########################################################################################
    Parmanode will install phpMyAdmin, and some other php tools. You might be asked
    during the installation about auto configuration for a web server, with the 
    choices:

        Apache2
        Lighttpd
$cyan
    It won't matter which you choose$orange, Parmanode will configure phpMyAdmin with Nginx
    instead. Just randomly choose one and carry on.

    You will also be shown a second screen which offers to configure a database.
$pink
    Decline this option by choosing <No> !
$orange
########################################################################################
"
enter_continue
sudo apt-get -y --fix-broken --no-install-recommends install php-cli phpmyadmin php-fpm php-mysql php-mbstring php-zip php-gd php-json \
php-curl php-xml php-intl php-bcmath php-imagick || debug "failed apt-get install php command"
}