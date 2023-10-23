function write_to_fstab {
   UUID="$1"  
   if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi
   
        echo "UUID=$UUID /media/$(whoami)/parmanode ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab > /dev/null 2>&1
        log "bitcoin" "fstab grep output for parmanode:" && \
        grep "parmanode" /etc/fstab >> $HOME/.parmanode/bitcoin.log     

}

function write_to_fstab2 {

export $(sudo blkid -o export $disk) >/dev/null

if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi
delete_line "/etc/fstab" "$UUID"
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >/dev/null 2>&1

}