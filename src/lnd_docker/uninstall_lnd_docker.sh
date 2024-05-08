function uninstall_lnd_docker {
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
q|Q) exit ;; a|A|p|P) return 1 ;;
*)
if ! echo "$choice" | grep -qE '1|2|3' ; then invalid ; continue ; fi
lnd_docker_stop silent
docker rm lnd
break
;;
esac

case $choice in
1)
rm -rf $hp/lnd $HOME/.lnd/
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

installed_conf_remove "lnddocker"
success "LND Docker has finished being uninstalled"
}