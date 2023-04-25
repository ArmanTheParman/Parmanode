# createuser postgres function done in dockerfile.

function start_postgres {
/usr/bin/pg_ctlcluster 13 main start
}

function create_pg_databases {

docker exec -d -u postgres btcpay /bin/bash -c "createdb -O parman btcpayserver && \
                                                createdb -O parman nbxplorer" && \
log "btcpay" "2 databases created" || \
log "btcpay" "2 databases failed to be created" 
}