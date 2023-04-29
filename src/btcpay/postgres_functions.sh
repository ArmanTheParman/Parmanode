# start postgress, create parman database user with script, create 2 databases.

function startup_postgres {
docker exec -d -u root btcpay /bin/bash -c \
"sed -i 's/md5/trust/g' /etc/postgresql/*/main/pg_hba.conf" # i for in-place, s for substitute, g for global, find 1 replace with stirng 2

docker exec -d -u postgres btcpay /bin/bash -c \
   "/usr/bin/pg_ctlcluster 13 main start" 
   
   "createdb -O postgres btcpayserver ; \
    createdb -O postgres nbxplorer"

docker exec -d -u postgres btcpay /bin/bash -c \
"/usr/local/bin/postgres_script.sh ; \
createdb -O parman btcpayserver ; \
createdb -O parman nbxplorer" 
}
# config file: /etc/postgresql/13/main/pg_hba.conf 

#docker exec -d -u root btcpay /bin/bash -c \
#"echo \"
#local   all             postgres                                peer
#local   all             all                                     peer
#host    all             all             127.0.0.1/32            trust
#host    all             all             ::1/128                 trust
#local   replication     all                                     peer
#host    replication     all             127.0.0.1/32            md5
#host    replication     all             ::1/128                 md5
#host all  postgres  trust\" | tee /etc/postgresql/*/main/pg_hba.conf >/dev/null"