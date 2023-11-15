function remove_bitcoin_directories_mac {

source $HOME/.parmanode/parmanode.conf

#Remove Parmanode/bitcoin directory (installation files)
sudo rm -rf $HOME/parmanode/bitcoin >/dev/null 2>&1 \
    || log "bitcoin" "failed to remove /parmanode/bitcoin dir"

#check if data directory on external drive or internal drive
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1  # gets drive choice

#check external drive first - mounted and unmounted conditions.
if [[ $1 == install ]] ; then
leave_or_use="Use it"
else
leave_or_use="Leave it alone"
fi

if [[ $drive == "external" && -d /Volumes/parmanode/.bitcoin ]] ; then #drive would have to be mounted to be true 
while true ; do
set_terminal
echo "
########################################################################################

    It appears there is a Bitcoin data directory on the external drive. 
    You have choices:

                            d)          Delete

                            L)          Leave it

########################################################################################
"
choose "xq" ; read choice 
case $choice in

q|Q|Quit|QUIT) 
exit ;;

l|L)
log "bitcoin" "skip; not deleting .bitcoin on drive" 
break 
;;

d|D|DELETE|Delete)
log "bitcoin" "deleting .bitcoin on drive" 
cd ; rm -rf /Volumes/parmanode/.bitcoin >/dev/null 2>&1 \
|| { log "bitcoin" "error deleting .bitcoin dir"
debug "Error deleting .bitcoin directory. Continuing." ; } 
break 
;;

*) invalid ;;
esac
done
fi #end checking external drive for data directory


#check internal drive for data directory existance 
if [[ -d $HOME/.bitcoin && ! -L $HOME/.bitcoin ]] ; then    #checks for directory, and not a symlink
while true ; do
set_terminal ; echo -e "
########################################################################################

    It appears there is a Bitcoin data directory on the internal drive at:
    
                            $HOME/.bitcoin

    You have choices:

                            d)          Delete

                            b)          Create a back up 

                            3)          $leave_or_use



    Back up will be renamed to$cyan bitcoin_backup0$orange.

########################################################################################
"
choose "xq" ; read choice 
case $choice in
q|Q|quit|QUIT) 
exit 0 ;;
3) break ;;
s|S|SKIP|skip|Skip)
    log "bitcoin" "user chose to skip deleting internal .bitcoin drive. make backup executing." && \
    make_backup_dot_bitcoin 
    break
    ;;
d|D|delete|Delete|DELETE)
    log "bitcoin" "user chose to delete internal .bitcoin dir"
    cd && rm -rf $HOME/.bitcoin 
    break 
    ;; 
*) invalid ;;
esac
done
fi #end checking internal drive for .bitcoin directory


#Remove symlink to drive
if [[ -L "$HOME/.bitcoin" ]] 2>/dev/null ; then 
    rm $HOME/.bitcoin && \
    log "bicoin" "symlink .bitcoin deleted"
    fi      

#Remove symlink from default Bitcoin directory to $HOME/.bitcoin
if [[ -L $HOME/Library/"Application Support"/Bitcoin ]] ; then
    log "bitcoin" "Application Support/Bitcoin symlink deleted" && \
    rm $HOME/Library/"Application Support"/Bitcoin ; fi 

return 0
}
