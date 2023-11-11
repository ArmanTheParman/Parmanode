function menu_lnd {
unset wallet


function lnd_menu_loop {
export lnd_version=$(lncli --version | cut -d - -f 1 | cut -d ' ' -f 3) >/dev/null 
# To check if wallet is created/loaded
if lncli walletbalance >/dev/null 2>&1 ; then 
wallet="WALLET CREATED & UNLOCKED =$green TRUE$orange" 
else
wallet="WALLET CREATED & UNLOCKED =$red FALSE$orange" 
fi 

# To print tor details in menu
if grep -q "tor.active=1" < $HOME/.lnd/lnd.conf >/dev/null 2>&1 ; then lndtor=Enabled ; else lndtor=Disabled ; fi

if grep -q "; tor.skip-proxy-for-clearnet-targets=true" < $HOME/.lnd/lnd.conf
then torhybrid=Disabled 
elif grep -q "tor.skip-proxy-for-clearnet-targets=true" < $HOME/.lnd/lnd.conf
then torhybrid=Enabled
else torhybrid=Disabled 
fi

#get onion address if it exists...
unset lnd_onion
lncli getinfo >/$dp/lndinfo.log 2>/dev/null 

if grep -q onion: <$dp/lndinfo.log ; then
lnd_onion="
$bright_blue
Tor Onion URI:

$(cat $dp/lndinfo.log | grep onion: | cut -d \" -f 2)
$orange"
fi

if cat $dp/lndinfo.log | grep 973 | grep -v onion >/dev/null 2>&1 ; then 
clearnetURI="
$yellow
Clearnet URI:

$(cat $dp/lndinfo.log | grep 973 | grep -v onion | cut -d \" -f 2)
$orange"
fi

set_terminal_custom 55 ; echo -e "
########################################################################################$cyan
                                LND Menu${orange} - v$lnd_version                               
########################################################################################

"
if ps -x | grep lnd | grep bin >/dev/null 2>&1 ; then echo -e "
                   LND IS$green RUNNING$orange -- SEE LOG MENU FOR PROGRESS "
else
echo -e "
                   LND IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN"
fi
echo -e "
                        $wallet 



      (i)              Important info

      (s)              Start LND 

      (st)             Stop LND

      (rs)             Restart LND

      (log)            Inspect LND logs

      (lc)             Inspect and edit lnd.conf file 

      (pw)             Change LND password 
       
      (scb)            Static Channel Backup 

      (t)              Enable/disable TOR                     Currently: $cyan$lndtor$orange

      (th)             Enable/disable TOR/Clearnet hybrid.    Currently: $cyan$torhybrid$orange

      (w)              ... wallet options

      (mm)             ... more options
$lnd_onion $clearnetURI
$red                                                              Refreshing every 5 seconds $orange
########################################################################################
"
choose "xpmq"
}
while true ; do # case loop
unset choice
while [[ -z $choice ]] ; do 
read -t 5 choice 
lnd_menu_loop 
done

set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
i|I|info|Info) lnd_info ; continue ;;
s|S|start|START|Start) start_lnd  ; continue ;;
st|ST|St|stop|STOP|Stop) stop_lnd ; continue ;; 
rs|RS|Rs|restart|RESTART|Restart) restart_lnd ; continue ;;

t|T|tor)
if ! grep -q "message added by Parmanode" < $HOME/.lnd/lnd.conf ; then
announce "Parmanode has detected an older version of Parmanode has created
    your Lightninbg lnd.conf file. The Tor configuration adjustments may
    not work because of this. It is recommended to reinstall LND using
    Parmanode before attempting to enable Tor."
continue
fi

if [[ $lndtor == Disabled ]] ; then
lnd_enable_tor
else
lnd_disable_tor
fi

;;

th)
if ! grep -q "message added by Parmanode" < $HOME/.lnd/lnd.conf ; then
announce "Parmanode has detected an older version of Parmanode has created
    your Lightninbg lnd.conf file. The Tor configuration adjustments may
    not work because of this. It is recommended to reinstall LND using
    Parmanode before attempting to enable Tor."
continue
fi

if [[ $torhybrid == Disabled ]] ; then
lnd_enable_hybrid
else
lnd_disable_hybrid
fi

;;

log|LOG|Log)
log_counter
if [[ $log_count -le 10 ]] ; then
echo "
########################################################################################
    
    This will show the systemd output for LND in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
fi
set_terminal_wider
sudo journalctl -fxu lnd.service 
journal_PID=$!
trap "kill $journal_PID" SIGINT #condition added to memory #changed to double quotes for a user experiencing
#complete exiting of the program with control-c. May adjust for all occurrances later.
wait $journal_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
please_wait
;;


lc|LC|conf|CONF|Conf)
echo -e "
########################################################################################
    
        This will run Nano text editor to edit lnd.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

$green
	  *** ANY CHANGES WILL ONLY BE APPLIED ONCE YOU RESTART LND ***
$orange
########################################################################################
"
enter_continue
nano $HOME/.lnd/lnd.conf 
please_wait
continue ;;

pw|Pw|PW|password|PASSWORD|Password)
echo "
########################################################################################

    If you already have a lightning wallet loaded, changing your password will make 
    you lose access to it. Not a disaster, you just have to change the password back 
    to the original. Even though passwords in this context are not passphrases, they 
    are just as important. A password locks the wallet, whereas a passphrase 
    contributes to the entropy of the wallet.

    If your intentions are to delete the wallet and start fresh, and create a new
    password, then delete the wallet first, then change the password, then create
    your new wallet.

    Note, deleting a wallet with bitcoin in it does not delete the bitcoin. You can
    recover the wallet as long as you have a copy of the seed phrase.

    Also note that$green funds in lightning channels NOT recoverable by the
    seed phrase$orange - those funds are in share 2 f 2 multisignature addresses, that are
    returned to your wallet when the channel is closed. To keep access to those
    funds in a channel, you need to keep your lightning node running, or restore
    your lightning node with both the seed AND the channel back up file.

########################################################################################
"
enter_continue
set_lnd_password
;;


scb|SCB|Scb) 
scb ;;

w)
menu_lnd_wallet 
;;

mm)
menu_lnd_more ;;

*) invalid ;;

esac ; done

#option to turn tor on/off

#lncli getinfo

}