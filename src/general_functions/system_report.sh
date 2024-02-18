
function get_system_report {
return 0
function echor {
echo -e "$1" >> "$report" 2>&1
}
function echoline {
echo -e "----------------------------------------------------------------------------------------" >> $report
}
function echonl {
echo "" >> $report
}


report="/tmp/system_report.txt" && echo "PARMANODL SYSTEM REPORT $(date)" > $report

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
echor "$(which nginx npm tor bitcoin-cli docker)"

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
echor "docker ps \n $(docker ps) \n "
containers=$(docker ps -q)
for i in $containers ; do
docker logs $i --tail 100
echoline ; echonl
done

#extra stuff
echor "#EXTRA STUFF"
echor "$(cat /etc/cpuinfo)"

}

