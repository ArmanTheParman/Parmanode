function download_wordpress { 
debug "website variable is... $website"
cd /var/www/$website/ >/dev/null 2>&1
sudo curl -LO https://wordpress.org/latest.zip
echo -e "$green Unzipping wordpress download...$orange" ; sleep 1
sudo unzip *.zip 
cd /var/www/$website/wordpress
sudo mv * .. >/dev/null 2>&1
cd 
sudo rm -rf /var/www/$website/latest.zip
debug "wordpress downloaded and extracted"
}