function menu_lnd_wallet {
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
echo -e "

      (ul)             Unlock Wallet

      (wb)             Wallet balance

      (cb)             Channels' balance

      (au)             Enable auto-unlock wallet (for easy restarts of LND)

      (delete)         Delete existing wallet and its files (macaroons, channel.db)

      (create)         Create an LND wallet (or restore a wallet with seed)

########################################################################################
"
choose "xpmq" ; read choice
case $choice in

m|M) back2main ;;
q|Q) exit ;;
p|P) return 1 ;;

au|AU|Au)
lnd_wallet_unlock_password
;;

create|CREATE|Create)
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create
# password file and needs new wallet to do so.

#might be redundant...
lncli unlock 2>/dev/null
return 0 ;;

ul|UL|Ul|unlock|Unlock) 
lncli unlock
return 0
;;

wb|WB)
wallet_balance
;;

delete|DELETE|Delete) 
delete_wallet_lnd
return 0
;;

*) invalid
;;
esac
done

}


function wallet_balance {
set_terminal
if [[ $lndrunning != "true" || $lndwallet != "unlocked" ]] ; then 
local_balance="Unknown, LND not running or wallet locked"
remote_balance="Unknown, LND not running or wallet locked"
fi
lncli channelbalance > /tmp/.channelbalance
local_balance=$(lncli channelbalance | grep -n1 "local_balance" | head -n3 | tail -n1 | cut -d \" -f 4) >/dev/null 2>&1
remote_balance=$(lncli channelbalance | grep -n1 "remote_balance" | head -n3 | tail -n1 | cut -d \" -f 4) >/dev/null 2>&1
channel_size_total=$((local_balance + remote_balance))
lncli walletbalance >/tmp/.walletbalance
onchain_balance=$(lncli walletbalance | head -n2 | tail -n1 | cut -d \" -f 4) >/dev/null 2>&1

set_terminal ; echo -e "
########################################################################################
$cyan
                              Lightning Node Balance
$orange
    On chain balance:            $onchain_balance sats

    Total local balance:         $local_balance sats$green (Your money) $orange

    Total remote balance:        $remote_balance sats$red (Not your money)  $orange

    Total of channel capcity:    $channel_size_total 

########################################################################################
"
enter_continue
return 0
}