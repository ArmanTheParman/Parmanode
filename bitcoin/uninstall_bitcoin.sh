#stop bitcoin
#delete .bitcoin (proper drive or symlink, leave hdd alone)
#delete $HOME/parmanode/bitcoin
#delete binary files in /etc/usr/bin (rm *bitcoin*)
#delete bitcoin from install.conf
#hdd setting in parmanode.conf can stay.
#remove bitcoin user and group
#remove prune choice from parmanode.conf

function uninstall_bitcoin {
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

    The bitcoin user and group on the Linux system will be removed.

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

/usr/bin/bitcoin-cli stop 2>/dev/null

rm -rf $HOME/parmanode/bitcoin $HOME/.bitcoin 2>/dev/null #if symlink, symlink deleted. If a real directory, directory removed.
sudo rm /etc/usr/bin/*bitcoin* 2>/dev/null
sudo rm /etc/systemd/system/bitcoin.service 2>/dev/null
delete_line "$HOME/.parmanode/installed.conf" "bitcoin" 2>/dev/null
sudo groupdel bitcoin 2>/dev/null  && sudo userdel bitcoin 2>/dev/null

set_terminal
echo "
########################################################################################

                  Bitcoin Core has been successfully uninstalled

########################################################################################
"
installed_config_remove "bitcoin"
enter_continue
return 0

}
