function check_raid_exists {
if sudo mdadm --detail /dev/md0 ; then
set_terminal ; echo -e "
########################################################################################

    A RAID system /dev/md0 already exists. Decommission? This will result in data
    loss on the RAID.

    Type $cyan decommission$orange exactly and$cyan <enter>$orange to do that, or
    anything else to abort.

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in 
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
decommission)
sudo mdadm --stop /dev/md0 >/dev/null
sudo mdadm --remove /dev/md0 >/dev/null
;;
*)
return 1
;;
esac
fi

}