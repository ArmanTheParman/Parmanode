function lnd_macaroons {

rest=$(cat $HOME/.lnd/lnd.conf | grep -E '^restlisten=' | cut -d : -f 2)
while true ; do
set_terminal ; echo -e "
########################################################################################

    You are about to have the macaroons for LND printed to the screen. This 
    can be used to connect your BTC Pay Server to your LND node. Please be aware,
    this is sensitive text and if not kept private, other people can control your
    LND node.
   $pink 
    Close the curtains and stop any screen sharing.
$orange
########################################################################################
"
enter_abort 
read choice ; case $choice in a|A) return 1 ;; "") break ;; esac ; done

lnd_macaroon=$(xxd -p -c 256 $HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n')
lnd_certthumbprint=$(openssl x509 -noout -fingerprint -sha256 -in $HOME/.lnd/tls.cert | sed -e 's/.*=//;s/://g')

set_terminal ; echo -e "
########################################################################################

The LND macaroon is:
$cyan
$lnd_macaroon
$orange
The certthumbprint is:
$green
$lnd_certthumbprint $orange

You can use this to set up BTC Pay server to connect to LND by the 'REST proxy':
$bright_blue
type=lnd-rest;server=https://$IP:$rest/;macaroon=$lnd_macaroon;certthumbprint=$lnd_certthumbprint;allowinsecure=true
$orange

########################################################################################
"
enter_continue
}