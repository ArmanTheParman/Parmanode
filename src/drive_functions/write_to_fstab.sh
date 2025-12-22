function write_to_fstab {
   # can't export everything, need grep, becuase if Label has spaces, causes error.
   export $(sudo blkid -o export $disk | grep TYPE)

   if [[ $TYPE != "ext4" ]] ; then 
   TYPE=$(sudo blkid | grep $UUID | awk '{print $5}' | cut -d \" -f 2)
   fi
   # exfat drives don't work in fstab and cause issues.
   
   if [[ $TYPE != "ext4" ]] ; then debug "TYPE detected, $TYPE" ; return 1 ; fi

   if [[ -z $1 ]] ; then 
   export $(sudo blkid -o export $disk | grep UUID)
   else
   UUID="$1"  
   fi

   if [ -z $UUID ] ; then return 1 ; fi
   debug "before add fstab... $UUID $USER $TYPE"
   [[ $parmaview == 1 ]] && sudo /usr/local/parmanode/p4run "add_to_fstab"  "$UUID" "$USER" "$TYPE"
   [[ $parmaview != 1 ]] && echo "UUID=$UUID /media/$USER/parmanode $TYPE defaults,nofail,noatime,x-systemd.device-timeout=20s 0 2" | sudo tee -a /etc/fstab > $dn 
   sudo systemctl daemon-reload >$dn 2>&1 #needed to reload fstab to systemd
}