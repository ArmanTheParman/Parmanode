function fix_fstab {

if grep -q "parmanode" /etc/fstab | grep -q "defaults " ; then 

    sudo cp /etc/fstab etc/fstab_backup_parmanode

    sudo sed -i '/parmanode/ s/defaults /defaults,nofail /g' /etc/fstab >/dev/null 2>&1

fi
}