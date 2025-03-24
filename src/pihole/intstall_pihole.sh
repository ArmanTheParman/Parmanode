function install_pihole {

if grep -q "public_pool" $ic >$dn ; then
announce "Can't install PiHole and Public_Pool on the same system. Aborting."
return 1
fi


set_terminal ; echo -e "
########################################################################################
$cyan
                              PiHole with Parmanode
$orange
    Before installing PiHole, there are a few things to know and a few things to
    check. Read the instructions and respond accordingly.

########################################################################################
"
enter_continue ; jump $enter_cont

set_terminal ; echo -e "
########################################################################################
$cyan
                               DNS Servers and stuff
$orange
    PiHole is software that acts as the gatekeeper to your internet traffic and lets
    you block/unblock specified sites, and also blocks adds. This works for any device
    connected on the same home network.

    To perform this function, it needs to be configured as your network's DNS server.

    A Domain Name Systerm (DNS) Server is a server that translates domain names to the
    correct IP address (names to numbers). 
    
    Eg, when you navigate to google.com, you're actually going to the IP address  $cyan
    http://8.8.8.8$orange, which is converted for you in the background by a DNS server.

    PiHole needs to take on this function, and it may require some fiddling, but $pink
    DON'T PANIC$orange, I'll help you...

########################################################################################
"
enter_continue ; jump $enter_cont

# Install Docker
if ! which podman >$dn 2>&1 ; then install_podman || return 1 ; fi

nginx_clash PiHole || return 1

if [[ $OS == Linux ]] ; then systemd-resolved_disable || return 1 ; fi

# Check it worked
 
set_terminal 
if [[ $OS == Linux ]] ; then
if sudo netstat -tulnp | grep -q ":80" | grep -v lighttpd ; then
sudo netstat -tulnp | grep ":80"
echo -e "

########################################################################################
$red
    We have a problem.$orange Parmanode has detected that port 80 is still being used for
    some reason. The command that's failing is:
$cyan
                     sudo netstat -tulnp | grep -q \":80\"
$orange
    ... which should be blank, but it's showing port 80 in use. You might have to try 
    to resolve this yourself before attempting to install PiHole again.

########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi #end if port 80 in use
fi #end if Linux

if [[ $OS == Mac ]] ; then
if sudo lsof -iTCP -sTCP:LISTEN -Pn | grep -q ':80 (LISTEN)' ; then
set_terminal
sudo lsof -iTCP -sTCP:LISTEN -Pn | grep ':80 (LISTEN)'
echo -e "

########################################################################################

$red
    We have a problem.$orange Parmanode has detected that port 80 is still being used for
    some reason. The command that's failing is:
$cyan

                   sudo lsof -iTCP -sTCP:LISTEN -Pn | grep ':80 (LISTEN)'

    ... which should be blank, but it's showing port 80 in use. You might have to try 
    to resolve this yourself before attempting to install PiHole again.

########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi #end if port 80 in use, Mac
fi #end if Mac

# Make IP address permanent
set_static_IP || return 1

cd $hp
mkdir pihole && installed_conf_add "pihole-start"
cd $hp/pihole
if [[ $OS == Mac ]] ; then cp "$pn/src/pihole/podman-compose(mac).yaml" ./podman-compose.yaml 
else
cp $pn/src/pihole/podman-compose.yaml ./
fi

if ! podman ps >$dn ; then
if [[ $OS == Mac ]] ; then start_podman_mac ; fi
fi
if ! podman ps >$dn ; then
announce "Docker needs to be running. Please start Docker before continuing."
fi

podman compose up -d 
installed_conf_add "pihole-end"
success "PiHole" "being installed"
set_terminal ; echo -e "
########################################################################################

    Please note, the password for the PiHole is$green 'neverseller'$orange

    To log in, use the IP of the device and the 'admin' directory, like this:
$cyan
    http://$IP/admin
$orange
    It's probably a good idea to change the password. To do that, just select the 
    option from the Parmanode-PiHole menu.

########################################################################################
"
enter_continue ; jump $enter_cont
return 0
}