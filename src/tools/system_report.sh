function system_report {

clear ; echo -e "
########################################################################################

    Parmanode will generate a System Report File automatically. It will
    then save the file to your desktop, and you can then email it to me for help.

    You could also also do a screen video recording of the problem. There
    is an option to do that in the tools menu.
    
    Hit$cyan <enter>$orange to continue

$red    'a'$orange and$cyan <enter>$orange to abort

########################################################################################
"
read -s choice ; clear
jump $choice 
case $choice in
a|q|Q) 
exit 
;;
esac

export omit="true" 
export report="$tmp/system_report.txt" 
export macprefix="/usr/local"
echo "PARMANODL SYSTEM REPORT $(date)", $(head -n1 $pn/version.conf | sed 's/\"//g' | cut -d = -f 2) > $report

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#DIRECTORY CHECKS"
#if dir doesn't exist, it will report
if [[ -d $HOME/parman_programs/parmanode ]] ; then
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "\$pn exists"
echor "$(git status)"
cat $pn/version.conf >> $report
else
echo "\$pn DOES NOT EXIST"
fi

#if dir doesn't exist, it will report
if [[ -d $HOME/.parmanode ]] ; then
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "\$dp exists"
echo -e "----------------------------------------------------------------------------------------" >> $report
cd $HOME/.parmanode
ls -am >> $report
else
echo "\$dp DOES NOT EXIST"
fi

echo -e "----------------------------------------------------------------------------------------" >> $report

#parmanode.conf
echor "#PARMNODE CONF"
echor "$(cat $HOME/.parmanode/parmanode.conf)"

echo -e "----------------------------------------------------------------------------------------" >> $report


echo -e "----------------------------------------------------------------------------------------" >> $report
#programs
echor "#PROGRAMS"
echor "#which nginx npm tor bitcoin-cli docker brew curl jq netstat tmux"
echor "$(which nginx npm tor bitcoin-cli docker brew curl jq netstat tmux)"

echo -e "----------------------------------------------------------------------------------------" >> $report
#tmux
echor "Tmux list..."
echor "$(tmux ls)"

echo -e "----------------------------------------------------------------------------------------" >> $report
#prinout of $dp
echor "#DOT PARMANODE PRINTOUT"
cd $HOME/.parmanode
echor "#printout of \$dp"
for file in * .* ; do
    if [[ -f $file && -s $file ]] ; then
    echor "FILE: $file \n $(cat $file) \n" 
    fi
done

echo -e "----------------------------------------------------------------------------------------" >> $report

echor "#HOME PARMANODE"
cd $HOME/parmanode
echor "$(ls -m)"

echo -e "----------------------------------------------------------------------------------------" >> $report

#NGINX
echor "#NGINX" 
echor "$(sudo nginx -t)"
cd "$macprefix/etc/nginx" && echor "$(pwd ; ls -m)"
cd "$macprefix/etc/nginx/conf.d" && echor "$(pwd ; ls -m)"
echor "$(file \"\$macprefix/etc/nginx/stream.conf\" && cat \"/etc/nginx/stream.conf\")"
echor "$(file \"\$macprefix/etc/nginx/nginx.conf\" && cat \"/etc/nginx/nginx.conf\")"
echor "NGINX ERROR FILE..."
echor "$(cat $tmp/nginx.conf_error)"

echo -e "----------------------------------------------------------------------------------------" >> $report

#BITCOIN
echor "#BITCOIN STUFF"
echor "IP is $IP"
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
fi

echo -e "----------------------------------------------------------------------------------------" >> $report

