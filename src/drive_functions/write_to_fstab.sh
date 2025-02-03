function write_to_fstab {
   # can't export everything, need grep, becuase if Label has spaces, causes error.
   export $(sudo blkid -o export $disk | grep TYPE)
   export $(sudo blkid -o export $disk | grep UUID)

   UUID="$1"  
   if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi
   # exfat drives don't work in fstab and cause issues.
   if [[ $TYPE != ext4 ]] ; then log "drive" "exit write_to_fstab because drive not ext4. Is $TYPE" ; return ; fi

   TYPE=$(blkid | grep $UUID | awk '{print $5}' | cut -d \" -f 2)
   debug "TYPE detected, $TYPE"
   echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab > $dn 
   log "bitcoin" "fstab grep output for parmanode:" && \
   grep "parmanode" /etc/fstab >> $HOME/.parmanode/bitcoin.log     
   sudo systemctl daemon-reload #needed to reload fstab to systemd
}

function write_to_fstab2 {
        nogsedtest
        # can't export everything, need grep, becuase if Label has spaces, causes error.
        export $(sudo blkid -o export $disk | grep TYPE)
        export $(sudo blkid -o export $disk | grep UUID)

        # exfat drives don't work in fstab and cause issues.
        # This only happens if a user tries to import a non Parmanode drive as a an old parmanode drive.
        if [[ $TYPE != ext4 ]] ; then log "drive" "exit write_to_fstab2 because drive not ext4" ; return ; fi

        if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi
        sudo gsed -i "/$UUID/d" /etc/fstab
        echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >$dn 
        sudo systemctl daemon-reload #needed to reload fstab to systemd
}