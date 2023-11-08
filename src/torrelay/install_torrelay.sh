function install_torrelay {
if [[ $(uname) == Darwin ]] ; then no_mac ; return 1 ; fi

if ! which tor >/dev/null 2>&1 ; then announce "Please instal Tor first from the Parmanode add menu. Aborting." ; return 1 ; fi

#check port 443 not in use
if sudo netstat -tuln | grep -q :443 ; then relayport=543 ; else relayport=443 ; fi

#Add to torrc file
local file="/etc/tor/torrc"

#Contact info
set_terminal
echo -e "
########################################################################################

    I have no opinion on this yet, but apparantly it is recommended to leave a 
    contact email for Tor adminstrators to contact you, should there be a problem
    with your relay.

    If you want to do this, I recommend an anonymous email, in particularly, don't 
    use one with your full name.

    If you want to add an email, type in in and hit <enter>, or to skip, just hit
    <enter>

########################################################################################
"
read email
clear
if [[ -z $email ]] ; then ContactInfo='#ContactInfo' ; else ContactInfo="ContactInfo $email" ; fi

echo "#Tor Relay Installation...
ORPort $relayport
Nickname ParmanodeRelay
$ContactInfo
ExitRelay 0
RelayBandwidthRate 100 KBytes  # each 40Kb per second translates to about 100Gb /month 
RelayBandwidthBurst 200 KBytes


"
}