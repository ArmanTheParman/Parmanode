function write_to_fstab {
   # can't export everything, need grep, becuase if Label has spaces, causes error.
   export $(sudo blkid -o export $disk | grep TYPE) >/dev/null 
   export $(sudo blkid -o export $disk | grep UUID) >/dev/null 

   UUID="$1"  
   if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi
   # exfat drives don't work in fstab and cause issues.
   if [[ $TYPE != ext4 ]] ; then log "drive" "exit write_to_fstab because drive not ext4. Is $TYPE" ; return ; fi

   TYPE=$(blkid | grep $UUID | awk '{print $5}' | cut -d \" -f 2)
   debug "TYPE detected, $TYPE"
   echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab > /dev/null 
   debug "pause after fstab write"
   log "bitcoin" "fstab grep output for parmanode:" && \
   grep "parmanode" /etc/fstab >> $HOME/.parmanode/bitcoin.log     
}

function write_to_fstab2 {
        # can't export everything, need grep, becuase if Label has spaces, causes error.
        export $(sudo blkid -o export $disk | grep TYPE) >/dev/null 
        export $(sudo blkid -o export $disk | grep UUID) >/dev/null 

        # exfat drives don't work in fstab and cause issues.
        # This only happens if a user tries to import a non Parmanode drive as a an old parmanode drive.
        if [[ $TYPE != ext4 ]] ; then log "drive" "exit write_to_fstab2 because drive not ext4" ; return ; fi

        if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi
        delete_line "/etc/fstab" "$UUID"
        echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >/dev/null 
}