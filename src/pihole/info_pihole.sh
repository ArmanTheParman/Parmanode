function info_pihole {
set_terminal ; echo -e "
########################################################################################

    To get the most benefit from your PiHole, on your Router/Gateway, set the DNS
    server to the IP address of the PiHole, and disallow all other DNS servers.
    
    If that is not possilbe, either get a better Router, or set the DNS server to 
    the PiHole on EACH individual device - it'l work but it's more teadious than the
    first option.
$magenta
    WARNING$orange - if you set up the PiHole to work properly throughout your home network,
    then you stop the PiHole, all the devices on your network will no longer be
    able to connect to domains. You either have to type in IP addresses (ridiculous)
    or get the PiHole back up and running quick smart, or change the DNS servers back
    to something like google (IP=8.8.8.8)

    RECOMMENDATION - Use this device as a stand-alone Pi Hole. i.e. don't use Bitcoin
    core on this machine, and other Parmanode assisted apps. It's better to get a
    new machine, and put Parmanode-PiHole on that.

########################################################################################
"
enter_continue
}