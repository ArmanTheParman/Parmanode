function system_report {

clear ; echo "
########################################################################################

    Parmanode will generate a System Report File automatically. It will
    then save the file to your desktop, and you can then email it to me for help.

    Hit <enter> to continue

    'a' and <enter> to abort

########################################################################################
"
read -s choice ; clear
case $choice in
a|q|Q) 
exit 
;;
esac

export omit="true" 
export report="/tmp/system_report.txt" 
export macprefix="/usr/local"
echo "PARMANODL SYSTEM REPORT $(date)" > $report

function delete_private {
if [[ $omit == "true" ]] ; then
    rm $dp/sed.log >/dev/null
    rm $dp/debug.log >/dev/null
    rm $dp/change_string* >/dev/null
    if which gsed >/dev/null ; then
      cat $report | gsed '/coreAuth/d; /BTCEXP_BITCOIND/d; /rpcuser/d; /rpcpass/d; /auth = /d; /btc\.rpc\.user=/d; /btc\.rpc\.password=/d; /alias=/d; /bitcoind\.rpc/d; /DAEMON_URL =/d; /CORE_RPC_USERNAME/d; /CORE_RPC_PASSWORD/d; /BITCOIN_RPC_PASSWORD/d; /BITCOIN_RPC_USER/d; /multiPass/d' > /tmp/tempreport 
    elif which sed >/dev/null ; then
      cat $report | sed '/coreAuth/d; /BTCEXP_BITCOIND/d; /rpcuser/d; /rpcpass/d; /auth = /d; /btc\.rpc\.user=/d; /btc\.rpc\.password=/d; /alias=/d; /bitcoind\.rpc/d; /DAEMON_URL =/d; /CORE_RPC_USERNAME/d; /CORE_RPC_PASSWORD/d; /BITCOIN_RPC_PASSWORD/d; /BITCOIN_RPC_USER/d; /multiPass/d' > /tmp/tempreport 
    fi
mv /tmp/tempreport $report
fi
}

function echor {
echo -e "$1" >> "$report" 2>&1
}

function echoline {
echo -e "----------------------------------------------------------------------------------------" >> $report
}

function echonl {
echo "" >> $report
}


echoline
echor "#DIRECTORY CHECKS"
#if dir doesn't exist, it will report
if [[ -d $HOME/parman_programs/parmanode ]] ; then
echoline
echor "\$pn exists"
echor "$(git status)"
cat $HOME/parman_programs/parmanode/src/version.conf >> $report
else
echo "\$pn DOES NOT EXIST"
fi

echoline

#if dir doesn't exist, it will report
if [[ -d $HOME/.parmanode ]] ; then
echoline
echor "\$dp exists"
cd $HOME/.parmanode
ls -a >> $report
else
echo "\$dp DOES NOT EXIST"
fi

echoline

#parmanode.conf
echor "#PARMNODE CONF"
echor "$(cat $HOME/.parmanode/parmanode.conf)"

echoline

#system info
echor "#SYSTEM INFO"
if [[ $(uname) == Darwin ]] ; then echor "$(system_profiler SPHardwareDataType)" ; fi
echor "$(id)"
echor "$(uname) , $(uname -m)"
echor "$(env)"
echor "$(df -h)"
echor "$(sudo lsblk)"
echor "$(sudo blkid)"
echor "#MOUNT \n $(mount)"
echor "$(free)"
echor "#HOME dir..."
echor "$(cd ; ls -lah)"
echor "cpuinfo"
echor "$(cat /proc/cpuinfo | head -n10)"

echoline
#programs
echor "#PROGRAMS"
echor "#which nginx npm tor bitcoin-cli docker brew curl jq netstat"
echor "$(which nginx npm tor bitcoin-cli docker brew curl jq netstat)"

echoline
#prinout of $dp
echor "#DOT PARMANODE PRINTOUT"
cd $HOME/.parmanode
echor "#printout of \$dp"
for file in * .* ; do
    if [[ -f $file && -s $file ]] ; then
    echor "FILE: $file \n $(cat $file) \n" 
    fi
done

echoline

echor "#HOME PARMANODE"
cd $HOME/parmanode
echor "$(ls -m)"

echoline

#NGINX
echor "#NGINX" 
echor "$(sudo nginx -t)"
cd $macprefix/etc/nginx && echor "$(pwd ; ls -m)"
cd $macprefix/etc/nginx/conf.d && echor "$(pwd ; ls -m)"
echor "$(file /etc/nginx/stream.conf && cat /etc/nginx/stream.conf)"
echor "$(file /etc/nginx/nginx.conf && cat /etc/nginx/nginx.conf)"
echor "NGINX ERROR FILE..."
echor "$(cat /tmp/nginx.conf_error)"

echoline

#BITCOIN
echor "#BITCOIN STUFF"
#source $HOME/.bitcoin/bitcoin.conf
if [[ ! -e $HOME/.bitcoin ]] ; then echo "Bitcoin data dir doesn't exist." 
else
cd $HOME/.bitcoin
echor ".bitcion size..."
echor "$(du -sh)"
echo ".bitcoin contents..."
echor "$(ls -m)"
echor "bitcoin.conf..."
echor "$(cat $HOME/.bitcoin/bitcoin.conf)"
echor "getblockchaininfo..."
echor "$(bitcoin-cli getblockchaininfo)"
echor "rpc curl bitcoin, 127.0.0.1 then $IP \n"
fi

echoline

#DOCKER
echor "#DOCKER ..."
echor "docker ps -a \n $(docker ps -a)"
echor "docker ps \n $(docker ps) \n "
containers=$(docker ps -q)
echo "containers... \n $(docker ps -q)"
for i in $containers ; do
docker logs $i --tail 50 
echoline ; echonl
done

echoline
echor "#BTCRPCEXPLORER"
echor "env \n $(cat $HOME/parmanode/btc-rpc-explorer/.env)"

echoline
echor "#BTCPAY"
echor "btcpay \n $(cat $HOME/.btcpayserver/Main/settings.config)"
echor "nbxplorer \n $(cat $HOME/.nbxplorer/Main/settings.config)"

echoline
echor "#ELECTRS"
echor "electrs config \n $(cat $HOME/.electrs/config.toml)"
echor "ELECTRS_STREAM_FILE \n $(cat /tmp/nginx.conf_error)"

echoline
echor "#ELECTRUMX"
echor "elecrrumx config \n $(cat $HOME/parmanode/electrumx/electrumx.conf)"

echoline
echor "#FULCRUM"
echor "fulcrum config \n $(cat $HOME/parmanode/fulcrum/fulcrum.conf)"

echoline
echor "#LND"
echor "LND config \n $(cat $HOME/.lnd/lnd.conf)"

echoline
echor "#MEMPOOL"
echor "Mempool docker compose \n $(cat $hp/mempool/docker/docker-compose.yml)"

echoline
echor "#PUBLICPOOL"
echor "public pool env \n $(cat $hp/public_pool/.env)"


delete_private
mv $report $HOME/Desktop/

clear ; echo -e "
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
    Hit <enter> to finish.

########################################################################################
"
read
}

