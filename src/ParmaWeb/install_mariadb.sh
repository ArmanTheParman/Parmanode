function install_MariaDB {
sudo apt-get -y --fix-broken --no-install-recommends install mariadb-server 
echo -e "$green Enabling autostart on bootup ...$orange" ; sleep 1
sudo systemctl enable mariadb >$dn
sudo systemctl start mariadb >$dn
}