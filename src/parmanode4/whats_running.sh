function whats_running {

! test -f $p4 && build_config

#    window.apps = { bitcoin:{}, electrs:{}, mempool:{}, lightning:{}, btcpay:{}, nostr:{}, litd:{}, sparrow:{},
#                    electrum:{}, specter:{}, rtl:{}, thunderhub:{}, alby:{}, bitbox:{}, vaultwarden:{}, 
#                    green:{}, docker:{}, lnbits:{} };

isbitcoinrunning
iselectrsrunning
ismempoolrunning
islndrunning
isbtcpayrunning
isnostrrunning
isrtlrunning
isthunderhubrunning
isalbyrunning
isvaultwardenrunning
isdockerrunning

[[ $bitcoinrunning == "true" ]] && echo "bitcoin is running"


}