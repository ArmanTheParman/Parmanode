#!/bin/env bash

source /usr/local/parmanode/src/home.sh
source /usr/local/parmanode/src/parmanode_variables.sh

while [[ $# -gt 0 ]] ; do
case $1 in 

"unmount")
    thedrive="$(jq -r .bitcoin.driveName $p4)"
    #this ensures that a variable injected can only perform an unmount on the listed drives with lsblk -lp, for safety.
    [[ -n "$thedrive" && "$thedrive" == /dev/* ]] || exit 1
    if grep -Fxq "$thedrive" <(lsblk -nro NAME) ; then
        umount "$thedrive"[0-9]* >$dn 2>&1
        umount "$thedrive" >$dn 2>&1
    fi
    shift
    ;;

esac
done