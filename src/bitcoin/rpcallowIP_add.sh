function rpcallowip_add {

while true ; do
set_terminal; echo "
########################################################################################

                       Add an rpcallowip line to bitcoin.conf

    The IP address you add will permit Bitcoin to connect this IP address for remote
    procedure calls (connections to other software), and is necessary if you have
    a Fulcrum server on a different computer.

########################################################################################

Enter the IP address you'd like to add, eg 192.168.0.150: 
"
read IP
echo ""
echo "The line that will be added to bitcoin.conf is:

rpcallowip=$IP

Hit <enter> to accept or (c) to change, (p) to return, (q) to quit.
"

case $IP in q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; c|C) continue ;; *) break ;; esac
done

return 0
}