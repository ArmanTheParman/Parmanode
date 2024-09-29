function uninstall_lnd {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall LND $orange
$blinkon
    DATA MIGHT BE LOST!    
$blinkoff$orange
    Do you want to keep your$cyan ~/.lnd/$orange data? When you re-install LND, or upgrade,
    everything should return to where you left off, even the open channels.

    Or you can delete that directory and lose everything.
$red
                  1)    Uninstall LND and delete ~/.lnd directory 
$cyan
                  2)    Uninstall LND and backup ~/.lnd directory to ~/.lnd_backup
$green
                  3)    Uninstall and leave ~/.lnd as is (can be automatically used 
                                                          when reinstalling LND) $orange
                  a)    Abort    

########################################################################################
"
choose "xpmq" 
read choice
set_terminal

case $choice in
q|Q) exit ;; a|A|p|P) return 1 ;; m|M) back2main ;; 
*)
if ! echo "$choice" | grep -qE '1|2|3' ; then invalid ; continue ; fi
sudo systemctl stop lnd.service
;;
esac

case $choice in
1)
sudo rm -rf $hp/lnd $HOME/.lnd/
break
;;
2)
mv $HOME/.lnd $HOME/.lnd_backup
break
;;
3)
break
;;
*)
invalid
;;
esac
done

sudo rm /etc/systemd/system/lnd.service
sudo rm -rf $HOME/parmanode/lnd 
parmanode_conf_remove "bitcoin_choice_with_lnd"
parmanode_conf_remove "lnd_port"
parmanode_conf_remove "LNDIP"
installed_conf_remove "lnd-"
success "LND" "being uninstalled."
return 0
}