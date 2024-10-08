function remove_bitcoin_directories_mac {
if [[ $1 == install ]] ; then
leave_or_use="Use it"
else
leave_or_use="Leave it alone"
fi
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

#Remove Parmanode/bitcoin directory (installation files)
sudo rm -rf $HOME/parmanode/bitcoin >/dev/null 2>&1 \
    || log "bitcoin" "failed to remove /parmanode/bitcoin dir"

#check if data directory on external drive or internal drive
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1  # gets drive choice

#check external drive first - mounted and unmounted conditions.


if [[ $drive == "external" && -d /Volumes/parmanode/.bitcoin ]] ; then #drive would have to be mounted to be true 
while true ; do
if [[ $btcpayinstallsbitcoin != 1 ]] ; then
set_terminal
echo -e "
########################################################################################

    It appears there is a Bitcoin data directory on the external drive. 
    You have choices:
$red
                            del)        Delete $orange
$green
                            l)          Leave it
$orange
########################################################################################
"
choose "xq" ; read choice 
else
choice=l
fi

case $choice in

q|Q|Quit|QUIT) 
exit ;;

l|L)
break 
;;

DEL|del|DELETE|Delete)
cd ; rm -rf /Volumes/parmanode/.bitcoin >/dev/null 2>&1
break 
;;

*) invalid ;;
esac
done
fi #end checking external drive for data directory


#check internal drive for data directory existance 
if [[ -d $HOME/.bitcoin && ! -L $HOME/.bitcoin ]] ; then    #checks for directory, and not a symlink
while true ; do
if [[ $btcpayinstallsbitcoin != "true" ]] ; then
set_terminal ; echo -e "
########################################################################################

    It appears there is a Bitcoin data directory on the internal drive at:
$cyan    
                            $HOME/.bitcoin
$orange
    You have choices:

                            del)        Delete

                            b)          Create a back up 

                            3)          $leave_or_use



    Back up will be renamed to$cyan bitcoin_backup0$orange.

########################################################################################
"
choose "xq" ; read choice 
else
choice=3
fi

case $choice in
q|Q|quit|QUIT) 
exit 0 ;;
3) break ;;
s|S|SKIP|skip|Skip)
    make_backup_dot_bitcoin 
    break
    ;;
DEL|del|DELETE|Delete)    
    cd && rm -rf $HOME/.bitcoin 
    break 
    ;; 
*) invalid ;;
esac
done
fi #end checking internal drive for .bitcoin directory

#Remove symlink to drive
if [[ -L "$HOME/.bitcoin" ]] 2>/dev/null ; then 
    rm $HOME/.bitcoin  
    fi      

#Remove symlink from default Bitcoin directory to $HOME/.bitcoin
if [[ -L $HOME/Library/"Application Support"/Bitcoin ]] ; then
    rm $HOME/Library/"Application Support"/Bitcoin ; fi 

return 0
}
