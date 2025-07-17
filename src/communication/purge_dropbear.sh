function purge_dropbear {
sudo apt purge --autoremove dropbear dropbear-bin dropbear-run dropbear-initramfs -y
echo "Purging dropbear packages..."
sudo rm -rf /etc/dropbear
sudo rm -f /etc/init.d/dropbear
sudo find / -type f -name '*dropbear*' -exec rm -f {} + 2>$dn
sudo find / -type d -name '*dropbear*' -exec rm -rf {} + 2>$dn
sudo dpkg --purge $(dpkg -l | awk '/^rc/ && /dropbear/ {print $2}') 2>$dn
success_blue "Dropbear packages and configuration files have been purged."
}