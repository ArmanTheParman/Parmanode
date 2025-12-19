#!/bin/env bash

source /usr/local/parmanode/src/home.sh
bc=$HOME/.bitcoin/bitcoin.conf
dn=/dev/null
#source /usr/local/parmanode/src/p4socket.sh
#source /usr/local/parmanode/src/debug.sh

if [[ $(uname) == "Darwin" ]] ; then 
    export macprefix="$(brew --prefix 2>/dev/null)" 
    if [[ -z $macprefix ]] ; then export macprefix="/usr/local" ; fi
    export torrc="$macprefix/etc/tor/torrc"
    export varlibtor="$macprefix/var/lib/tor"
fi

while [[ $# -gt 0 ]] ; do
case $1 in 

"startfresh")
gsed -i "/discover=/d"     $bc >$dn 2>&1
gsed -i "/onion/d"         $bc >$dn 2>&1
gsed -i -E "/^bind=/d"     $bc >$dn 2>&1
gsed -i "/onlynet/d"       $bc >$dn 2>&1
gsed -i "/listenonion=1/d" $bc >$dn 2>&1
gsed -i "/listen=0/d"      $bc >$dn 2>&1
gsed -i "/externalip=/d"   $bc >$dn 2>&1
gsed -i -E "/^\s*$/d"      $bc >$dn 2>&1
shift
;;
"localhost_onion")
     echo "onion=127.0.0.1:9050" | tee -a $bc >$dn 2>&1
     echo "discover=0" | tee -a $bc >$dn 2>&1
     echo "onlynet=onion" | tee -a $bc >$dn 2>&1 #new, disallows outward clearnet connections
     shift
;;
"host_docker_internal")
     echo "onion=host.docker.internal:9050" | tee -a $bc >$dn 2>&1
     shift
;;
"toronly")
     echo "listenonion=1" | tee -a $bc >$dn 2>&1

    shift
;;
"onlyout")
    gsed -i "/onlynet/d" $bc >$dn 2>&1
    gsed -i "/listenonion=1/d" $bc >$dn 2>&1
    echo "listen=0" | tee -a $bc >$dn 2>&1
    gsed -i -E '/^bind=/d' $bc >$dn 2>&1
    gsed -i "/externalip/d" $bc >$dn 2>&1
    echo "discover=0" | tee -a $bc >$dn 2>&1
;;
"listen_onion")
     echo "listenonion=1" | tee -a $bc >$dn 2>&1
     shift
;;
"externalip")
    echo "externalip=$2" | tee -a $bc >$dn 2>&1
    shift
;;
"discover0")
    echo "discover=0" | tee -a $bc >$dn 2>&1
    shift
;;
"listenonion=1")
    echo "listenonion=1" | tee -a $bc >$dn 2>&1
    shift
;;
"onlynet=onion")
    echo "onlynet=onion" | tee -a $bc >$dn 2>&1 
    shift
;;
"remove_onlynet")
    gsed -i "/onlynet/d" $bc >$dn 2>&1
    shift
;;
"remove_listenonion")
    gsed -i "/listenonion=1/d" $bc >$dn 2>&1
    shift
;;
"listen=0")
    echo "listen=0" | tee -a $bc >$dn 2>&1
    shift
;;
"remove_bind")
    gsed -i -E '/^bind=/d' $bc >$dn 2>&1
    shift
;;
"remove_externalip")
    gsed -i "/externalip/d" $bc >$dn 2>&1
    shift
;;

"remove_bitcoin_hidden_service")
    gsed -i  "/bitcoin-service/d"          $macprefix/etc/tor/torrc >$dn 2>&1
    gsed -i  "/127.0.0.1:8333/d"           $macprefix/etc/tor/torrc >$dn 2>&1
    gsed -i  "/onion/d"                    $bc  >$dn 2>&1
    echo "listenonion=0" | tee -a $bc >$dn 2>&1
    gsed -i  "/bind=127.0.0.1/d"           $bc >$dn 2>&1
    gsed -i  "/onlynet/d"                  $bc >$dn 2>&1
    shift
;;

"tor_additions_by_parmanode")

gsed -i -E "/# Additions by Parmanode/d" $torrc >$dn 2>&1
gsed -i -E "/^ControlPort 9051/d" $torrc >$dn 2>&1
gsed -i -E "/^CookieAuthentication 1/d" $torrc >$dn 2>&1
gsed -i -E "/^CookieAuthFileGroupReadable 1/d" $torrc >$dn 2>&1
gsed -i -E "/^DataDirectoryGroupReadable 1/d" $torrc >$dn 2>&1

cat << EOF | sudo tee -a $torrc >$dn

# Additions by Parmanode...
ControlPort 9051
CookieAuthentication 1
CookieAuthFileGroupReadable 1
DataDirectoryGroupReadable 1

EOF
shift
;;

"") break ;;
esac
done