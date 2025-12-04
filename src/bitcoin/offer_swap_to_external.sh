function offer_swap_to_external { debugf
while true ; do      
source ${dp}/parmanode.conf >$dn 2>&1
if [[ $drive == "internal" ]] ; then
set_terminal ; echo -e "
########################################################################################

    Bitcoin is currently configured to sync to the internal drive. Would you like
    to run the wizard to swap to the external drive?
$cyan
                                y)$orange       nice
$cyan
                                n)$orange       go away

########################################################################################      
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
m|M) back2main ;; q|Q) exit ;; p|P) return 1 ;; n|N) return 0 ;;
y|Y|YES|Yes|yes)
change_bitcoin_drive swap #argument needed to skip question being asked a second time
return 0 ;;
*) invalid
;;
esac
else
break
fi
done


}
