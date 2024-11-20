function electrs_bitcoinIP_change {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                            IP address of Bitcoin Core
$orange
    Go get the IP address of the other Bitcoin Core computer that electrs will 
    connect to, then type the IP address number (${green}e.g. 192.168.0.150$orange), then$cyan <enter>
    $bright_blue

    (The standard port of 8332 will be assumed. You must fiddle with this yourself if 
    you want extra tinkering - Parmanode can't help you with it.)
$orange
########################################################################################
"
read IP
echo -e "\nThe address you typed is : $IP

Hit$green y$orange and$cyan <enter>$orange to accept, or$red n$orange to try again.\n"
read choice
case $choice in y|Y) break ;; n|N) continue ;; *) invalid ;; esac
done

local file="$HOME/.electrs/config.toml"

sudo gsed -i "/daemon/d" $file 
echo "daemon_rpc_addr = \"$IP:8332\"
daemon_p2p_addr = \"$IP:8333\"" | tee -a $file >/dev/null 2>&1

return 0
}