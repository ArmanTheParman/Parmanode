#Bash variables must be resolved...

local site_name="_"
local site_1="website1"
local port_1="8001"

server {

    listen $port_1;
    server_name $site_name;
    root $hp/wordpress/$site_1;
    index index.html index.htm index.php;
    #client_max_body_size 200M; #default upload size is 1M
    #ssl_certificate /path;
    #ssl_certificate_key /path;
    #include /path;


    location / {
        try_files $uri $uri/ /index.php?$args;
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

server {    
    listen 80;
    server_name www.parmanode.com parmanode.com;

    location / {
        return 301 https://$host$request_uri;
     }

    # http to https rediretion - redundant because of location / block
     # if ($host ~* (^parmanode\.com$|^www\.parmanode\.com$) {
     # return 301 https://$host$request_uri;
     #}
}