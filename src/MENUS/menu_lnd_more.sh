function menu_lnd_more {

export lnd_version=$(lncli --version | cut -d - -f 1 | cut -d ' ' -f 3) >/dev/null

while true ; do set_terminal ; echo -e "
########################################################################################$cyan
                                LND Menu${orange} - v$lnd_version                               
########################################################################################

"
if ps -x | grep lnd | grep bin >/dev/null 2>&1 ; then echo "
                   LND IS RUNNING -- SEE LOG MENU FOR PROGRESS "
else
echo "
                   LND IS NOT RUNNING -- CHOOSE \"start\" TO RUN"
fi
echo "
      (pw)             Change LND password 

      (ex)             Expose your LND node to other nodes

      (reset)          Reset lnd.conf to default

      (alias)          Change LND alias

      (port)           Change CLEARNET port. Current port is $lnd_port 

      (mm)             Macaroon information (private and sensitive)
"
if [[ $lnd_version != "v0.17.0" ]] ; then echo -e " 
$red      (update)         Update LND to version 0.17.0 $orange
      "
fi
echo "########################################################################################
"

choose "xpmq" ; read choice
case $choice in
m|M) back2main ;;
q|Q) exit ;;
p|P) 
clear
please_wait ; return 1 ;;

pw|Pw|PW|password|PASSWORD|Password)
echo -e "
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

    Also note that$green funds in lightning channels are NOT recoverable by the
    seed phrase$orange - those funds are shared in 2-of-2 multisignature addresses, that are
    returned to your wallet when the channel is closed. To keep access to those
    funds in a channel, you need to keep your lightning node running, or restore
    your lightning node with both the seed AND the channel backup file.

########################################################################################
"
enter_continue
lnd_wallet_unlock_password
;;

ex|Ex|EX)
expose_LND
;;

alias|ALIAS|Alias) 
set_lnd_alias ;;

port|Port)
change_lnd_port
;;

update|UPDATE|Update)
update_lnd
;;

reset|RESET|Reset)
reset_lnd_conf
;;

mm|MM|Mm)
lnd_macaroons
;;

*)
invalid ;;
esac
done
} 

function reset_lnd_conf {
local file="$HOME/.lnd/lnd.conf"
set_terminal
rm $file
make_lnd_conf
restart_lnd
}