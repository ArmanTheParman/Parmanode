function lnd_tor {
# arguments: only, both, off
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
local file=$HOME/.lnd/lnd.conf
if ! which tor >/dev/null ; then install_tor ; fi

#while stream isolation is enabled, the TOR proxy may not be skipped.

function lnd_tor_message {
echo -e "
########################################################################################

   Whether LND is running by Tor-Only or as a hybrid Tor/Clearnet ultimately is
   determined by the URL types you see at the bottom of the LND menu.

   If there is only a Tor URL (onion), then LND is running Tor-only. 
   
   If there is only a clearnet URL on the menu page, then LND is running on clearnet 
   only. 

   Obviously if you see both clearnet and onion addresses, it means LND is running as
   a hybrid Tor and clearnet node.
$cyan
   To ensure LND is running as Tor only (if that's your preference), you need to turn
   Tor on, but also turn hybrid off. If Hybrid mode doesn't successfuly turn off, you
   can manually edit the lnd.conf file and make sure none of the configuration options
   are specifying external clearnet addresses. Anything with 'Listening' is not
   included in this rquirement.
$red
   Please also note that the Tor setting for Bitcoin must match the LND settings or
   else LND won't start/run. Parmanode will do this by modifying the bitcoin.conf
   settings now.
$orange
########################################################################################
"
enter_abort || return 1
}

 function delete_tor_lnd_conf { 
   unset count
   while grep -q "Added by Parmanode (start)" < $file ; do
   sed -i '/Added by Parmanode (start)/,/Added by Parmanode (end)/d' $file >/dev/null 2>&1
   count=$((1 + count))
   sleep 0.5
   if [[ $count -gt 5 ]] ; then announce "loop error when editing $file. Aborting." ; return 1 ; fi
   done
   }

   function add_tor_lnd_conf {
   echo "; Added by Parmanode (start)

   [tor]
   tor.streamisolation=true
   tor.v3=1
   tor.socks=9050  
   tor.control=9051 
   tor.dns=soa.nodes.lightning.directory:53
   tor.active=1
   ; activate split connectivity
   tor.skip-proxy-for-clearnet-targets=false

   ; Added by Parmanode (end)" | tee -a $file >/dev/null 2>&1
   }

function uncomment_clearnet {
sed -i '/^; tlsextraip/s/^..//' $file
sed -i '/^; externalip/s/^..//' $file
sed -i '/^; tlsextradomain/s/^..//' $file
}

function commentout_clearnet {
sed -i '/^tlsextraip/s/^/; /' $file
sed -i '/^tlsextradomain/s/^/; /' $file
sed -i '/^externalip/s/^/; /' $file
}

########################################################################################
#Begin
########################################################################################

if [[ $1 != off ]] ; then
lnd_tor_message || return 1
fi
delete_tor_lnd_conf || return 1

case $1 in

only)
add_tor_lnd_conf
#disable non-tor proxy traffic ...
swap_string "$file" "listen=0.0.0.0:$lnd_port" "listen=localhost:$lnd_port" 
commentout_clearnet
;;

off)
#tor details removed higher up

#listens from all ports
swap_string "$file" "listen=localhost:$lnd_port" "listen=0.0.0.0:$lnd_port" 
uncomment_clearnet
;;

both)
add_tor_lnd_conf

#listens from all ports...
swap_string "$file" "listen=localhost:$lnd_port" "listen=0.0.0.0:$lnd_port" 
uncomment_clearnet

#opposite to tor-only, nonexistent when tor off...
swap_string $file "tor.streamisolation=true" "tor.streamisolation=false" 
swap_string $file "tor.skip-proxy-for-clearnet-targets=false" "tor.skip-proxy-for-clearnet-targets=true" 
;;

*)
announce "Small bug. Please report to Parman. Aborting."
return 1
;;

esac

if [[ $3 != norestartlnd ]] ; then
restart_lnd
fi

if [[ $2 != skipsuccess ]] ; then
success "Adjusting LND Tor settings has"
fi
}