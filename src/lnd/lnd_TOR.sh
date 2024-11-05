function lnd_tor {
# arguments: only, both, off
local file=$HOME/.lnd/lnd.conf

if ! grep -q "lnddocker" < $ic && ! which tor >/dev/null ; then install_tor ; fi

#while stream isolation is enabled, the TOR proxy may not be skipped.

function lnd_tor_message {
while true ; do
echo -e "
########################################################################################

   Whether LND is running by Tor-Only or as a hybrid Tor/Clearnet ultimately is
   reveald by the$cyan Uniform Resource Identifier (URI)$orange types you see at the bottom
   of the LND menu.

$bright_blue
       If there is only a Tor URI (onion), then LND is running Tor-only. 
   
       If there is only a clearnet URI on the menu page, then LND is running on 
       clearnet only. 

       If you see both clearnet and onion addresses, it means LND is running as
       a hybrid Tor + clearnet node.

$cyan
   To ensure LND is running as Tor only$orange (if that's your preference), you need to turn
   Tor mode on, but also turn hybrid mode off. If Hybrid mode doesn't successfuly turn 
   off, (as concluded by the presence of a clearnet URI in the menu screen) you can 
   manually edit the lnd.conf file and make sure none of the configuration options are 
   specifying external clearnet addresses. Any configuration directive with 'listening'
   in the name is not included in this requirement.

########################################################################################
"
enter_abort 
read choice ; case $choice in a|A) return 1 ;; 
"") 
set_terminal ; please_wait ; return 0 ;; esac ; done
}

 function delete_tor_lnd_conf { 
   unset count
   while grep -q "Added by Parmanode (start)" < $file ; do #while loop removes multiple occurrences 
   sudo gsed -i '/Added by Parmanode (start)/,/Added by Parmanode (end)/d' $file >/dev/null 2>&1
   count=$((1 + count))
   sleep 0.5
   if [[ $count -gt 5 ]] ; then announce "loop error when editing $file. Aborting." ; return 1 ; fi
   done
   }

   function add_tor_lnd_conf {
   if grep -q "litd" < $ic >/dev/null 2>&1 ; then
   
   echo "; Added by Parmanode (start)

   lnd.tor.streamisolation=true
   lnd.tor.v3=1
   lnd.tor.socks=9050  
   lnd.tor.control=9051 
   lnd.tor.dns=soa.nodes.lightning.directory:53
   lnd.tor.active=1
   lnd.tor.skip-proxy-for-clearnet-targets=false

   ; Added by Parmanode (end)" | tee -a $file >/dev/null 2>&1

   else 

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
   fi
   }

function uncomment_clearnet {
if grep -q "litd" < $ic >/dev/null 2>&1 ; then

sudo gsed -i '/^; lnd.tlsextraip/s/^..//' $file
sudo gsed -i '/^; lnd.externalip/s/^..//' $file
sudo gsed -i '/^; lnd.tlsextradomain/s/^..//' $file
sudo gsed -i '/^; lnd.externalhosts/s/^..//' $file

else

sudo gsed -i '/^; tlsextraip/s/^..//' $file
sudo gsed -i '/^; externalip/s/^..//' $file
sudo gsed -i '/^; tlsextradomain/s/^..//' $file
sudo gsed -i '/^; externalhosts/s/^..//' $file

fi
}

function commentout_clearnet {
if grep -q "litd" < $ic >/dev/null 2>&1 ; then

sudo gsed -i '/^lnd.tlsextraip/s/^/; /' $file
sudo gsed -i '/^lnd.tlsextradomain/s/^/; /' $file
sudo gsed -i '/^lnd.externalip/s/^/; /' $file
sudo gsed -i '/^lnd.externalhosts/s/^/; /' $file

else

sudo gsed -i '/^tlsextraip/s/^/; /' $file
sudo gsed -i '/^tlsextradomain/s/^/; /' $file
sudo gsed -i '/^externalip/s/^/; /' $file
sudo gsed -i '/^externalhosts/s/^/; /' $file

fi
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
if grep -q "litd" <$ic >/dev/null 2>&1 ; then
sudo gsed -i "/listen=0.0.0.0:$lnd_port/c\lnd.listen=localhost:$lnd_port"  $file
else
sudo gsed -i "/listen=0.0.0.0:$lnd_port/c\listen=localhost:$lnd_port"  $file
fi
commentout_clearnet
;;

off)
#tor details removed higher up

#listens from all IPs
if grep -q "litd" <$ic >/dev/null 2>&1 ; then
sudo gsed -i "/listen=localhost:$lnd_port/c\lnd.listen=0.0.0.0:$lnd_port"  $file
else
sudo gsed -i "/listen=localhost:$lnd_port/c\listen=0.0.0.0:$lnd_port"  $file
fi
uncomment_clearnet
;;

both)
add_tor_lnd_conf

#listens from all IPs...
if grep -q "litd" <$ic >/dev/null 2>&1 ; then
sudo gsed -i "/listen=localhost:$lnd_port/c\lnd.listen=0.0.0.0:$lnd_port"  $file
else
sudo gsed -i "/listen=localhost:$lnd_port/c\listen=0.0.0.0:$lnd_port"  $file
fi
uncomment_clearnet

#opposite to tor-only, nonexistent when tor off...
if grep -q "litd" <$ic >/dev/null 2>&1 ; then
sudo gsed -i "/tor.streamisolation=true/c\lnd.tor.streamisolation=false" $file
sudo gsed -i "/tor.skip-proxy-for-clearnet-targets=false/c\lnd.tor.skip-proxy-for-clearnet-targets=true" $file 
else
sudo gsed -i "/tor.streamisolation=true/c\tor.streamisolation=false" $file 
sudo gsed -i "/tor.skip-proxy-for-clearnet-targets=false/c\tor.skip-proxy-for-clearnet-targets=true" $file 
fi
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
success "Adjusting LND Tor settings done."
fi
}