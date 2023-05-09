function menu_lnd {
while true ; do set_terminal ; echo "
########################################################################################
                                     LND Menu                               
########################################################################################

      (i)              Important info

      (start)          Start LND 

      (stop)           Stop LND

      (restart)        Restart LND
	    
      (log)            Inspect LND logs

      (conf)           Inspect and edit lnd.conf file 

      (password)       Change LND password 
       
      (alias)          Change LND alias

      (create)         Create an LND wallet (or restore a wallet with seed)

      (ul)             Unlock Wallet

      (scb)            Static Channel Backup 

      (delete)         Delete existing wallet and its files (macaroons, channel.db)

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;
i|I|info|Info) lnd_info ;;
start|START|Start) sudo systemctl start lnd.service ;;
stop|STOP|Stop) sudo systemctl stop lnd.service ;; 
restart|RESTART|Restart) sudo systemctl restart lnd.service ;;

log|LOG|Log)
echo "
########################################################################################
    
    This will show the systemd output for LND in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
set_terminal_wider
sudo journalctl -fxu lnd.service 
journal_PID=$!
trap 'kill $journal_PID' SIGINT #condition added to memory
wait $journal_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal
;;


conf|CONF|Conf)
echo "
########################################################################################
    
        This will run Nano text editor to edit lnd.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.


	  *** ANY CHANGES WILL ONLY BE APPLIED ONCE YOU RESTART LND ***

########################################################################################
"
enter_continue
nano $HOME/.lnd/lnd.conf ;;

password|PASSWORD|Password)
echo "
########################################################################################

    If you already have a lightning wallet loaded, changing your password will make 
    you lose access to it. Not a disaster, you just have to change the password back 
    to the original. Even though passwords in this context are not passphrases, they 
    are just as important. A password locks the wallet, whereas a passphrase 
    contributes to the entropy of the wallet.

    If your intensions are to delete the wallet and start fresh, and create a new
    password, then delete the wallet first, then change the password, then create
    your new wallet.

    Note, deleting a wallet with bitcoin in it does not delete the bitcoin. You can
    recover the wallet as long as you have a copy of the seed phrase.

    Also note that funds in lightning channels no longer are recoverable by the
    seed phrase - those funds are in share 2 f 2 multisignature addresses, that are
    returned to your wallet when the channel is closed. To keep access to those
    funds in a channel, you need to keep your lightning node running, or restore
    your lightning node with bothe the seed AND the channel back up file. I'll 
    add more on that in later editions of Parmanode. 

########################################################################################
"
enter_continue
set_lnd_password
;;


alias|ALIAS|Alias) 
set_lnd_alias ;;

create|CREATE|Create) create_wallet ;;

ul|UL|Ul|unlock|Unlock) 
lncli unlock
;;

scb|SCB|Scb) scb ;;

delete|DELETE|Delete) delete_wallet ;;

*) invalid ;;

esac ; done

#option to turn tor on/off

#lncli getinfo

}