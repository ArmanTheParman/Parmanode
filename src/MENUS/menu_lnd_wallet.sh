function menu_lnd_wallet {

while true ; do set_terminal ; echo -e "
########################################################################################$cyan
                                LND Menu${orange} - v$lnd_version                               
########################################################################################


      (pw)             Change LND wallet password 
      
      (ep)             Edit password.txt which auto-unlocks wallet

      (ul)             Unlock Wallet

      (wb)             Wallet balance

      (cb)             Channels' balance

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
lnd_password_change
return 0
;;

ep|EP)
while true ; do
echo -e "
########################################################################################
    
        This will run Nano text editor to edit$cyan password.txt$orange

        This file is used by LND to unlock your wallet whenever it starts up. This is
        not a place to add a new password, you're supposed to put the 'right' 
        password here, othewise your wallet stays locked when LND starts, and you'll
        have to manually unlock it.

        In the next screen, add your password on the first line. Do not add any other 
        text or new lines.  Then save and exit. Follow the menu prompts at the 
        bottom of the text editor screen.

$red
                                x)     to abort
$green
                            enter)     to continue
$orange

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P|x) return 1 ;;
"") break ;;
*) invalid ;;
esac
done

nano $HOME/.lnd/password.txt
set_terminal ; please_wait
return 0
;;

create|CREATE|Create)
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create
# password file and needs new wallet to do so.

#might be redundant...
lncli unlock 2>/dev/null || docker exec lnd lncli unlock 2>/dev/null

return 0 ;;

ul|UL|Ul|unlock|Unlock) 
if grep -r "lnd-" < $ic ; then lncli unlock ; fi
if grep -r "lnddocker-" < $ic ; then docker exec lnd lncli unlock ; fi
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

if grep -r "lnd-" < $ic ; then
lncli channelbalance > /tmp/.channelbalance
elif grep -r "lnddocker-" < $ic ; then
docker exec lnd lncli channelbalance > /tmp/.channelbalance
fi
cbfile=/tmp/.channelbalance

local_balance=$(echo $cbfile | grep -n1 "local_balance" | head -n3 | tail -n1 | cut -d \" -f 4) >/dev/null 2>&1
remote_balance=$(echo $cbfile | grep -n1 "remote_balance" | head -n3 | tail -n1 | cut -d \" -f 4) >/dev/null 2>&1
channel_size_total=$((local_balance + remote_balance))

if grep -r "lnd-" < $ic ; then
lncli walletbalance >/tmp/.walletbalance
elif grep -r "lnddocker-" < $ic ; then
docker exec lnd lncli walletbalance >/tmp/.walletbalance
wbfile=/tmp/.walletbalance

onchain_balance=$(echo $wbfile | head -n2 | tail -n1 | cut -d \" -f 4) >/dev/null 2>&1

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
sudo rm $wbfile $cbfile >/dev/null 2>&1
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
if grep -r "lnd-" < $ic ; then 
cb_json=$(lncli channelbalance)
elif grep -r "lnddocker-" < $ic ; then
cb_json=$(docker exec lnd lncli channelbalance)
fi

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

