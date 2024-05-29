function uninstall_litd {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall LITD $orange
$blinkon
    DATA MIGHT BE LOST!    
$blinkoff$orange
    Do you want to keep your$cyan ~/.lit/$orange data? When you re-install litd, or upgrade,
    everything should return to where you left off, even the open channels.

    Or you can delete that directory and lose everything.
$red
                  1)    Uninstall litd and delete ~/.lit directory 
$cyan
                  2)    Uninstall litd and backup ~/.lit directory to ~/.lit_backup
$green
                  3)    Uninstall and leave ~/.lit as is (can be automatically used 
                                                          when reinstalling litd) $orange
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
sudo systemctl stop litd.service
;;
esac

case $choice in
1)
sudo rm -rf $hp/litd $HOME/.lit/
break
;;
2)
mv $HOME/.lit $HOME/.lit_backup
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

cd /usr/local/bin && sudo rm frcli  litcli  litd  lncli  loop  pool  tapcli

sudo rm /etc/nginx/conf.d/litd.conf
rm $HOME/.lnd #removes symlink to .lit
sudo rm /etc/systemd/system/litd.service
rm -rf $HOME/parmanode/litd 
parmanode_conf_remove "bitcoin_choice_with_litd"
parmanode_conf_remove "lnd_port"
installed_conf_remove "litd"
success "LITD" "being uninstalled."
return 0
}
