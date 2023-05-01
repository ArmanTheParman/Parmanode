function remove_fstab_entry {
#delete fstab entry of the disk immediately before wiping
remove_UUID_fstab "$disk" >> $HOME/.parmanode/bitcoin.log && log "bitcoin" "UUID removed for $disk from fstab"
}