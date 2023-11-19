function lnd_menu_loop {
export lnd_version=$(lncli --version | cut -d - -f 1 | cut -d ' ' -f 3) >/dev/null 
# To check if wallet is created/loaded
if lncli walletbalance >/dev/null 2>&1 ; then 
wallet="WALLET CREATED & UNLOCKED =$green TRUE$orange" 
else
wallet="WALLET CREATED & UNLOCKED =$red FALSE $yellow... sometimes just wait a 
                                                              minute and it'll unlock$orange" 
fi 

# To print tor details in menu
unset lndtor torhybrid
if grep -q "tor.skip-proxy-for-clearnet-targets" < $HOME/.lnd/lnd.conf ; then
    lndtor=Enabled
else
    lndtor=Disabled
fi

if grep -q "tor.skip-proxy-for-clearnet-targets=true" < $HOME/.lnd/lnd.conf 
then 
    torhybrid=Enabled
else 
    torhybrid=Disabled 
fi

#get onion address if it exists...
unset lnd_onion clearnetURI
lncli getinfo >/$dp/lndinfo.log 2>/dev/null 

if grep -q onion: <$dp/lndinfo.log ; then
lnd_onion="
$bright_blue
Tor Onion URI:

$(cat $dp/lndinfo.log | grep onion: | cut -d \" -f 2) $orange"
fi

if [[ $lndtor == "Enabled" && -z $lnd_onion ]] ; then
lnd_onion="
$bright_blue
LND onion address can take a few minutes to appear when first enabled.
Or much longer if Bitcoin hasn't finished sync'ing yet.$orange"

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

      (t)              Enable/disable TOR                  Currently: $lndtor$orange

      (th)             Enable/disable Clearnet with Tor    Currently: $torhybrid$orange

      (w)              ... wallet options

      (mm)             ... more options
$lnd_onion $clearnetURI
$red                                                              Refreshing every 5 seconds $orange
########################################################################################
"
choose "xpmq"
} #function definition ends

########################################################################################

function menu_lnd {
set_terminal
unset wallet
please_wait

while true ; do # case loop
unset choice
while [[ -z $choice ]] ; do 
lnd_menu_loop # Calls menu function to loop
read -t 5 choice 
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
announce "Parmanode has detected irregularities in your lnd.conf file
    possibly due to an older version of Parmanode having created it. 
    
    The Tor configuration adjustments may not work because of this. 
    It is recommended to reinstall LND using Parmanode before attempting 
    to enable Tor."
continue
fi

if [[ $lndtor == Disabled ]] ; then
lnd_tor only
else
lnd_tor off
fi
;;


th)
if ! grep -q "message added by Parmanode" < $HOME/.lnd/lnd.conf ; then
announce "Parmanode has detected irregularities in your lnd.conf file
    possibly due to an older version of Parmanode having created it. 
    
    The Tor configuration adjustments may not work because of this. 
    It is recommended to reinstall LND using Parmanode before attempting 
    to enable Tor."
continue
fi

if [[ $torhybrid == Disabled ]] ; then
lnd_tor both
else
lnd_tor only
fi

;;
prv|PRV|Prv)
if grep -qE '^externalip' < $HOME/.lnd/lnd.conf ; then
fully_tor_only
else
reverse_fully_tor_only
fi
;;


log|LOG|Log)
log_counter
#Added lndlogfirsttime=true to patch3
if grep -q lndlogfirsttime < $dp/parmanode.conf ; then
set_terminal ; echo -e "$pink
########################################################################################

    This function sometimes creates and error causing the Parmanode program to exit
    back to terminal, or closes the terminal. To fix this, Parmanode will detect the 
    behviour and if there is a failure, it will know and modify the code for your
    next attempt, which should hopefully be successful. Just run Parmanode again
    should it exit, it won't hurt it.
   
    There's a reasonable chance it will work anyway, and this prompt won't bother you
    again.
$green
    Have a nice day.
$pink
########################################################################################
"
enter_continue
delete_line "$dp/parmanode.conf" "lndlogfirsttime"
fi

if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    This will show the systemd output for LND in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi

#There's a problem here. In some systems the "&" for putting a process in the background
# causes control-c to quit to terminal, and in others it is NEEDED otherwise the process cant be terminated.
#I will catch any success and set that for next time. It's a bit convoluted...

source $dp/parmanode.conf >/dev/null 2>&1
if [[ -z $lnd_logtrap_needs_ampersand ]] ; then #if no variable, add it, run commands, and when successful, remove it so it runs properly next time
parmanode_conf_add "lnd_logtrap_needs_ampersand=true"
set_terminal_wider
sudo journalctl -fxu lnd.service 
journal_PID=$!
trap "kill -9 $journal_PID >/dev/null 2>&1 ; clear" SIGINT #condition added to memory #changed to double quotes for a user experiencing
#complete exiting of the program with control-c. May adjust for all occurrances later.
wait $journal_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
parmanode_conf_remove "lnd_logtrap_needs_ampersand"
please_wait

else # if there is a variable, then it must have failed last time because the commands didn't reach the removal of the variable. Run this instead.
# This version has an ampersand
set_terminal_wider
sudo journalctl -fxu lnd.service &
journal_PID=$!
trap "kill -9 $journal_PID >/dev/null 2>&1 ; clear" SIGINT #condition added to memory #changed to double quotes for a user experiencing
#complete exiting of the program with control-c. May adjust for all occurrances later.
wait $journal_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
please_wait
fi
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


function fully_tor_only {
# check tor enabled - or do it.
# check hybrid off - or do it.
# comment out tlsextrip
# comment out tlsextradomain
# comment out externalip 

lnd_tor only skipsuccess norestartlnd

sed -i '/^tlsextraip/s/^/; /' $file
sed -i '/^tlsextradomain/s/^/; /' $file
sed -i '/^externalip/s/^/; /' $file

restart_lnd

success "LND" "being made to run by Tor-only"
}

function reverse_fully_tor_only {

local file=$HOME/.lnd/lnd.conf

if grep -q tlsextraip < $file ; then
if [[ $(cat $file | grep tlsextraip | wc -l) == 1 ]] ; then #if string found only once
sed -i '/^; tlsextraip/s/^..//' $file
else
announce "Unexpectedly found 'tlsextraip' more than once in lnd.conf.
    Abandoning automated modification to avoid errors."
return 1
fi
fi


if grep -q externalip < $file ; then
if [[ $(cat $file | grep externalip | wc -l) == 1 ]] ; then #if string found only once
sed -i '/^; externalip/s/^..//' $file
else
announce "Unexpectedly found 'externalip' more than once in lnd.conf.
    Abandoning automated modification to avoid errors."
return 1
fi
fi

delete_line "$file" "tlsextradomain=mydomain.com" 

if grep -q tlsextradomain < $file ; then
if [[ $(cat $file | grep tlsextradomain | wc -l) == 1 ]] ; then #if string found only once
sed -i '/^; tlsextradomain/s/^..//' $file
else
announce "Unexpectedly found 'tlsextradomain' more than once in lnd.conf.
    Abandoning automated modification to avoid errors."
return 1
fi
fi

if [[ $norestartlnd != true ]] ; then
restart_lnd
fi

if [[ $1 != skipsuccess ]] ; then
success "LND" "having Tor-only reversed"
fi
}