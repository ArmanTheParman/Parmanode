# start postgress, create parman database user with script, create 2 databases.

function startup_postgres {
docker exec -d -u postgres btcpay /bin/bash -c "/usr/bin/pg_ctlcluster 13 main start ; \
createdb -O postgres btcpayserver ; \
createdb -O postgres nbxplorer" ; \
echo "local   nbxplorer  postgres  trust" | sudo tee -a /etc/postgresql*/*/main/pg_hba.conf ; \ 
echo "local   btcpayserver postgres  trust" | sudo tee -a /etc/postgresql*/*/main/pg_hba.conf ; \
|| log "btcpay" "failed to do startup postgress"
}

# /usr/local/bin/postgres_script.sh ; \
#createdb -O parman btcpayserver ; \
#createdb -O parman nbxplorer" \

# config file: /etc/postgresql/13/main/pg_hba.conf 
