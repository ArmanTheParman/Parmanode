function lnd_enable_tor {
set_terminal
echo -e "
########################################################################################

   Please not that whether LND is running by Tor-Only or as a hybrid Tor/Clearnet
   ultimately is determined by the address types you see at the bottom of the LND
   menu.

   If there is a Tor address (onion) only, then LND is running Tor-only. If a clearnet
   address only, then it's running clearnet only; and obviously if you see both, it
   is running hybrid.
$cyan
   Please note that LND will only truly be "Tor-Only" if you also remove any clearnet
   IP addresses from the lnd.conf file yourself.
$orange
   Please also note that the Tor setting for Bitcoin must match the LND settings or
   else LND won't start/run.

   Parmanode is not yet smart enough to do all of the above for you, but it will be 
   one day.

########################################################################################
"
enter_continue

local file=$HOME/.lnd/lnd.conf

if ! which tor >/dev/null ; then install_tor ; fi

cp $file ${dp}/backup_files/lnd.conf$(date | awk '{print $1$2$3}')-presableTor >/dev/null 2>&1

#delete first to avoid duplication
while grep -q "Added by Parmanode (start)" < $file ; do
sed -i '/Added by Parmanode (start)/,/Added by Parmanode (end)/d' $file >/dev/null 2>&1
count=$((1 + count))
if [[ $count -gt 3 ]] ; then announce "loop error when editing $file. Aborting." ; return 1 ; fi
done

echo "
; Added by Parmanode (start)

[tor]
tor.streamisolation=true
tor.v3=1
tor.socks=9050  
tor.control=9051 
tor.dns=soa.nodes.lightning.directory:53
tor.active=1
; activate split connectivity
tor.skip-proxy-for-clearnet-targets=false

; Added by Parmanode (end)
" | tee -a $file >/dev/null 2>&1

swap_string "$file" "listen=0.0.0.0:$lnd_port" "listen=localhost:$lnd_port"
restart_lnd
if [[ $1 == skipsuccess ]] ; then true ; else
success "LND Tor enabling"
fi
}

function lnd_disable_tor {
local file=$HOME/.lnd/lnd.conf

cp $file ${dp}/backup_files/lnd.conf$(date | awk '{print $1$2$3}')-preDisableTor >/dev/null 2>&1

sed -i '/Added by Parmanode (start)/,/Added by Parmanode (end)/d' $file >/dev/null 2>&1
swap_string "$file" "listen=localhost:$lnd_port" "listen=0.0.0.0:$lnd_port"
restart_lnd

success "LND Tor disabling"
}

function lnd_enable_hybrid {
local file=$HOME/.lnd/lnd.conf
lnd_enable_tor skipsuccess

cp $file ${dp}/backup_files/lnd.conf$(date | awk '{printe $1$2$3}')-preEnableHybrid >/dev/null 2>&1

swap_string $file "tor.skip-proxy-for-clearnet-targets=false" "tor.skip-proxy-for-clearnet-targets=true" 
swap_string $file "tor.streamisolation=true" "tor.streamisolation=false"
# swap_string $file "; tlsextraip=$IP" "tlsextraip=$IP"

restart_lnd
success "LND hypbrid TOR/Clearnet mode" "being enabled"

}

function lnd_disable_hybrid {
local file=$HOME/.lnd/lnd.conf

cp $file ${dp}/backup_files/lnd.conf$(date | awk '{printe $1$2$3}')-preDisableHybrid >/dev/null 2>&1

swap_string $file "tor.skip-proxy-for-clearnet-targets=true" "; tor.skip-proxy-for-clearnet-targets=true"
swap_string $file "tor.streamisolation=false" "tor.streamisolation=true"
# swap_string $file "tlsextraip=$IP" "; tlsextraip=$IP"
restart_lnd
success "LND hypbrid TOR/Clearnet mode" "being disabled"
}