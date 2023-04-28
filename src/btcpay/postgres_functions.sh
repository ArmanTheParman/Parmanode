# createuser postgres function done in dockerfile.

function start_postgres {
docker exec -d -u postgres btcpay /bin/bash -c "/usr/bin/pg_ctlcluster 13 main start" \
|| log "btcpay" "failed to start postgress"
}

function make_postgres_user {

docker exec -d -u postgres btcpay /bin/bash -c "/usr/local/bin/postgres_script.sh" \
|| log "btcpay" "failed to make parman postgres database user"

}

function create_pg_databases {

docker exec -d -u postgres btcpay /bin/bash -c "createdb -O parman btcpayserver && \
                                                createdb -O parman nbxplorer" && \
log "btcpay" "2 databases created" || \
log "btcpay" "2 databases failed to be created" 
}

