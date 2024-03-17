function download_wordpress { 
cd /var/www/website/ >/dev/null 2>&1
curl -LO https://wordpress.org/latest.zip
echo -e "$green Unzipping wordpress download...$orange" ; sleep 1
unzip *.zip && rm -rf *.zip
cd /var/www/website/wordpress
mv * .. >/dev/null 2>&1
cd ..
rm -rf wordpress latest.zip
debug "wordpress downloaded and extracted"
}