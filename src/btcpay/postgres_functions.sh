# start postgress, create parman database user with script, create 2 databases.

function startup_postgres {
docker exec -d -u postgres btcpay /bin/bash -c \
   "/usr/bin/pg_ctlcluster 13 main start" 
   
docker exec -d -u postgres btcpay /bin/bash -c \
   "createdb -O postgres btcpayserver ; \
    createdb -O postgres nbxplorer"

docker exec -d -u root btcpay /bin/bash -c \
"echo \"host all  postgres  172.17.0.1/32 trust\" | tee -a /etc/postgresql/*/main/pg_hba.conf" 
}

# /usr/local/bin/postgres_script.sh ; \
#createdb -O parman btcpayserver ; \
#createdb -O parman nbxplorer" \

# config file: /etc/postgresql/13/main/pg_hba.conf 
