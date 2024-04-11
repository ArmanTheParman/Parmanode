function make_website_nginx {
# www=true/false
# domain=internalIP/externalIP/damain_name

file="/etc/nginx/conf.d/website.conf"
sudo rm -rf $file

if [[ -n $domain || -n $domain_name ]] ; then

    if [[ $www == true ]] ; then www_name="www.$domain_name"
    local server_name="server_name $domain_name $www_name;"
    fi

    if [[ -n $domain ]] ; then
    local server_name="server_name $domain;"
    fi

else
    #create a placeholder; easy to search and swap line later
    local server_name="#put server___name here when domain name added" 
fi

cat << EOF | sudo tee -a $file >/dev/null 2>&1
server {

    listen 80;
    $server_name
    root /var/www/website;
    index index.html index.htm index.php;
    client_max_body_size 200M; #default upload size is 1M

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php-fpm.sock;  # Adjust to match your PHP-FPM socket path, if needed
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    include fastcgi_params;
    }

    #block access to sensitive files 
    location ~* /\.ht {
        deny all;
    }

    #reduces error messages in logs related to website icon not found
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }
    
    #for webcrawlers
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    #max cache, improves client performance. Search is case insensitive
    location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
        expires max;
        log_not_found off;
    }

    #sets cache expiry to improve performance. case insensitive
    location ~* \.(html|htm)$ {
        expires 30d;
    }

    #deny all hidden files
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
    
    #security measures...
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Frame-Options "SAMEORIGIN";

    # Enable OCSP stapling for improved SSL/TLS performance; only required if SSL on.
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8;

    # Enable HSTS; max age in seconds; only if SSL on.
    add_header Strict-Transport-Security "max-age=315360000; includeSubDomains; preload";
}
EOF

unset domain_name
source $pc
if [[ -n $domain_name ]] ; then
sudo cp $file $file.backup
sudo mv $file /etc/nginx/conf.d/$domain_name.conf
#creates a template without any domain name, and a place holder for server_name...
swap_string "$file.backup" "server_name" "    #put server___name here when domain name added"
fi
}