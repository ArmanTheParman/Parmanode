function install_phpmyadmin {
# final destination of phpmyadmin:
# ~/parmanode/phpmyadmin/

rm -rf $hp/phpmyadmintemp 2>/dev/null
mkdir $hp/phpmyadmintemp && cd $hp/phpmyadmintemp 
curl -LO https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
unzip *zip && rm *zip
mv php* phpmyadmin

rm -rf $hp/phpmyadmin 2>/dev/null
mv phpmyadmin ..

log "wordpress" "phpmyadmin downloaded and extracted, $hp/phpmyadmin"
return 0
}