# start postgress, create parman database user with script, create 2 databases.

function startup_postgres {
docker exec -d -u postgres btcpay /bin/bash -c "/usr/bin/pg_ctlcluster 13 main start ; \
/usr/local/bin/postgres_script.sh ; \
createdb -O parman btcpayserver ; \
createdb -O parman nbxplorer" \
|| log "btcpay" "failed to do startup postgress"
}
