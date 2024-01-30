function check_wallet_connected {
#Make sure the wallet can connect to whatever server it is set up to connect to.

unset running 
if ! ps -x | grep bitcoin | grep "bitcoin.conf" >/dev/null 2>&1 ; then running=false ; fi
if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then running=false ; fi
if pgrep bitcoind >/dev/null 2>&1 ; then running=true ; fi
if [[ $bitcoinrunning != false ]] ; then running=true ; fi
if [[ $bitcoinrunning == false ]] ; then announce "Bitcoin is not running, don't expect $1 to be connected." ; return 0 ; fi


if [[ $connection == Bitcoin_userpass ]] ; then
  if ! grep -q "rpcuser" < $HOME/.bitcoin/bitcoin.conf ; then
      announce "$1 is configured to connect to Bitcoin with a username and "\
      "password, but Bitcoin is configured to connect by a cookie file. Be warned."
        return 0
  fi
fi

if [[ $connection == Bitcoin_cookie ]] ; then
  if  grep -q "rpcuser" < $HOME/.bitcoin/bitcoin.conf ; then
      announce "$1 is configured to connect to Bitcoin by cookie file but"\
      "Bitcoin is configured to connect by a cookie file. Be warned."
        return 0
  fi
fi

if [[ $connection == FulcrumTOR || $connection == FulcrumSSL || $connection == FulcrumTCP ]] ; then
   if ! ps -x | grep fulcrum | grep conf >/dev/null 2>&1 ; then
   announce "$1 is configured to connect to Fulcrum, but Fulcrum is"\
   "not running. Be warned."
   fi
fi

if [[ $connection == electrsTCP || $connection == electrsTOR || $connection == electrsSSL ]] ; then
  if ! ps -x | grep electrs | grep conf >/dev/null 2>&1 && ! docker ps | grep -q electrs ; then 
  announce "$1 is configured to connect to electrs, but electrs is"\
  "not running. Be warned."
  fi
fi

if [[ $connection == Docker_FulcrumSSL ]] ; then
  if ! docker ps | grep fulcrum ; then
  announce "$1 is configured to connect to Fulcrum, but Fulcrum is"\
  "not running. Be warned."
  fi
fi

}