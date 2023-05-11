function get_IP {
while true ; do clear ; echo "
########################################################################################

    Does the IP address of this computer look right?

    $IP

    Type yes or no, then <enter>

########################################################################################
"
read choice

case $choice in yes|YES|y|Y) return 0 ;; no|NO|nO|No|n|N) enter_IP && return 0 ;; *) invalid ;; esac
done
}


function enter_IP {
clear ; echo "    Please enter your IP, eg 192.160.0.150: "
read IP
echo "Your IP is : $IP. Type yes to accept or no to try gain."
read choice
case $choice in yes|YES|Y|y|Yes) return 0 ;; *) return 1 ; esac

}


#change /etc/hosts, add:
#$IP btcpay.locl
#Then flush cache.
#Mac; sudo dscacheutil -flushcache
#Linux; sudo systemctl restart nscd
