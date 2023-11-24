function set_static_IP {

while true ; do

set_terminal ; echo -e "
########################################################################################

    PiHole needs the IP of your device to be static. This is not the same as a 
    regular static IP that you might have to pay for - those are external IPs for
    use as servers, eg for a public website.

    We are dealing with INTERNAL IPs which are private and viewable only on your
    home network. This device's IP address is:
$bright_blue
               $IP
$green
    Parmanode will help to make this IP static$orange - ie, it will prevent your router from
    randomly changing it for no apparant reason (it happens).

    Hit$pink a$orange to abort (if so, you should perform this IP operation yourself 
    and come back to this installation) 
    
    or$green y$orange to proceed.

########################################################################################
"
choose "x"
read choice

case $choice in
q|Q) exit ;;
a|A|p|P) return 1 ;;
y|Y) break ;;
*) 
invalid
;;
esac
done

if [[ $OS == Mac ]] ; then set_static_IP_mac && return 0 ; return 1
else
sudo systemctl start NetworkManager
connection_count=$(sudo nmcli -t -f NAME,TYPE con show --active | grep -v docker | grep -v bridge | wc -l)
sleep 2
debug3 "connection count done. Count is $connection_count"
debug "normal debug"
if [[ $connection_count != 1 ]] ; then
announce "Parmanode was unable to make your IP address static. Please do
    this on your own if you wish to continue using PiHole, or you'll
    get errors."
fi

connection_name=$(sudo nmcli -t -f NAME,TYPE con show --active | grep -v docker | grep -v bridge | cut -d : -f 1) 
debug3 "connection name is $connection_name"

router=$(ip route | grep default | awk '{print $3}')
sudo nmcli con mod $connection_name ipv4.addresses $IP/24 >/dev/null 2>&1
sudo nmcli con mod $connection_name ipv4.gateway $router >/dev/null 2>&1 
sudo nmcli con mod $connection_name ipv4.dns "8.8.8.8" >/dev/null 2>&1
sudo nmcli con mod $connection_name ipv4.method manual >/dev/null 2>&1

sudo nmcli con up $connection_name
return 0
fi #end if not Mac
}

function set_static_IP_mac {

interface=$(route get default | awk '/interface:/{print $2}')
#eg en0

SERVICE_NAME=$(networksetup -listallhardwareports | grep -n1 $interface | head -1 | cut -d : -f 2 | grep -oE '\S+.*$')
#WiFi or Ethernet expected

set_terminal
echo -e "
########################################################################################

    Parmanode detected your network connection as $SERVICE_NAME
    
########################################################################################
"
enter_continue

#Router IP
ROUTER=$(route -n get default | grep gateway | cut -d : -f 2 | grep -oE '\S+.$')

set_terminal
echo -e "
########################################################################################

    Parmanode detected your router is $ROUTER

########################################################################################
"
enter_continue

#Subnet in dec
SUBNET_HEX=$(ifconfig $interface | awk '/netmask/{print $4}' | sed 's/0x//') >/dev/null
SUBNET_DEC=$(printf "%d.%d.%d.%d\n" $((16#${SUBNET_HEX:0:2})) $((16#${SUBNET_HEX:2:2})) $((16#${SUBNET_HEX:4:2})) $((16#${SUBNET_HEX:6:2})))
set_terminal
echo -e "
########################################################################################

    Parmanode detected your subnet mask as $SUBNET_DEC

########################################################################################
"
enter_continue

set_terminal
echo -e "    Setting the IP, $IP, to static."

networksetup -setmanual "$SERVICE_NAME" "$IP" "$SUBNET_DEC" "$ROUTER"
sleep 2
return 0
}