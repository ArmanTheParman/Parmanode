#!/bin/env bash

source /usr/local/parmanode/src/home.sh
bc=$HOME/.bitcoin/bitcoin.conf
dn=/dev/null
#source /usr/local/parmanode/src/p4socket.sh
#source /usr/local/parmanode/src/debug.sh

case $1 in
"")
#start fresh
gsed -i "/discover=/d"     $bc >$dn 2>&1
gsed -i "/onion/d"         $bc >$dn 2>&1
gsed -i -E "/^bind=/d"     $bc >$dn 2>&1
gsed -i "/onlynet/d"       $bc >$dn 2>&1
gsed -i "/listenonion=1/d" $bc >$dn 2>&1
gsed -i "/listen=0/d"      $bc >$dn 2>&1
gsed -i "/externalip=/d"   $bc >$dn 2>&1
gsed -i -E "/^\s*$/d"      $bc >$dn 2>&1
;;

"localhost_onion")
     echo "onion=127.0.0.1:9050" | tee -a $bc >$dn 2>&1
;;
"host_docker_internal")
     echo "onion=host.docker.internal:9050" | tee -a $bc >$dn 2>&1
;;
"listen_onion")
     echo "listenonion=1" | tee -a $bc >$dn 2>&1
;;
"externalip")
    echo "externalip=$2" | tee -a $bc >$dn 2>&1
;;
"discover0")
    echo "discover=0" | tee -a $bc >$dn 2>&1
;;
"listenonion=1")
    echo "listenonion=1" | tee -a $bc >$dn 2>&1
;;
"onlynet=onion")
    echo "onlynet=onion" | tee -a $bc >$dn 2>&1 
;;
"remove_onlynet")
    gsed -i "/onlynet/d" $bc >$dn 2>&1
;;
"remove_listenonion")
    gsed -i "/listenonion=1/d" $bc >$dn 2>&1
;;
"listen=0")
    echo "listen=0" | tee -a $bc >$dn 2>&1
;;
"remove_bind")
    gsed -i -E '/^bind=/d' $bc >$dn 2>&1
;;
"remove_externalip")
    gsed -i "/externalip/d" $bc >$dn 2>&1
;;

esac