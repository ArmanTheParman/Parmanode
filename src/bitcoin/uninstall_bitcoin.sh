#stop bitcoin
#delete .bitcoin (proper drive or symlink, leave hdd alone)
#delete $HOME/parmanode/bitcoin
#delete binary files in /usr/local/bin (rm *bitcoin*)
#delete bitcoin from install.conf
#hdd setting in parmanode.conf can stay.
#remove prune choice from parmanode.conf
function uninstall_bitcoin_linux {
clear
while true
do
set_terminal
echo "
########################################################################################

                         Bitcoin Core will be uninstalled


    This will remove the Bitcoin data directory if it exists on the internal 
    drive, but will not modify the external drive (you can wipe the drive 
    yourself manually).

    If a symlink to the external drive exists, it will be delete.

    Configuration files related to Bitcoin will be deleted.

    Saved choices to the Parmanode configuration file will be deleted.

    The bitcoin service file will be deleted.

########################################################################################

Choose (y) or (n) then <enter>.
"
read choice

case $choice in
    y | Y)
        break ;;
    n | N)
        return 0 ;;
    *)
        invalid ;;
esac
done
#Break point. Proceed to uninstall Bitcoin Core.

/usr/local/bin/bitcoin-cli stop 

sudo rm -rf $HOME/parmanode/bitcoin $HOME/.bitcoin 2>/dev/null #if symlink, symlink deleted. If a real directory, directory removed.
sudo rm /usr/local/bin/*bitcoin* 2>/dev/null
sudo rm /etc/systemd/system/bitcoin.service 2>/dev/null
installed_config_remove "bitcoin"
installed_config_remove "bitcoin-start"
installed_config_remove "bitcoin-end"

set_terminal
echo "
########################################################################################

                  Bitcoin Core has been successfully uninstalled

########################################################################################
"
enter_continue

return 0
}

########################################################################################
########################################################################################
########################################################################################
########################################################################################

function uninstall_bitcoin_mac {
clear
while true
do
set_terminal
echo "
########################################################################################

                         Bitcoin Core will be uninstalled
   
        If a symlink to the external drive exists, it will be delete.

        Configuration files related to Bitcoin will be deleted.

        Saved choices to the Parmanode configuration file will be deleted.

        You will be given choices related to the Bitoin Data directory. For
        Parmanode to connect to this data dirctory though, you will need to
        re-install Bitcoin using Parmanode.

########################################################################################

Choose (y) or (n) then <enter>.
"
read choice

case $choice in
    y | Y)
        break ;;
    n | N)
        return 0 ;;
    *)
        invalid ;;
esac
done
#Break point. Proceed to uninstall Bitcoin Core.

#Stop Bitcoin Core first
/usr/local/bin/bitcoin-cli stop 

#Remove Parmanode/bitcoin directory (installation files)
sudo rm -rf $HOME/parmanode/bitcoin /dev/null 2>&1 

#check if data directory on external drive or internal drive
source $HOME/.parmanode/parmanode.conf   # gets drive choice

#check external drive first - mounted and unmounted conditions.

if [[ $drive == "external" && -d /Volumes/parmanode/.bitcoin ]] ; then #drive would have to be mounted to be true 
while true ; do
set_terminal
echo "
########################################################################################

    It appears there is a Bitcoin data directory on the external drive. Would like 
    to delete that data or leave it be (skip) ?

                            d)          delete

                            s)          skip

########################################################################################
"
choose "xq" ; read choice 
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "s" ]] ; then break ; fi
if [[ $choice == "d" ]] ; then 
    cd ; rm -rf /Volumes/parmanode/.bitcoin >/dev/null 2>&1 \
    || debug_point "Error deleting .bitcoin directory. Continuing." ;  break ; fi 
    
invalid #if all above if statements not true, then invalid choice and loop.
done
fi #end checking external drive for data directory

if [[ $drive == "external" && ! -d /Volumes/parmanode/.bitcoin ]] ; then        #potentially unmounted
    set_terminal ; echo "
########################################################################################

    Your settings indicate that you use an external drive for Bitcoin Core with
    the Parmanode software, however, a Bitcoin data directory has not been detected
    at the expected location.

    The directory may not exist, or the drive may not be connected.

    There is nothing you need to do to continue uninstalling Bitcoin, however, you
    will need to manually delete the data if you want to get rid of it. Or you
    can just format the drive by installing Bitcoin again with Parmanode.

########################################################################################
"
enter_continue
fi # ends response to drive=external but no directory found 

#check internal drive for data directory existance 
if [[ -d $HOME/.bitcoin && ! -L $HOME/.bitcoin ]] ; then    #checks for directory, and not a symlink
while true ; do
echo "
########################################################################################

    It appears there is a Bitcoin data directory on the internal drive at:
    
                            $HOME/.bitcoin

    Would like to delete that data or leave it be (skip) ?

                            d)          delete

                            s)          skip

########################################################################################
"
choose "xq" ; read choice 
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "s" ]] ; then break ; fi
if [[ $choice == "d" ]] ; then 
    cd ; rm -rf $HOME/.bitcoin >/dev/null 2>&1 \
    || debug_point "Error deleting .bitcoin directory. Continuing." ; break ; fi 
    
invalid #if all above if statements not true, then invalid choice and loop.
done
fi #end checking internal drive for .bitoin directory

#Check for Bitcoin data directory in default Mac location
if [[ -d "$HOME/Library/"Application Support"/Bitcoin/" ]] ; then 
    set_terminal ; echo "
########################################################################################
    
    By the way, even though your Parmanode settings indicate you're wishing to use 
    an external drive for the Bitcoin data directory, an internal drive directory
    containing a Bitcoin data directory has been found in :

            $HOME/Library/Application Support/Bitcoin
    
    This is just for your information. Parmanode won't touch it.

########################################################################################
"
enter_continue 
fi #end checking internal drive for data directory at defaul mac location

#Remove symlink to drive
if [[ -L "$HOME/.bitcoin" ]] 2>/dev/null ; then rm $HOME/.bitcoin ; fi      #symlink deleted if it exists

#Remove symlink from default Bitcoin directory to $HOME/.bitcoin
if [[ -L "~/Library/"Application Support"/Bitcoin" ]] ; then
    rm "$HOME/Library/"Application Support"/Bitcoin" ; fi 

# Remove binaries
sudo rm /usr/local/bin/bitcoin* 2>/dev/null
installed_config_remove "bitcoin"
installed_config_remove "bitcoin-start"
installed_config_remove "bitcoin-end"

set_terminal
echo "
########################################################################################

                  Bitcoin Core has been successfully uninstalled

########################################################################################
"
enter_continue

return 0
}
