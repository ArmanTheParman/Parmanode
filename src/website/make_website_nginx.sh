function make_website_nginx {
#Bash variables must be resolved...

#expected variables in session
# www=true/false
# domain=internalIP/externalIP/damain_name

file="/etc/nginx/conf.d/website.conf"
sudo rm -rf $file

if [[ $domain_choice == true ]] ; then
local server_name="    server_name $domain;"
else
unset server_name
fi

cat << EOF | sudo tee -a $file >/dev/null 2>&1
server {

    listen 80;
    $server_name
    root /var/www/website;
    index index.html index.htm index.php;
    client_max_body_size 200M; #default upload size is 1M
    #ssl_certificate /path;
    #ssl_certificate_key /path;
    #include /path;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php-fpm.sock;  # Adjust to match your PHP-FPM socket path
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

return 0
#for later when ssl set up ...
echo "
server {    
    listen 80;
    \$server_name 

    location / {
        return 301 https://\$host\$request_uri;
     }

    # http to https rediretion - redundant because of location / block
     # if (\$host ~* (^parmanode\.com$|^www\.parmanode\.com$) {
     # return 301 https://\$host\$request_uri;
     #}
}
"
}