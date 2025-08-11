function write_to_fstab {
   # can't export everything, need grep, becuase if Label has spaces, causes error.
   export $(sudo blkid -o export $disk | grep TYPE)

   if [[ $TYPE != ext4 ]] ; then 
   TYPE=$(sudo blkid | grep $UUID | awk '{print $5}' | cut -d \" -f 2)
   fi
   debug "TYPE detected, $TYPE"
   # exfat drives don't work in fstab and cause issues.
   if [[ $TYPE != ext4 ]] ; then log "drive" "exit write_to_fstab because drive not ext4. Is $TYPE" ; return ; fi

   if [[ -z $1 ]] ; then 
   export $(sudo blkid -o export $disk | grep UUID)
   else
   UUID="$1"  
   fi

   if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi

   echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail,noatime,x-systemd.device-timeout=20s 0 2" | sudo tee -a /etc/fstab > $dn 
   sudo systemctl daemon-reload >$dn 2>&1 #needed to reload fstab to systemd
}