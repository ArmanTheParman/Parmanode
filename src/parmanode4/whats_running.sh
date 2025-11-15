function whats_running {

! test -f $p4 && build_config

#    window.apps = { bitcoin:{}, electrs:{}, mempool:{}, lightning:{}, btcpay:{}, nostr:{}, litd:{}, sparrow:{},
#                    electrum:{}, specter:{}, rtl:{}, thunderhub:{}, alby:{}, bitbox:{}, vaultwarden:{}, 
#                    green:{}, docker:{}, lnbits:{} };

isbitcoinrunning
if [[ $bitcoinrunning == "true" ]] ; then echo "bitcoin is running" ; else echo "bitcoin is NOT running" ; fi
iselectrsrunning
if [[ $electrsrunning == "true" ]] ; then echo "electrs is running" ; else echo "electrs is NOT running" ; fi
ismempoolrunning
if [[ $mempoolrunning == "true" ]] ; then echo "mempool is running" ; else echo "mempool is NOT running" ; fi
islndrunning
if [[ $lndrunning == "true" ]] ; then echo "lnd is running" ; else echo "lnd is NOT running" ; fi
isbtcpayrunning
if [[ $btcpayrunning == "true" ]] ; then echo "btcpay is running" ; else echo "btcpay is NOT running" ; fi
isnostrrunning
if [[ $nostrrunning == "true" ]] ; then echo "nostr is running" ; else echo "nostr is NOT running" ; fi
isrtlrunning
if [[ $rtlrunning == "true" ]] ; then echo "rtl is running" ; else echo "rtl is NOT running" ; fi
isthunderhubrunning
if [[ $thunderhubrunning == "true" ]] ; then echo "thunderhub is running" ; else echo "thunderhub is NOT running" ; fi
isalbyrunning
if [[ $albyrunning == "true" ]] ; then echo "alby is running" ; else echo "alby is NOT running" ; fi
isvaultwardenrunning
if [[ $vaultwardenrunning == "true" ]] ; then echo "vaultwarden is running" ; else echo "vaultwarden is NOT running" ; fi
isdockerrunning
if [[ $dockerrunning == "true" ]] ; then echo "docker is running" ; else echo "docker is NOT running" ; fi
}