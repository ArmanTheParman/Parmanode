function menu_bitcoin_core {
while true
do

echo "
############################################################################
                            Bitcoin Core Menu                               
############################################################################

                1) How to connect your wallet

                2) Start / Stop Bitcoind

                3) Access Bitcoin blockchain information 
                  (via bitcoin-cli command)

                4) Inspect Bitcoin debug.log file.

                5) Inspect and edit bitcoin.conf file 

                6) Access parmanode_bitcoin_container terminal

                7) Backup/Restore data directory

############################################################################


Please choose 1-7, p for previous, q to quit, then <enter>.
"

read choice

clear

case $choice in
1)
echo "

To connect your wallet, you need to first wait for the Bitcoin blockchain to finish 
syncing. You can inspect the debug.log file (access from Parmanode Bitcoin Core menu) to
check its progress in real time. Any errors with Bitcoin Core will show up here as well.

To connect Sparrow Bitcoin Wallet: 

    -   Unfortunately, for now, this wallet needs to be on the same computer at the 
        Parmanode software.
    -   In the Sparrow Server settings, use 127.0.0.1 as the IP address and 8332 
        as the port. 
    -   Then change the connection method from \"Default\" to \"User/Pass\". 
    -   The user is parman; the password is also parman. The user/password can be 
        changed for extra security by editing the bitcoin.conf file.
    -   Once you have Fulcrum (an Electrum server) installed on Parmanode, then 
        Sparrow will be able to connect to it instead of directly to Bitcoin Core. If
        this is enabled, you are not as limited, and can connect from another 
        computer. Fulcrum will be available for parmanode in later versions.

To connect Electrum Desktop Wallet:

    -   Not available yet. Please wait for a Parmanode update with Fulcrum Server, coming
        soon.

To connect Specter Desktop Wallet:

    -   Newer versions of Specter now allow you to connect not only to Bitcoin Core
        directly, but to an Electrum Server as well. That option will be available in 
        later versions of Parmanode when Fulcrum (Electrum Server) is added.
    -   For now, choose \"Bitcoin Core Connection\".
    -   You need to name the connection to proceed.
    -   Enter the username/password as parman/parman.
    -   Leave the host as http://localhost. If that doesn't work, try http://127.0.0.1
    -   Click \"Connect\"

"
;;

2)
    while true
    do
    clear
    echo "
    
    You can stop or start the bitcoin daemon (bitcoind) that exists in the docker container.
    The container needs to be running to access bitcoind.

    1) Start bitcoind

    2) Stop bitcoind 

    Choose 1, 2, p for previous, or q to quit, then <enter>."

    read choice

    case $choice in
    1)
    clear
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoind -datadir=/home/parman/.bitcoin/ -conf=/home/parman/bitcoin/bitcoin.conf
    sudo docker exec parmanode_bitcoin_container tail -n 4 /home/parman/.bitcoin/debug.log
    ;;
    2)
    clear
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli stop
    sudo docker exec parmanode_bitcoin_container tail -n 4 /home/parman/.bitcoin/debug.log
    ;;
    p)
    true
    ;;
    q | Q | quit)
    exit 0
    ;;
    *)
    echo "Invalid choice. Hit <enter> to try again." ; read
    ;;
    esac
    done
# no return here intentional.
;;

3)
clear
menu_bitcoin-cli
return 0
;;

4)
clear
echo "
This will show the bitcoin debug.log file in real time as it populates.
You can hit <control>-c to make it stop.

Hit <enter> to proceed.
"
read
sudo docker exec parmanode_bitcoin_container tail -f /home/parman/.bitcoin/debug.log
echo "

Hit <enter> to return to previous menu."
read
clear
;;

5)
clear
echo "

Note, the bitcoin.conf file for Parmanode is not in the default 
Bitcoin Core location.

It is kept at /home/parman/bitcoin/bitcoin.conf
not /home/parman/.bitcoin/bitcoin.conf (subtle yet important difference)

You can use Nano text editor, or Vim to edit bitcoin.conf.

Enter n for nano, v for vim, p for previous, or q to quit, then <enter>."

read choice

if [[ $choice == "v" ]] ; then editor="vim" ; else editor="nano" ; fi

sudo docker exec parmanode_bitcoin_container $editor /home/parman/bitcoin/bitcoin.conf

return 0;
;;

6)
clear
echo "
Be careful here, you are going to access the terminal of the container that's
running bitcoind.

Type "exit" to leave the container.

Hit <enter> to continue.
"
read

sudo docker exec -it parmanode_bitcoin_container /bin/bash

return 0;
;;

7)
clear

echo "

If you have a spare drive, it is a good idea to make a copy of the bitcoin_data 
directory from time to time. This could save you a long time in waiting if 
you ever experienced data corruption and needed to resync the blockchain.

It is VITAL that you stop bitcoind before copying the data, otherwise it will not
work correctly when it comes time to use the backed up data. You have been warned.
It's safe to not just stop the container, but to stop bitcoind while the container
is running, then stop the container.

You can copy the entire bitcoin_data directory.
You could also just copy the chainstate directory, which is a lot smaller, and this
could be all that you need should there be a chainstate error one day. This directory
is smaller and it's more feasible to back it up more frequently. I would suugest 
doing it every 100,000 blocks or so, in addition to have a full copy backed up if
you have drive space somewhere.

To copy the data, use your usual computer skills to copy files. The directory is
either on /Volumes/parmanode/bitcoin_data (ie the external hard drive) or 
$HOME/parmanode/bitcoin_data (ie the internal drive). 

Hit <enter> to return to the menu.
"

;;
p)
return 0
;;

q | Q | quit)
;;
*)
echo "Invalid choice. Hit <enter> to try again." ; read
exit 0
;;

esac

done
}