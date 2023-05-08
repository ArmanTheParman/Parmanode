function stop_bitcoind_docker {

docker exec -itu parman btcpay /home/parman/parmanode/bitcoin/bin/bitcoin-cli stop || return 1


}
