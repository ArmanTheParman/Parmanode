function offer_swap_to_external {
while true ; do      
source ${dp}/parmanode.conf >/dev/null 2>&1
if [[ $drive == internal ]] ; then
set_terminal ; echo -e "
########################################################################################

    Bitcoin is currently configured to sync to the internal drive. Would you like
    to run the wizard to swap to the external drive?

            y)       nice

            n)       go away

########################################################################################      
"
choose "xpmq" ; read choice
case $choice in

m) back2main ;;
q|Q) exit ;;
p|P) return 1 ;;
n|N) return 0 ;;
y|Y|YES|Yes|yes)
change_bitcoin_drive
return 0 ;;
*) invalid
;;
esac
fi
done


}