function write_to_fstab {
   UUID="$1"  
   if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi
        TYPE=$(blkid | grep $UUID | awk '{print $5}' | cut -d \" -f 2)
        debug "TYPE detected, $TYPE"
        echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail,uid=$(id -u),gid=$(id -g) 0 2" | sudo tee -a /etc/fstab > /dev/null 
        log "bitcoin" "fstab grep output for parmanode:" && \
        grep "parmanode" /etc/fstab >> $HOME/.parmanode/bitcoin.log     
}

function write_to_fstab2 {
export $(sudo blkid -o export $disk) >/dev/null

if [ -z $UUID ] ; then debug "no UUID" ; return 1 ; fi
delete_line "/etc/fstab" "$UUID"
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail,uid=$(id -u),gid=$(id -g) 0 2" | sudo tee -a /etc/fstab >/dev/null 
}