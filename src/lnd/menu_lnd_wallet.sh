function menu_lnd_wallet {
if ! grep -q "lnd.*end" $ic && ! grep -q "litd-end" $ic ; then return 0 ; fi
while true ; do set_terminal ; echo -e "
########################################################################################$cyan
                                LND Menu${orange} - v$lnd_version                               
########################################################################################


$cyan
      (c)   $red           How to CONNECT your mobile lightning wallet to your node
                       eg Zeus wallet
$cyan
      (pw)$orange             Change LND wallet password 
$cyan      
      (ep)$orange             Edit password.txt which auto-unlocks wallet
$cyan
      (ul)      $orange       Unlock Wallet
$cyan
      (wb)           $orange  Wallet balance
$cyan
      (cb)$orange             Channels' balance
$cyan
      (delete)  $orange       Delete existing wallet and its files (macaroons, channel.db)
$cyan
      (create)        $orange Create an LND wallet (or restore a wallet with seed)
$orange


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
m|M) back2main ;; q|Q) exit ;; p|P) return 1 ;;

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
                            <enter>    to continue
$orange

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P|x) return 1 ;; m|M) back2main ;;
"") break ;;
*) invalid ;;
esac
done

nano $HOME/.lnd/password.txt #litd uses symlink
set_terminal ; please_wait
return 0
;;

create|CREATE|Create)
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create
# password file and needs new wallet to do so.

#might be redundant...
lncli unlock 2>$dn || docker exec lnd lncli unlock 2>$dn

return 0 ;;

ul|UL|Ul|unlock|Unlock) 
if grep -q "lnd-" $ic || grep -q "litd" $ic ; then lncli unlock ; fi
if grep -q "lnddocker-" $ic ; then docker exec lnd lncli unlock ; fi
return 0
;;

wb|WB)
wallet_balance
;;

cb|CB)
channel_bala*nce
;;

delete|DELETE|Delete) 
delete_wallet_lnd
return 0
;;

c|C)
connect_mobile_wallet
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

if grep -q "lnd-" $ic || grep -q "litd" $ic ; then
lncli channelbalance > $tmp/.channelbalance
elif grep -q "lnddocker-" $ic ; then
docker exec lnd lncli channelbalance > $tmp/.channelbalance
fi
cbfile=$tmp/.channelbalance

local_balance=$(cat "$cbfile" | grep -n1 "local_balance" | head -n3 | tail -n1 | cut -d \" -f 4) >$dn 2>&1
remote_balance=$(cat "$cbfile" | grep -n1 "remote_balance" | head -n3 | tail -n1 | cut -d \" -f 4) >$dn 2>&1
channel_size_total=$((local_balance + remote_balance))

if grep -q "lnd-" $ic || grep -q "litd" $ic ; then
lncli walletbalance >$tmp/.walletbalance
elif grep -q "lnddocker-" $ic ; then
docker exec lnd lncli walletbalance >$tmp/.walletbalance
fi
wbfile=$tmp/.walletbalance

onchain_balance=$(cat "$wbfile" | head -n2 | tail -n1 | cut -d \" -f 4) >$dn 2>&1

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
enter_continue ; jump $enter_cont
sudo rm $wbfile $cbfile >$dn 2>&1
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
if grep -q "lnd-" $ic || grep -q "litd" $ic ; then 
cb_json=$(lncli channelbalance)
elif grep -q "lnddocker-" $ic ; then
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
enter_continue ; jump $enter_cont
}

function connect_mobile_wallet {
set_terminal 40 88 ; echo -e "
########################################################################################
$cyan

         INSTRUCTIONS TO CONNECT TO YOUR LND NODE FROM A MOBILE WALLET $orange

$yellow
    The Zeus wallet will be used as an example, but others should be very similar.
    This was written August 2024 - the app may have changed slightly since then, use
    your judgement.
$orange

    After downloading the wallet, choose 'get started', then 'connect a node'
    Click the + sign, then fill in the fields as explained belowed:

    (If you don't see that, you may be looking at an 'unkown embedded LND' button. 
    Click that, then you should see a plus sign at the top right.)
   

$green
        Nickname$orange       - put whateveryou want
$green
        Node Interface$orange - choose LND(REST) from the drop down menu
$green
        Host$orange           - For now, just put in the node's internal IP address:
                         $cyan$IP$orange
$green            
        Rest Port $orange     - Parmanode LND uses 8080 by default, unless you've changed it.
$green
        Macaroon   $orange    - From the LND menu in Parmanode, choose 'mm' then 'mm' to get 
                         to the private macaroon info. There is a QR option to capture 
                         the text to your phone's QR scanner app, then paste it in your 
                         wallet.

    
    Then select 'save node config'. Give it some time and you node should be 
    connected.

$red    more... $orange

########################################################################################
"
enter_continue ; jump $enter_cont

if [[ $OS == Linux ]] ; then
onion=$(sudo cat /var/lib/tor/lnd-service/hostname)
else
onion=$(sudo cat /usr/local/var/lib/tor/lnd-service/hostname)
fi

set_terminal 40 88 ; echo -e "
########################################################################################


    The previous instructions works for when you are home and your phone has access
    to your home network.

    For access from outside the home, you have two options.

$green
    1)$orange Manually adjust your port forwarding rules in your router. You'll have to 
       open port 8080 and point it to your node's IP address. Then in your phone
       wallet, instead of the IP address of the node, put the IP address of your
       home's router: $cyan $extIP $orange
$green
    2)$orange Use Tor. It's more secure as you don't need to open ports, but it is 
       definitely slower. 

         -- Make sure Tor is running on your phone, eg Orbot app.
         -- Use port 8081 on the phone, not 8080. Parmnanode routes Tor 8081 to 8080
         -- Paste this onion address in the Host field (instead of IP address):


         $bright_blue$onion$orange


########################################################################################
"
enter_continue ; jump $enter_cont
}
