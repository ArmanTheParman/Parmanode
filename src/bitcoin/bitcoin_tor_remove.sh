function bitcoin_tor_remove { debugf

stop_bitcoin
#delete...
$xsudo gsed -i  "/# Additions by Parmanode/d" $macprefix/etc/tor/torrc
$xsudo gsed -i  "/bitcoin-service/d"          $macprefix/etc/tor/torrc
$xsudo gsed -i  "/127.0.0.1:8333/d"           $macprefix/etc/tor/torrc
$xsudo gsed -i  "/onion/d"                    $bc 
echo "listenonion=0" | $xsudo tee -a $bc >$dn 2>&1
$xsudo gsed -i  "/bind=127.0.0.1/d"           $bc
$xsudo gsed -i  "/onlynet/d"                  $bc


add_rpcbind #adds 0.0.0.0

rm $HOME/.bitcoin/onion* >$dn 2>&1
start_bitcoin
set_terminal
return 0

}