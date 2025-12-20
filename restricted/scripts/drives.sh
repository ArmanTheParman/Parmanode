#!/bin/env bash

source /usr/local/parmanode/src/home.sh
source /usr/local/parmanode/src/parmanode_variables.sh

while [[ $# -gt 0 ]] ; do
case $1 in 

"unmount")
    thedrive="$(jq -r .bitcoin.driveName $p4)"
    #this ensures that a variable injected can only perform an unmount on the listed drives with lsblk -lp, for safety.
    [[ -n "$thedrive" && "$thedrive" == /dev/* ]] || exit 1
    if grep -Fxq "$thedrive" <(lsblk -nrpo NAME) ; then
        umount "$thedrive"[0-9]* >$dn 2>&1
        umount "$thedrive" >$dn 2>&1
    fi
    shift
    ;;

"fdisk")
# Create a new GPT partition table and a single partition on the drive
# interestingly, you can plonk a redirection in the middle of a heredoc like this:

sudo fdisk "$disk_no_number" <<EOF >$dn 
g
w
EOF
sleep 2

shift
shift
;;

"format_ext_drive")
    disk=$(jq -r '.bitcoin.driveName' $p4 2>&1)
    [[ -z $disk ]] && exit 1
    mkfs.ext4 -F -L "parmanode" $disk 
    tune2fs -m 1 $disk >$dn 2>&1
    blkid >$dn ; sleep 1 ; partprobe #need to refresh

shift
;;

esac
done