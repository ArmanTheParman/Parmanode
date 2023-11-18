function lnd_tor_on {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
lnd_tor_message
local file=$HOME/.lnd/lnd.conf
if ! which tor >/dev/null ; then install_tor ; fi
}

function lnd_tor_off {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
local file=$HOME/.lnd/lnd.conf
}

function lnd_tor_only {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
local file=$HOME/.lnd/lnd.conf
if ! which tor >/dev/null ; then install_tor ; fi
}

function lnd_tor_both {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
local file=$HOME/.lnd/lnd.conf
}

function lnd_tor_message {
echo -e "
########################################################################################

   Whether LND is running by Tor-Only or as a hybrid Tor/Clearnet ultimately is
   determined by the URL types you see at the bottom of the LND menu.

   If there is only a Tor URL (onion), then LND is running Tor-only. 
   
   If there is only a clearnet URL on the menu page, then LND is running on clearnet 
   only. 

   Obviously if you see both clearnet and onion addresses, it means LND is running as
   a hybrid Tor and clearnet node.
$cyan
   To ensure LND is running as Tor only (if that's your preference), you need to turn
   Tor on, but also turn hybrid off. If Hybrid mode doesn't successfuly turn off, you
   can manually edit the lnd.conf file and make sure none of the configuration options
   are specifying external clearnet addresses. Anything with 'Listening' is not
   included in this rquirement.
$red
   Please also note that the Tor setting for Bitcoin must match the LND settings or
   else LND won't start/run. Parmanode will do this by modifying the bitcoin.conf
   settings now.
$orange
########################################################################################
"
enter_continue
}