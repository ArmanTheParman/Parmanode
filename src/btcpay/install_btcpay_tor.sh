function install_btcpay_tor {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if ! grep -q "btcpay-end" "$HOME/.parmanode/installed.conf" ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    BTCPay does not seem to be installed with Parmanode. You have options:

        i)  Install BTCPay with Parmanode

        u)  Use your own installation of BTCPay to expose via Tor

########################################################################################
"
choose "xpmq"

read choice

case $choice in
m|M) back2main ;;
q|Q|quit|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;
I|i) install_btcpay_linux 
     ;;
u|U) export own_btcpay=1
     break ;;
*) invalid ;;
esac
done
fi # end if btcpay not installed with parmanode

if [[ $own_btcpay == 1 ]] ; then

while true ; do
set_terminal
echo "
########################################################################################

    Please enter the IP address of your BTCPay installation. Just IP, not the port.

    eg. If it's on the local machine, you'd type:

    127.0.0.1

    Then hit <enter>

########################################################################################
"
read selfIP
echo ""
echo "You entered: $selfIP"
echo "Hit n then <enter> to try again, or anything else and <enter> to proceed."
read confirm
if [[ $confirm == "n" ]] ; then continue ; fi
export selfIP
break
done

while true ; do
set_terminal
echo "
########################################################################################

    Please enter the port number of your BTCPay installation.

    Then hit <enter>

########################################################################################
"
read selfPort 
echo ""
echo "You entered: $selfPort"
echo "Hit n then <enter> to try again, or anything else and <enter> to proceed."
read confirm
if [[ $confirm == "n" ]] ; then continue ; fi
export serfPort
break
done

fi #end if own btcpay


install_tor_webserver "btcpay"

unset selfPort selfIP

btcpayTOR_onion="$(sudo cat /var/lib/tor/btcpayTOR-server/hostname)"
set_terminal
echo "
########################################################################################

    To access your BTCPay over tor, you need to use a Tor browser, and enter not
    just the onion address, but the port (7003) as well. Traffic will reach your
    computer via the Tor software, then be redirected to http://127.0.0.1:23001
    or your selected IP and Port if you took up that option.

    The onion address should start with http:// not https:// or it won't work.

    BTCPay Onion address:

    http://$btcpayTOR_onion:7003

 ########################################################################################
"
enter_continue
}