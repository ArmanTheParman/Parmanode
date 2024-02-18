function get_system_report {
report="/tmp/system_report.txt" && echo "PARMANODL SYSTEM REPORT $(date)" > $report

function echor {
echo -e "$1" >> "$report" 2>&1
}

function echoline {
echo -e "----------------------------------------------------------------------------------------" >> $report
}

function echonl {
echo "" >> $report
}


cd $HOME/parman_programs/parmanode 2>>$report
echor "$(git status)"
echor "$(git log | head -n30)"

#parmanode.conf
echor "#PARMNODE CONF"
echo "$(cat $HOME/.parmanode/parmanode.conf)"

#system info
echo "#SYSTEM INFO"
echor "$(id)"
echor "$(uname) , $(uname -m)"
echor "$(env)"
echor "$(df -h)"
echor "$(sudo lsblk)"
echor "$(sudo blkid)"
echor "#MOUNT \n $(mount)"
echor "$(free)"
echor "
"
#programs
echor "#PROGRAMS"
echor "#which..." 
echor "$(which nginx npm tor bitcoin-cli docker brew curl jq)"

#prinout of $dp
echo "#DOT PARMANODE"
cd $HOME/.parmanode
echor "#printout of $dp"
for file in * .* ; do
    echor "FILE: $file \n $(cat $file) \n" 
done

#nginx
echor "#NGINX" 
echor "$(sudo nginx -t)"
cd /etc/nginx && echo "$(pwd ; ls -m)"
cd /etc/nginx/conf.d && echo "$(pwd ; ls -m)"
echor "$(file /etc/nginx/stream.conf && cat /etc/nginx/stream.conf)"
echor "$(file /etc/nginx/nginx.conf && cat /etc/nginx/nginx.conf)"


echor "#HOME PARMANODE"
cd $HOME/parmanode
echor "$(ls -m)"


echor "#BITCOIN STUFF"
cd $HOME/.bitcoin
echor "$(ls)"
echor "$(cat bitcoin.conf)"
echor "$(du -sh)"

#BITCOIN
echor "#BITCOIN"
source $HOME/.bitcoin/bitcoin.conf
echor "bitcoin.conf \n $(cat $HOME/.bitcoin/bitcoin.conf)"
echor "debug.log \n $(cat $HOME/.bitcoin/debug.log | tail -n200 ) \n "
echor "getblockchaininfo \n bitcoin-cli getblockchaininfo"
echor "space taken by bitcoin data dir"
echor "$(cd $HOME/.bitcoin ; du -sh)"
echor "rpc curl bitcoin, 127.0.0.1 then $IP \n"
echor "$(curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332)"
echor "$(curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://$IP:8332)"

#DOCKER
echor "docker ps -a \n $(docker ps -a)"
echor "docker ps \n $(docker ps) \n "
containers=$(docker ps -q)
for i in $containers ; do
docker logs $i --tail 100
echoline ; echonl
done

#BTCRPCEXPLORER
echor "env \n $(cat $HOME/parmanode/btc-rpc-explorer/.env)"

#BTCPAY
echor "btcpay \n $(cat $HOME/.btcpayserver/Main/settings.config)"
echor "nbxplorer \n $(cat $HOME/.nbxplorer/Main/settings.config)"

#ELECTRS
echor "electrs config \n $(cat $HOME/.electrs/config.toml)"

#ELECTRUMX
echor "elecrrumx config \n $(cat $HOME/parmanode/electrumx/electrumx.conf)"

#FULCRUM
echor "fulcrum config \n $(cat $HOME/parmanode/fulcrum/fulcrum.conf)"

#LND
echor "LND config \n $(cat $HOME/.lnd/lnd.conf)"

#MEMPOOL
echor "Mempool docker compose \n $(cat $hp/mempool/docker/docker-compose.yml)"

#PUBLICPOOL
echor "public pool env \n $(cat $hp/public_pool/.env)"

#HOSTNAME/TOR
echor "#BRE TOR"
sudo cat /var/lib/tor/bre-service/hostname
echor "#ELECTRS TOR"
echor "$(sudo cat /var/lib/tor/electrs-service/hostname)"
echor "$(sudo cat /var/lib/tor/electrumx-service/hostname)"
echor "$(sudo cat /var/lib/tor/mempool-service/hostname)"
echor "$(sudo cat /var/lib/tor/fulcrum-service/hostname)"
echor "$(sudo cat /var/lib/tor/public_pool-service/hostname)"
echor "$(sudo cat /var/lib/tor/btcpayTOR-server/hostname)"
echor "$(sudo cat /var/lib/tor/bitcoin-service/hostname)"

#EXTRA STUFF
echor "#EXTRA STUFF"
echor "$(cat /etc/cpuinfo)"


mv $report $HOME/Desktop/

set_terminal ; echo -e "
########################################################################################

    Parmanode has generated a system report about your installation, and left the
    file for you at: $cyan

        $HOME/Desktop/system_report.txt
$orange 
    You can now review this file, and if you were asked, can send this to Parman
    for assistance. The email is:
$cyan
        armantheparman@protonmail.com
$orange
########################################################################################
"
enter_continue

}

