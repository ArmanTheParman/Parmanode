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


      (pw)             Change LND password 

      (ul)             Unlock Wallet

      (wb)             Wallet balance

      (cb)             Channels' balance

      (au)             Enable auto-unlock wallet (for easy restarts of LND)

      (delete)         Delete existing wallet and its files (macaroons, channel.db)

      (create)         Create an LND wallet (or restore a wallet with seed)


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in

m|M) back2main ;;
q|Q) exit ;;
p|P) return 1 ;;

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

# Function to extract a specific value from JSON
extract_value_cb() {
    local key="$1"
    local json="$2"
    echo "$json" | jq -r ".$key"
}

# Run lncli channelbalance and capture the JSON output
cb_json=$(lncli channelbalance)

# Parse specific values
balance=$(extract_value_cb 'balance' "$cb_json")
pending_open_balance_sat=$(extract_value_cb 'pending_open_balance' "$cb_json")
pending_open_balance_msat=$(extract_value_cb 'pending_open_balance' "$cb_json")
local_balance_sat=$(extract_value_cb 'local_balance.sat' "$cb_json")
local_balance_msat=$(extract_value_cb 'local_balance.msat' "$cb_json")
remote_balance_sat=$(extract_value_cb 'remote_balance.sat' "$cb_json")
remote_balance_msat=$(extract_value_cb 'remote_balance.msat' "$cb_json")
unsettled_local_balance_sat=$(extract_value_cb 'unsettled_local_balance.sat' "$cb_json")
unsettled_local_balance_msat=$(extract_value_cb 'unsettled_local_balance.msat' "$cb_json")
unsettled_remote_balance_sat=$(extract_value_cb 'unsettled_remote_balance.sat' "$cb_json")
unsettled_remote_balance_msat=$(extract_value_cb 'unsettled_remote_balance.msat' "$cb_json")
pending_open_local_balance_sat=$(extract_value_cb 'pending_open_local_balance.sat' "$cb_json")
pending_open_local_balance_msat=$(extract_value_cb 'pending_open_local_balance.msat' "$cb_json")
pending_open_remote_balance_sat=$(extract_value_cb 'pending_open_remote_balance.sat' "$cb_json")
pending_open_remote_balance_msat=$(extract_value_cb 'pending_open_remote_balance.msat' "$cb_json")

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
}

