/unction menu_bitcoin_core {
while true
do
set_terminal
echo "
########################################################################################
                                 Bitcoin Core Menu                               
########################################################################################


                 start)    Start Bitcoind

                 stop)     Start Bitcoind 

                 c)        How to connect your wallet

                 n)        Access Bitcoin node information (bitcoin-cli)
                            
                 d)        Inspect Bitcoin debug.log file

                 bc)       Inspect and edit bitcoin.conf file 

                 dd)       Backup/Restore data directory (Instructions only)

                 pw)       Set, remove, or change RPC user/pass


########################################################################################
"
choose "xpq" ; exit_choice ; set_terminal

case $choice in

start|START|Start)
echo "
########################################################################################
    
    Bitcoind should have been configured to restart automatically if your 
    computer restarts. However, the restart may fail, which sometimes happens if
    you have an external drive.

########################################################################################
"
enter_continue
run_bitcoind
continue
;;

stop|STOP|Stop)
sudo systemctl stop bitcoind.service
continue 
;;

c|C)
connect_wallet_info
continue
;;

n|N)
menu_bitcoin-cli
continue
;;

d|D)
echo "
########################################################################################
    
    This will show the bitcoin debug.log file in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
set_terminal_wider
tail -f $HOME/.bitcoin/debug.log &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal;
continue ;;


bc|BC)
echo "
########################################################################################
    
        This will run Nano text editor to edit bitcoin.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	Any changes will only be applied once you restart Bitcoin.

########################################################################################
"
enter_continue
nano $HOME/.bitcoin/bitcoin.conf
continue
;;


dd|DD)
echo "
########################################################################################
    
    If you have a spare drive, it is a good idea to make a copy of the bitcoin data 
    directory from time to time. This could save you waiting a long time if you were 
    ever to experience data corruption and needed to resync the blockchain.

    It is VITAL that you stop bitcoind before copying the data, otherwise it will not 
    work correctly when it comes time to use the backed up data, and it's likely the 
    directory will become corrupted. You have been warned.

    You can copy the entire bitcoin_data directory.

    You could also just copy the chainstate directory, which is a lot smaller, and 
    this could be all that you need should there be a chainstate error one day. This 
    directory is smaller and it's more feasible to back it up frequently. I would 
    suggest doing it every 100,000 blocks or so, in addition to having a full copy 
    backed up if you have drive space somewhere.

    To copy the data, use your usual computer skills to copy files. The directory is 
    located either on the internal drive:

                        $HOME/.bitcoin

    or external drive:

                        /media/$(whoami)/parmanode/.bitcoin 

    Note that if you have an external drive for Parmanode, the internal directory 
    $HOME/.bitcoin is actually a symlink to the external 
    directory.

########################################################################################
"
enter_continue
continue
;;

pw)
set_rpc_authentication
continue
;;

p)
return 1
;;

*)
invalid
continue
;;

esac

done
return 0
}


function set_rpc_authentication {
while true ; do
echo "
########################################################################################

                               RPC Authentication

    Remote Procedure Call (RPC) is how wallet applications connect to Bitcoin
    Core. The default authentication method is a cookie file stored in the Bitcoin
    data directory. Some software might prefer the alternative way which is with
    a username and password. If you require this, you can select that here (up) or
    manually edit the bitcoin.conf file yourself.

                         (up) set a username and password

			 (c)  use cookie (default setting)

########################################################################################

"
choose "xpq" ; exit_choice ; set_terminal

case $choice in
	up|UP|Up|uP)
		echo "Please enter an RPC username:
	       	" 
		read rpcuser
		
		while true ; do
		set_terminal
		echo "Please enter an PRC password:
	       	" 
		read rpcpassword
		echo "Please repeat the password:
	       	"
		read rpcpassword2
		
		if [[ $rpcpassword != $rpcpassword2 ]] ; then
		       echo "Passwords do not match. Try again.
		       "
                       continue
		else
	               break
		fi

		done

                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser"
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword"
		echo "rpcuser=$rpcuser" >> $HOME/.bitcoin/bitcoin.conf
		echo "rpcpassword=$rpcpassword" >> $HOME/.bitcoin/bitcoin.conf

		break
		;;
	c)
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser"
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword"
		;;	

	*)
		invalid
		continue
		;;	
esac

done
return 0
}
