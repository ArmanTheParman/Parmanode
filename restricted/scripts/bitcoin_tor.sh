#!/bin/env bash

source /usr/local/parmanode/src/parmanode_variables.sh ; parmanode_variables
source /usr/local/parmanode/src/p4socket.sh
source /usr/local/parmanode/src/debug.sh

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

