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
read choice ; case $choice in a|A) return 1 ;; "") break ;; esac 
done

install_xxd

lnd_macaroon=$(xxd -p -c 256 $HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n')
lnd_certthumbprint=$(openssl x509 -noout -fingerprint -sha256 -in $HOME/.lnd/tls.cert | sed -e 's/.*=//;s/://g')

set_terminal_high ; echo -e "
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
type=lnd-rest;server=https://$IP:$rest/;macaroon=$cyan$lnd_macaroon$bright_blue;certthumbprint=$green$lnd_certthumbprint$bright_blue;allowinsecure=true
$orange

$pink$blinkon
The above configuration may need some adjustment depending on your specific setup${blinkoff}$orange, eg
instead of the internal IP, you may have a domain name, or the local host IP. You 
may also omit the 'allowinstecure=true' setting and see if your connection works
without it.

$red
$blinkon                   HIT 'QR' AND <ENTER> TO SHOW QR CODES $blinkoff $orange

########################################################################################
"
enter_continue

if [[ $enter_cont == "QR" || $enter_cont == "qr" ]] ; then
install_qrencode
show_qr_macaroons
fi

unset lnd_certthumbprint lnd_macaroon rest

}


function show_qr_macaroons {
while true ; do
set_terminal ; echo -e "
########################################################################################

$cyan
                            mm)    Show LND macaroon 
$cyan
                            c)     Show certthumbprint
$cyan
                            b)     Show BTC entry
$orange 

########################################################################################
"
choose xqmp ; read choice ; set_terminal
case $choice in
Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
mm)
set_terminal_high ; echo -e "
########################################################################################
   
The LND macaroon is:
$cyan
$(qrencode -t ANSIUTF8 $lnd_macaroon)
$orange

########################################################################################
"
enter_continue
;;
c)
set_terminal_high ; echo -e "
########################################################################################
   
The certthumbprint is:
$green
$(qrencode -t ANSIUTF8 $lnd_certthumbprint)
$orange

########################################################################################
"
enter_continue
;;
b)
set_terminal_custom 60 100; echo -e "
########################################################################################
   
You can use this to set up BTC Pay server to connect to LND by the 'REST proxy':
$bright_blue
$(qrencode -t ANSIUTF8 "\"type=lnd-rest;server=https://$IP:$rest/;macaroon=$cyan$lnd_macaroon$bright_blue;certthumbprint=$green$lnd_certthumbprint$bright_blue;allowinsecure=true\"")
$orange

########################################################################################
"
enter_continue
;;
"")
return 0
;;
*)
invalid ;;
esac
done
}


function install_xxd {
if which xxd >$dn 2>&1 ;then return 0 ; fi
if [[ $OS == Linux ]] ; then sudo apt-get update -y && sudo apt-get install xxd -y ; fi
if [[ $OS == Mac ]] ; then brew_check ; brew install xxd ; fi
}