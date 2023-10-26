function electrs_bitcoinIP_change {

while true ; do
set_terminal ; echo "
########################################################################################

                            IP address of Bitcoin Core

    Go get the IP address of the other Bitcoin Core computer that electrs will 
    connect to.

    (The standard port of 8332 will be assumed. You must fiddle with this yourself if 
    you want extra tinkering - Parmanode can't help you with it.)

########################################################################################

Type the IP address number (e.g. 192.168.0.150):  "
read IP
echo "
The address you typed is : $IP

Hit (y) and <enter> to accept, or (n) to try again.
"
read choice
case $choice in y|Y) break ;; n|N) continue ;; *) invalid ;; esac
done

local file="$HOME/.electrs/config.toml"

delete_line "$file" "daemon"
echo "daemon_rpc_addr = \"$IP:8332\"
daemon_p2p_addr = \"$IP:8333\"" | tee -a $file >/dev/null 2>&1

return 0
}