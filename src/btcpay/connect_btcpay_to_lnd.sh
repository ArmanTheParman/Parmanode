function connect_btcpay_to_lnd {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode will help you connect BTCPay to your LND lightning node. Some 
    information must be entered into the graphical user interface - I am unable to
    do it for you, but this software will provide you with the exact text you need to
    enter.
$cyan
    Be careful, the information printed to the next screen is sensitive, and access to 
    it will allow access to your lightning node.
$orange
    Proceed with instructions?  

                       y)       Show instructions and sensitive data

                       a)       Danger Danger Abort Abort

########################################################################################
"
choose "xpq" ; read choice
case $choice in
q|Q) quit ;; p|P) return 1 ;; a|A) return 1 ;;
y|Y|yes) break ;;
*) invalid ;;
esac
done
macaroon=$(xxd -p -c 256 ~/.lnd/data/chain/bitcoin/mainnet/admin.macaroon | tr -d '\n') >/dev/null 2>&1
certthumbprint=$(openssl x509 -noout -fingerprint -sha256 -in ~/.lnd/tls.cert | sed -e 's/.*=//;s/://g') >/dev/null 2>&1
sensitive="type=lnd-rest;server=https://127.0.0.1:8080/;macaroon=$macaroon;certthumbprint=$certthumbprint" >/dev/null 2>&1


set_terminal ; echo -e "
########################################################################################
$cyan
                                 INSTRUCTIONS
$orange
    1) Log in to your BTCPay server and create a store.

    2) Click 'Set up a lightning node'

    3) Choose 'Use custom node'

    4) In the box 'Connection configuration for your custom Lightning node', paste
       the text below then click 'Test Connection'.
$green
$sensitive
$orange
    5) Make sure you get a green sucessful connection confirmation.
    
    6) Do not forget to click 'SAVE'

########################################################################################
"
enter_continue
return 0
}


