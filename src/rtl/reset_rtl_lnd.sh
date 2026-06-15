function reset_rtl_lnd {

while true ; do
set_terminal 
yesorno " 
    This will re-install RTL to re-establish a new configuration to your LN node. 

    This does not affect the LN node or your funds in anyway." && break

# not answering yes continues loop and captures choice variable
jump $choice 
case $choice in
Q|q) exit ;; m|M) back2main ;;
n|N|NO|no|p|P) return 1 ;;
*) invalid ;;
esac
done

uninstall_rtl
install_rtl
}