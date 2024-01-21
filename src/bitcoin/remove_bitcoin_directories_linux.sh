function remove_bitcoin_directories_linux {
if [[ $1 == install ]] ; then
leave_or_use="Use it"
else
leave_or_use="Leave it alone"
fi

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

#Remove Parmanode/bitcoin directory (installation files)
rm -rf $HOME/parmanode/bitcoin >/dev/null 2>&1 

if [[ $installer == parmanodl ]] ; then return 0 ; fi 

#check external drive first - mounted and unmounted conditions.

if [[ $drive == "external" && -d /media/$(whoami)/parmanode/.bitcoin ]] ; then #drive would have to be mounted to be true 
while true ; do
    if [[ $skip_formatting = "true" ]] ; then export format="false" ; break ; fi
set_terminal

echo -e "
########################################################################################

    It appears there is a Bitcoin data directory on the external drive. Would like 
    to delete that data or leave it?
$red
                            d)          Delete $orange

                            L)          Leave it 

########################################################################################
"
choose "xpmq" ; read choice 
case $choice in
q|Q) exit ;;
p|P) return 1 ;;
m|M) back2main ;;
l|L) export format="false" ; break ;;
d|D) please_wait ; cd ; rm -rf /media/$(whoami)/parmanode/.bitcoin >/dev/null 2>&1 \
    || debug "Error deleting .bitcoin directory. Continuing." ;  break ;;
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
$cyan    
                            $HOME/.bitcoin
$orange
    Would like to delete that data or leave it be (skip) ?

                            d)          Delete

                            b)          Create a back up 

                            3)          $leave_or_use
                                
    Back up will be renamed to$cyan bitcoin_backup0$orange.

########################################################################################
"
choose "xq" ; read choice 

case $choice in
q|Q|quit|Quit|QUIT) 
    exit ;;
3) 
    break ;;
b|B)
    make_backup_dot_bitcoin 
    break
    ;;
d|D)
    cd ; rm -rf $HOME/.bitcoin >/dev/null 2>&1 \
    || debug "Error deleting .bitcoin directory. Continuing."
    break
    ;;
i|I)
    if [[ $drive == "external" ]] ; then 
    announce "Because a symlink of the same name is required, to keep" \
    "this directory, it must be backed up; can't be left as is."
    make_backup_dot_bitcoin
    fi
    break
    ;;
*)  
    invalid
    ;;
esac
done
fi #end checking internal drive for .bitcoin directory

#Remove symlink to drive
if [[ -L "$HOME/.bitcoin" ]] ; then rm $HOME/.bitcoin ; fi      #symlink deleted if it exists


unset skip_formatting format
return 0
}