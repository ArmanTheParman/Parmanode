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

cb|CB)
channel_balance
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
                              Lightning Node Wallet Balance
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

function channel_balance {
set_terminal
if [[ $lndrunning != "true" || $lndwallet != "unlocked" ]] ; then 
local_balance="Unknown, LND not running or wallet locked"
remote_balance="Unknown, LND not running or wallet locked"
fi

cb_json=$(lncli channelbalance)

# Parse specific values
balance=$(echo "$cb_json" | jq -r '.balance')
pending_open_balance_sat=$(echo "$cb_json" | jq -r '.pending_open_balance')
pending_open_balance_msat=$(echo "$cb_json" | jq -r '.pending_open_balance')
local_balance_sat=$(echo "$cb_json" | jq -r '.local_balance.sat')
local_balance_msat=$(echo "$cb_json" | jq -r '.local_balance.msat')
remote_balance_sat=$(echo "$cb_json" | jq -r '.remote_balance.sat')
remote_balance_msat=$(echo "$cb_json" | jq -r '.remote_balance.msat')
unsettled_local_balance_sat=$(echo "$cb_json" | jq -r '.unsettled_local_balance.sat')
unsettled_local_balance_msat=$(echo "$cb_json" | jq -r '.unsettled_local_balance.msat')
unsettled_remote_balance_sat=$(echo "$cb_json" | jq -r '.unsettled_remote_balance.sat')
unsettled_remote_balance_msat=$(echo "$cb_json" | jq -r '.unsettled_remote_balance.msat')
pending_open_local_balance_sat=$(echo "$cb_json" | jq -r '.pending_open_local_balance.sat')
pending_open_local_balance_msat=$(echo "$cb_json" | jq -r '.pending_open_local_balance.msat')
pending_open_remote_balance_sat=$(echo "$cb_json" | jq -r '.pending_open_remote_balance.sat')
pending_open_remote_balance_msat=$(echo "$cb_json" | jq -r '.pending_open_remote_balance.msat')

set_terminal ; echo -e "
########################################################################################
$cyan
                              Lightning Node Channel Balance
$orange
    Balance:                     $balance sats
    Pending open balance:        $pending_open_balance_sat sats

    Local balance:               $local_balance_sat sats ($local_balance_msat msats)
    Remote balance:              $remote_balance_sat sats ($remote_balance_msat msats)

    Unsettled local balance:     $unsettled_local_balance_sat sats ($unsettled_local_balance_msat msats)
    Unsettled_remote_balance:    $unsettled_remote_balance_sat sats ($unsettled_remote_balance_msat msats)

    Pending open local balance:  $pending_open_local_balance_sat sats ($pending_open_local_balance_msat msats)
    Pending open remote balance: $pending_open_remote_balance_sat sats ($pending_open_remote_balance_msat msats)

########################################################################################
"
enter_continue
#return 0

}

