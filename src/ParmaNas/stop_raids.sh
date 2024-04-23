function stop_raids {

raids_running=$(sudo mdadm --detail --scan | wc -l)
raids_list=$(sudo mdadm --detail --scan | awk '/ARRAY/{print $2}')

if [[ $raids_running == 0 ]] ; then return 0 ; fi

if [[ $raids_running == 1 ]] ; then 
while true ; do
set_terminal ; echo -e "
########################################################################################
    $pink
    It looks like your system already has a RAID process running.
    $green
$(sudo mdadm --detail --scan) $orange

    Do you want Parmanode to stop it before continuing, or leave it and add a second
    RAID to the system?
                         $green
                                s)     Stop the RAID
                         $red   
                                l)     Leave it alone
                         $orange
                                x)     I don't know, leave ME alone (abort)

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; x|p|P) return 1 ;; m|M) back2main ;; l) break ;;
s)
stop_it=$(sudo mdadm --detail --scan | awk '/ARRAY/{print $2}')
sudo mdadm --stop $stop_it
announce "RAID process stopped"
unset stop_it
break
;;
esac
done
fi


if [[ $raids_running -gt 1 ]] ; then 
while true ; do
set_terminal ; echo -e "
########################################################################################
    $pink
    It looks like your system already has more than one RAID process running.
    $green
$(sudo mdadm --detail --scan) $orange

    Do you want Parmanode to stop thenm before continuing, or leave them alone and 
    add an extra RAID to the system?

                         $green
                                s)     Stop the RAIDs
                         $red   
                                l)     Leave them alone
                         $orange
                                x)     I don't know, leave ME alone (abort)

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; x|p|P) return 1 ;; m|M) back2main ;; l) break ;;
s)
for i in $raids_list; do
sudo mdadm --stop $i
done
announce "RAID processes stopped"
break
;;
esac
done
fi

}