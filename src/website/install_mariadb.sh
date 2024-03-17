function install_MariaDB {
if which mariadb >/dev/null 2>&1 ; then return 0 ; fi
clear
echo -e "$green Installing php and MariaDB $orange" ; sleep 1
sudo apt-get -y --fix-broken --no-install-recommends install mariadb-server 
echo -e "$green Enabling autostart on bootup ...$orange" ; sleep 1
sudo systemctl enable mariadb >/dev/null
sudo systemctl start mariadb >/dev/null
}