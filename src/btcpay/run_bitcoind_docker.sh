function run_bitcoind_docker {

docker exec -itu parman btcpay /home/parman/parmanode/bitcoin/bin/bitcoind || return 1

return 0

}
