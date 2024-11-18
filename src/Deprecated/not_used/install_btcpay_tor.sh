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
q|Q|quit|QUIT|Quit) exit ;; m|M) back2main ;; p|P) return 1 ;;
I|i) 
install_btcpay_linux 
;;
u|U) 
export own_btcpay=1
break ;;
*) 
invalid ;;
esac
done
fi # end if btcpay not installed with parmanode

########################################################################################
if [[ $own_btcpay == 1 ]] ; then

while true ; do
set_terminal
echo -e "
########################################################################################

    Please enter the IP address of your BTCPay installation. Just IP, not the port.

    eg. If it's on the local machine, you'd type:

    127.0.0.1

    Then hit <enter>

########################################################################################
"
read selfIP
echo -e "\nYou entered: $selfIP\n"
echo -e "Hit n then$cyan <enter>$orange to try again, or anything else and$cyan <enter>$orange to proceed.\n"
read confirm
if [[ $confirm == "n" ]] ; then continue ; fi
export selfIP
break
done

while true ; do
set_terminal
echo -e "
########################################################################################

    Please enter the$cyan port number$orange of your BTCPay installation.

    Then hit$green <enter> $orange

########################################################################################
"
read selfPort 
echo -e "\nYou entered: $selfPort\n"
echo -e "\nHit n then$cyan <enter>$orange to try again, or anything else and$cyan <enter>$orange to proceed."
read confirm
if [[ $confirm == "n" ]] ; then continue ; fi
export serfPort
break
done

fi #end if own btcpay
########################################################################################

install_tor_webserver "btcpay"

unset selfPort selfIP

btcpayTOR_onion="$(sudo cat /var/lib/tor/btcpayTOR-server/hostname)"
set_terminal
echo -e "
########################################################################################

    To access your BTCPay over tor, you need to use a Tor browser, and enter not
    just the onion address, but the port (7003) as well. Traffic will reach your
    computer via the Tor software, then be redirected to$cyan http://127.0.0.1:23001$orange
    or your selected IP and Port if you took up that option.

    The onion address should start with http:// not https:// or it won't work.

    BTCPay Onion address:
$bright_blue
    http://$btcpayTOR_onion:7003
$orange
 ########################################################################################
"
enter_continue
}