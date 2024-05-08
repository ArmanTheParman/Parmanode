function reset_rtl_lnd {

while true ; do
set_terminal ; echo -e "
########################################################################################

    This will re-install RTL to re-establish a new configuration to your LND node. 

    This does not affect LND node or your funds in anyway

    Continue?$green     y   $orange or $red    n $orange

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
Q|q) exit ;; m|M) back2main ;;
n|N|NO|no|p|P) return 1 ;;
y|Y|yes|Yes|YES)
break
;;
*) invalid ;;
esac
done
uninstall_rtl
install_rtl
}