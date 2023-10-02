function remove_bitcoin_directories_linux {

#Remove Parmanode/bitcoin directory (installation files)
rm -rf $HOME/parmanode/bitcoin >/dev/null 2>&1 

if [[ $installer == parmanodl ]] ; then return 0 ; fi 

#check if data directory on external drive or internal drive
source $HOME/.parmanode/parmanode.conf   # gets drive choice

#check external drive first - mounted and unmounted conditions.

if [[ $drive == "external" && -d /media/$(whoami)/parmanode/.bitcoin ]] ; then #drive would have to be mounted to be true 
while true ; do
    if [[ $skip_formatting = "true" ]] ; then export format="false" ; break ; fi
set_terminal

echo "
########################################################################################

    It appears there is a Bitcoin data directory on the external drive. Would like 
    to delete that data or leave it?

                            d)          Delete

                            l)          Leave it 

########################################################################################
"
choose "xq" ; read choice 
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "l" ]] ; then export format="false" ; break ; fi
if [[ $choice == "d" ]] ; then 
    please_wait
    cd ; rm -rf /media/$(whoami)/parmanode/.bitcoin >/dev/null 2>&1 \
    || debug "Error deleting .bitcoin directory. Continuing." ;  break ; fi 
    
invalid #if all above if statements not true, then invalid choice and loop.
done
fi #end checking external drive for data directory

#check internal drive for data directory existance 
if [[ -d $HOME/.bitcoin && ! -L $HOME/.bitcoin ]] ; then    #checks for directory, and not a symlink
while true ; do
set_terminal ; echo "
########################################################################################

    It appears there is a Bitcoin data directory on the internal drive at:
    
                            $HOME/.bitcoin

    Would like to delete that data or leave it be (skip) ?

                            d)          Delete

                            b)          Back-up then delete 

                            i)          Ignore and leave it
                                
    If backing up, the directory will be renamed to $HOME/.bitcoin_backup0 

########################################################################################
"
choose "xq" ; read choice 

case $choice in
q|Q|quit|Quit|QUIT) 
    exit ;;
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