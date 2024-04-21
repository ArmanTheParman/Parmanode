function website_dependencies {
if ! which unzip >/dev/null 2>&1 ; then the sudo apt install unzip -y ; fi
install_nginx
install_PHP 
install_expect
install_certbot
install_imagick #needed to edit icons in wordpress
install_MariaDB
}

function install_certbot {
sudo apt-get -y --fix-broken --no-install-recommends install certbot python3-certbot-nginx -y
}

function install_expect {
sudo apt-get -y --fix-broken --no-install-recommends install expect
}

function install_imagick {
# Needed othewise wordpress can't crop images, eg when making icons
sudo apt-get -y --fix-broken --no-install-recommends install php-imagick imagemagick
}
