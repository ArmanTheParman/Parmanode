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

fdisk "$disk_no_number" <<EOF >$dn 
g
w
EOF
sleep 1.5
shift 2
;;

"format_ext_drive")
    disk=$(jq -r '.bitcoin.driveName' $p4 2>&1)
    [[ -z $disk ]] && exit 1
    mkfs.ext4 -F -L "parmanode" $disk 
    tune2fs -m 1 $disk >$dn 2>&1
    e2label $disk parmanode >$dn || exfatlabel $disk parmanode >$dn 

shift
;;

"add_to_fstab")
   echo "UUID=$2 /media/$3/parmanode $4 defaults,nofail,noatime,x-systemd.device-timeout=20s 0 2" | tee -a /etc/fstab >> /tmp/debug.log
   shift 4
;;

esac
done