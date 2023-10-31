function set_static_IP {

while true ; do

set_terminal ; echo -e "
########################################################################################

    PiHole needs the IP of your device to be static. This is not the same as a 
    regular static IP that you might have to pay for - those are external IPs for
    use as servers, eg for a public website.

    We are dealing with INTERNAL IPs which are private and viewable only on your
    home network. This device's IP address is:
$green
               $IP
$orange    
    Parmanode will help to make this IP static - ie, it will prevent your router from
    randomly changing it for no apparant reason (it happens).

    Hit$pink a$orange to abort (you should perform this IP operation yourself and
    come back to this installation) or$green y$orange to proceed.

########################################################################################
"
read -n1 choice

case $choice in
q|Q) exit ;;
a|A|p|P) return 1 ;;
y|Y) break ;;
*) 
invalid
;;
esac
done

router=$(ip route | grep default | awk '{print $3}')
connection_name=$(sudo nmcli con show) >/dev/null 2>&1

sudo nmcli con mod $connection_name ipv4.addresses $IP/24 >/dev/null 2>&1
sudo nmcli con mod $connection_name ipv4.gateway $router >/dev/null 2>&1 
sudo nmcli con mod $connection_name ipv4.dns "8.8.8.8" >/dev/null 2>&1
sudo nmcli con mod $connection_name ipv4.method manual >/dev/null 2>&1

sudo nmcli con up $connection_name
return 0
}