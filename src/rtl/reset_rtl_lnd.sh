function reset_rtl_lnd {

while true ; do
set_terminal ; echo -e "
########################################################################################

    This will re-install RTL to re-establish a new configuration to your LND node. 

    This does not affect LND node or your funds in anyway

    Continue?     y   or    n

########################################################################################
"
choose "epq" ; read choice
case $choice in
Q|q) exit ;;
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