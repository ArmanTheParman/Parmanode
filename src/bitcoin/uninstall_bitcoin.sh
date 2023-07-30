#stop bitcoin
#delete .bitcoin (proper drive or symlink, leave hdd alone)
#delete $HOME/parmanode/bitcoin
#delete binary files in /usr/local/bin (rm *bitcoin*)
#delete bitcoin from install.conf
#hdd setting in parmanode.conf can stay.
#remove prune choice from parmanode.conf
function uninstall_bitcoin {
clear
while true
do
set_terminal
echo "
########################################################################################

                         Bitcoin Core will be uninstalled


    This will give you the option to remove or keep the Bitcoin data directory if 
    it exists on the internal or external drive.  If a symlink to the external drive 
    exists, it will be delete. Configuration files related to Bitcoin will be deleted.  
    Saved choices to the Parmanode configuration file will be deleted.  
    
    The Bitcoin service file will be deleted (for Linux users only).

    If you choose to keep the Bitcoin data directory, Parmanode will not be able to 
    connect to it because the symlinks would be delted. You need to install Bitcoin
    again and choose to keep the data directory found.

    UNINSTALL BITCOIN?

########################################################################################

Choose (y) or (n) then <enter>.
"
read choice

case $choice in
    y|Y)
        break ;;
    n|N)
        return 0 ;;
    q|Q|Quit|quit)
        exit 0 ;;
    *)
        invalid ;;
esac
done
#Break point. Proceed to uninstall Bitcoin Core.

/usr/local/bin/bitcoin-cli stop >/dev/null 2>&1 #binaries are in the same location, mac or linux

#remove bitcoin directories and symlinks
if [[ $OS == "Linux" ]] ; then remove_bitcoin_directories_linux ; fi
if [[ $OS == "Mac" ]] ; then remove_bitcoin_directories_mac ; fi

# Remove binaries
sudo rm /usr/local/bin/bitcoin* 2>/dev/null

#Modify config file
installed_config_remove "bitcoin"
installed_config_remove "bitcoin-start"
installed_config_remove "bitcoin-end"

#Remove service file for Linux only
sudo rm /etc/systemd/system/bitcoin.service 1>/dev/null 2>&1

set_terminal
echo "
########################################################################################

                  Bitcoin Core has been successfully uninstalled

########################################################################################
"
enter_continue

return 0
}
