function whats_running {
local tmp=$(mktemp)

! test -f $p4 && build_config

#    window.apps = { bitcoin:{}, electrs:{}, mempool:{}, lightning:{}, btcpay:{}, nostr:{}, litd:{}, sparrow:{},
#                    electrum:{}, specter:{}, rtl:{}, thunderhub:{}, alby:{}, bitbox:{}, vaultwarden:{}, 
#                    green:{}, docker:{}, lnbits:{} };
isrunning=();

isbitcoinrunning
if [[ $bitcoinrunning == "true" ]] ; then isrunning+=("bitcoin") ; fi
iselectrsrunning
if [[ $electrsrunning == "true" ]] ; then isrunning+=("electrs") ; fi
ismempoolrunning
if [[ $mempoolrunning == "true" ]] ; then isrunning+=("mempool") ; fi
islndrunning
if [[ $lndrunning == "true" ]] ; then isrunning+=("lnd") ; fi
isbtcpayrunning
if [[ $btcpayrunning == "true" ]] ; then isrunning+=("btcpay") ; else echo btcpayrunning ... $btcpayrunning | tee -a $dp/error.log ; fi
isnostrrunning
if [[ $nostrrunning == "true" ]] ; then isrunning+=("nostr") ; fi
isrtlrunning
if [[ $rtlrunning == "true" ]] ; then isrunning+=("rtl") ; fi
isthunderhubrunning
if [[ $thunderhubrunning == "true" ]] ; then isrunning+=("thunderhub") ; fi
isalbyrunning
if [[ $albyrunning == "true" ]] ; then isrunning+=("alby") ; fi
isvaultwardenrunning
if [[ $vaultwardenrunning == "true" ]] ; then isrunning+=("vaultwarden") ; fi
isdockerrunning
if [[ $dockerrunning == "true" ]] ; then isrunning+=("docker") ; fi

arr_json=$(printf '%s\n' "${isrunning[@]}" | jq -R . | jq -s .)

jq --argjson arr "$arr_json" '. + { running: $arr }' "$p4" > "$tmp" && mv "$tmp" "$p4"
}