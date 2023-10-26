function lnd_enable_tor {
local file=$HOME/.lnd/lnd.conf

if ! which tor >/dev/null ; then install_tor ; fi

cp $file ${dp}/backup_files/lnd.conf$(date | awk '{print $1$2$3}')-presableTor >/dev/null 2>&1

echo "
; Added by Parmanode (start)

[tor]
tor.streamisolation=true
tor.v3=1
tor.socks=9050  
tor.control=9051 
tor.dnx=soa.nodes.lightning.directory:53
tor.active=1
; activate split connectivity
; tor.skip-proxy-for-clearnet-targets=true

; Added by Parmanode (end)
" | tee -a $file >/dev/null 2>&1

swap_string "$file" "listen=0.0.0.0:9735" "listen=localhost"
swap_string "$file" "externalip=" "; externalip=$extIP:9735"
restart_lnd
success "LND Tor enabling"
}

function lnd_disable_tor {
local file=$HOME/.lnd/lnd.conf

cp $file ${dp}/backup_files/lnd.conf$(date | awk '{print $1$2$3}')-preDisableTor >/dev/null 2>&1

sed -i '/Added by Parmanode (start)/,/Added by Parmanode (end)/d' $file >/dev/null 2>&1
swap_string "$file" "listen=localhost" "listen=0.0.0.0:9735"
swap_string "$file" "; externalip=" "externalip=$extIP:9735"
restart_lnd

success "LND Tor diabling"
}

function lnd_enable_hybrid {
local file=$HOME/.lnd/lnd.conf
lnd_enable_tor

cp $file ${dp}/backup_files/lnd.conf$(date | awk '{printe $1$2$3}')-preEnableHybrid >/dev/null 2>&1

swap_string $file "; tor.skip-proxy-for-clearnet-targets=true" "tor.skip-proxy-for-clearnet-targets=true"

restart_lnd
success "LND hypbrid TOR/Clearnet mode" "being enabled"

}

function lnd_disable_hybrid {
local file=$HOME/.lnd/lnd.conf

cp $file ${dp}/backup_files/lnd.conf$(date | awk '{printe $1$2$3}')-preDisableHybrid >/dev/null 2>&1

swap_string $file "tor.skip-proxy-for-clearnet-targets=true" "; tor.skip-proxy-for-clearnet-targets=true"

restart_lnd
success "LND hypbrid TOR/Clearnet mode" "being disabled"
}