#DOCKER
echor "#DOCKER ..."
echor "docker ps -a \n $(docker ps -a)"
echor "docker ps \n $(docker ps) \n "
containers=$(docker ps -q)
echo "containers... \n $(docker ps -q)"
for i in $containers ; do
docker logs $i --tail 50 
echo -e "----------------------------------------------------------------------------------------\n" >> $report
done

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#BTCRPCEXPLORER"
echor "env \n $(cat $HOME/parmanode/btc-rpc-explorer/.env)"

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#BTCPAY"
echor "btcpay \n $(cat $HOME/.btcpayserver/Main/settings.config)"
echor "nbxplorer \n $(cat $HOME/.nbxplorer/Main/settings.config)"

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#ELECTRS"
echor "electrs config \n $(cat $HOME/.electrs/config.toml)"
echor "ELECTRS_STREAM_FILE \n $(cat $tmp/nginx.conf_error)"

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#ELECTRUMX"
echor "elecrrumx config \n $(cat $HOME/parmanode/electrumx/electrumx.conf)"

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#FULCRUM"
echor "fulcrum config \n $(cat $fc)"

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#LND"
echor "LND config \n $(cat $HOME/.lnd/lnd.conf)"
if [[ $OS == "Linux" ]] ; then echor "$(journalctl -exu lnd.service)" ; fi

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#MEMPOOL"
echor "Mempool docker compose \n $(cat $hp/mempool/docker/docker-compose.yml)"

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#PUBLICPOOL"
echor "public pool env \n $(cat $hp/public_pool/.env)"

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#TOR"
echor "$(which tor)"
echor "$(sudo cat $torrc)"

echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#THUNDERHUB"
echor "$(sudo cat $hp/thunderhub/account_1.yaml)"
echor ".env.locl contents"
echor "$(sudo cat $hp/thenderhub/.env.local | sed '/^#.*$/d' | sed '/^$/d')"

echo -e "----------------------------------------------------------------------------------------" >> $report

#system info
echor "#SYSTEM INFO"
if [[ $(uname) == Darwin ]] ; then echor "$(system_profiler SPHardwareDataType)" ; fi
echor "$(id)"
echor "$(uname) , $(uname -m)"
echor "$(env)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "$(df -h)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "$(sudo lsblk)"
echor "$(sudo blkid)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#MOUNT \n $(mount)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "$(free)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#HOME dir..."
echor "$(cd ; ls -lah)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "cpuinfo"
echor "$(cat /proc/cpuinfo | head -n10)"
echo -e "----------------------------------------------------------------------------------------" >> $report

echor "#BASHRC/ZSHRC"
echor "$(sudo cat $bashrc)"

delete_private
clear
mkdir -p $HOME/Desktop/ >/dev/null 
sudo mv $report $HOME/Desktop/ || enter_continue 

sleep 2
clear ; echo -e "
########################################################################################

    Parmanode has generated a system report about your installation, and left the
    file for you at: $cyan

    $HOME/Desktop/system_report.txt  $orange 
    
    You can now review this file, and if you were asked, can send this to Parman
    for assistance. The email is:
$cyan
    armantheparman@protonmail.com
$orange
    A note for$pink Ubuntu$orange users - File in the Desktop directory to show up on your 
    desktop. It's weird, I don't know why Ubuntu does that. You can access the file
    from the file explorer instead.

    Hit$cyan <enter>$orange to finish.

########################################################################################
"
read
}

function delete_private {
if [[ $omit == "true" ]] ; then
    rm $dp/sed.log >$dn
    rm $dp/debug.log >$dn
    rm $dp/change_string* >$dn
    if which gsed >$dn ; then
      cat $report | gsed '/coreAuth/d; /BTCEXP_BITCOIND/d; /rpcuser/d; /rpcpass/d; /auth = /d; /btc\.rpc\.user=/d; /btc\.rpc\.password=/d; /alias=/d; /bitcoind\.rpc/d; /DAEMON_URL =/d; /CORE_RPC_USERNAME/d; /CORE_RPC_PASSWORD/d; /BITCOIN_RPC_PASSWORD/d; /BITCOIN_RPC_USER/d; /multiPass/d' > $tmp/tempreport 
    elif which sed >$dn ; then
      cat $report | sed '/coreAuth/d; /BTCEXP_BITCOIND/d; /rpcuser/d; /rpcpass/d; /auth = /d; /btc\.rpc\.user=/d; /btc\.rpc\.password=/d; /alias=/d; /bitcoind\.rpc/d; /DAEMON_URL =/d; /CORE_RPC_USERNAME/d; /CORE_RPC_PASSWORD/d; /BITCOIN_RPC_PASSWORD/d; /BITCOIN_RPC_USER/d; /multiPass/d' > $tmp/tempreport 
    fi
mv $tmp/tempreport $report
fi
}

function echor {
echo -e "$1" >> "$report" 2>&1
}

