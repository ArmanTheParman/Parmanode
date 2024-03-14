
function phpmyadmin {

#redundant...
#sudo apt-get install phpmyadmin -y

# Goes in nginx server conf ...

install_nginx #aborts if already installed.

echo "
server {
    listen 80;
    server_name your_server_domain_or_IP;  # Replace with your domain name or IP address
    
    location /phpmyadmin {
        root /usr/share/;
        index index.php index.html index.htm;

        location ~ ^/phpmyadmin/(.+\.php)$ {
            try_files $uri =404;
            root /usr/share/;
            fastcgi_pass unix:/var/run/php/php7.x-fpm.sock; # Adjust the PHP version
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include /etc/nginx/fastcgi_params;
        }

        location ~* ^/phpmyadmin/(.+\.php)$ {
            try_files $uri =404;
            fastcgi_pass unix:/var/run/php/php7.x-fpm.sock; # Adjust based on your PHP version
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_index index.php;
        }

        location ~* ^/phpmyadmin/(.+\.(?:css|js|jpg|jpeg|gif|png|ico|svg|woff|woff2|ttf))$ {
            root /usr/share/;
        }
    }

    # Deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    location ~ /\.ht {
        deny all;
    }
}
          include /etc/nginx/fastcgi_params;
}
" | sudo tee /etc/nginx/conf.d    

sudo systemctl restart nginx
#Once everything is set up, you can access phpMyAdmin through your web browser by navigating to http://your_server_ip/phpmyadmin.

}