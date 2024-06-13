function start_postgres_btcpay_indocker {
docker exec -d -u root btcpay /bin/bash -c "service postgresql start" ||  announce "failed to start postgres database in docker"
}
