function run_bitcoind_docker {

doecker exec -itu parman btcpay /home/parman/parmanode/bitcoin/bin/bitcoind || return 1

return 0

}
